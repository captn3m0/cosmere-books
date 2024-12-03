class Myhtml::Iterator::Collection
  include ::Indexable(Node)
  include Iterator::Filter

  @tree : Tree
  @length : LibC::SizeT
  @list : Lib::MyhtmlTreeNodeT**
  @raw_collection : Lib::MyhtmlCollectionT*

  def initialize(@tree, @raw_collection)
    if @raw_collection.null?
      @length = LibC::SizeT.new(0)
      @list = Pointer(Lib::MyhtmlTreeNodeT*).new(0)
    else
      @length = @raw_collection.value.length
      @list = @raw_collection.value.list
    end
    @finalized = false
  end

  def size
    @length
  end

  def unsafe_fetch(index : Int)
    node = @list[index]
    Node.new(@tree, node)
  end

  def finalize
    free
  end

  def free
    unless @finalized
      @finalized = true
      Lib.collection_destroy(@raw_collection)
    end
  end

  def inspect(io)
    io << "#<Myhtml::Iterator::Collection:0x"
    object_id.to_s(io, 16)
    io << ": elements: "

    io << '['

    count = {2, @length}.min
    count.times do |i|
      Node.new(@tree, @list[i]).inspect(io)
      io << ", " unless i == count - 1
    end

    io << ", ...(#{@length - 2} more)" if @length > 2
    io << ']'

    io << '>'
  end
end
