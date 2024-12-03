require "compress/zip"
require "http/client"

class EPUBGenerator
  def initialize(input_dir : String, output_file : String)
    @input_dir = input_dir
    @output_file = output_file
    @images_dir = File.join(@input_dir, "images")
    Dir.mkdir_p(@images_dir)

    @metadata = <<-XML
    <dc:identifier id="epub-id-1">1250319188</dc:identifier>
    <dc:identifier id="epub-id-2">978-1250319180</dc:identifier>
    <dc:title id="epub-title-1">Wind and Truth: Book Five of the Stormlight Archive</dc:title>
    <dc:date>2024-12-06</dc:date>
    <dc:language>en-US</dc:language>
    <dc:creator id="epub-creator-1">Brandon Sanderson</dc:creator>
    <meta property="dcterms:modified">2024-11-03T15:18:10Z</meta>
    XML

    @html_files = Dir.glob(File.join(@input_dir, "*.html")).sort
    @title = "Wind and Truth: Book Five of the Stormlight Archive"
  end

  private def parse_metadata(xml : String) : Hash(String, String)
    metadata = Hash(String, String).new
    doc = XML.parse(xml)

    doc.root.children.each do |child|
      next unless child.is_a?(XML::Element)
      metadata[child.name] = child.text
    end

    metadata
  end

  private def download_images(html_file : String) : String
    html = File.read(html_file)
    updated_html = html.dup
    image_urls = html.scan(/<img\s[^>]*src=["'](https?:\/\/[^"']+)["']/).map(&.first)

    image_urls.each_with_index do |url, index|
      file_ext = File.extname(URI.parse(url).path)
      local_file = File.join(@images_dir, "image_#{index + 1}#{file_ext}")

      # Download image
      HTTP::Client.get(url) do |response|
        File.open(local_file, "w") { |f| f.write(response.body_io) }
      end

      # Replace URL in HTML
      updated_html.gsub!(url, "images/#{File.basename(local_file)}")
    end

    updated_html
  end

  private def create_container
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
      <rootfiles>
        <rootfile full-path="content.opf" media-type="application/oebps-package+xml"/>
      </rootfiles>
    </container>
    XML
  end

  private def generate_content_opf
    manifest = @html_files.map_with_index do |file, index|
      <<-XML
      <item id="chapter#{index + 1}" href="chapters/#{File.basename(file)}" media-type="application/xhtml+xml"/>
      XML
    end.join

    spine = @html_files.map_with_index do |_, index|
      <<-XML
      <itemref idref="chapter#{index + 1}"/>
      XML
    end.join

    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <package version="3.0" xmlns="http://www.idpf.org/2007/opf" unique-identifier="epub-id-1" prefix="ibooks: http://vocabulary.itunes.apple.com/rdf/ibooks/vocabulary-extensions-1.0/">
    <metadata xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">
    #{@metadata}
    </metadata>
    <manifest>
    #{manifest}
    </manifest>
    <spine>
    #{spine}
    </spine>
    </package>
    XML
  end

  private def generate_toc
    toc_items = @html_files.map_with_index do |file, index|
      <<-HTML
      <li><a href="chapters/#{File.basename(file)}">Chapter #{index + 1}</a></li>
      HTML
    end.join

    <<-HTML
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>Table of Contents</title>
      </head>
      <body>
        <nav epub:type="toc" id="toc">
          <h1>#{@title}</h1>
          <ol>
            #{toc_items}
          </ol>
        </nav>
      </body>
    </html>
    HTML
  end

  def generate
    File.open(@output_file, "w") do |file|
      Compress::Zip::Writer.open(file) do |zip|
        # ERROR(PKG-007): ./wat.epub(-1,-1): Mimetype file should only contain
        # the string "application/epub+zip" and should not be compressed.
        entry = Compress::Zip::Writer::Entry.new("mimetype")
        entry.compression_method = Compress::Zip::CompressionMethod::STORED
        entry.compressed_size = 20_u32
        entry.uncompressed_size = 20_u32
        entry.crc32 = 749429103_u32
        zip.add(entry) do |io|
          io.write_string("application/epub+zip".to_slice)
          io.close
        end

        zip.add("META-INF/container.xml", create_container)
        zip.add("content.opf", generate_content_opf)
        zip.add("toc.xhtml", generate_toc)

        @html_files.each do |chapter|
          puts chapter
          zip.add("chapters/#{File.basename(chapter)}", File.open(chapter))
        end

        Dir.glob("images/*").each do |image|
          zip.add("images/#{File.basename(image)}", File.open(image))
        end
      end
    end
  end
end
