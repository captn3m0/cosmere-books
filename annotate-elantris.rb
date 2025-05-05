# frozen_string_literal: true

require 'date'
require 'fileutils'
require 'nokogiri'
require 'zip'
require_relative './methods'
require_relative './zip-file-generator'
require_relative './elantris-annotations'

FileUtils.mkdir_p('annotated-elantris')

Zip.on_exists_proc = true
Zip.continue_on_exists_proc = true

Zip::File.open('original-books/elantris.epub') do |zipfile|
  zipfile.each do |entry|
      FileUtils::mkdir_p(File.dirname("annotated-elantris/#{entry.name}"))
      zipfile.extract(entry, "annotated-elantris/#{entry.name}")
  end
end

Zip::File.open('books/elantris-annotations.epub') do |zipfile|
  zipfile.each do |entry|
    if (File.dirname(entry.name) == "EPUB/text")
      new_path = "annotated-elantris/OEBPS/xhtml/annotation-#{File.basename(entry.name)}"
        zipfile.extract(entry, new_path)
    end
  end
end

files = [
  {
    "annotation-ch002" => "title",
    "annotation-ch003" => "dedication",
    "annotation-ch004" => "acknowledgments",
    "annotation-ch005" => "prologue",
    "annotation-ch033" => "part1"
  },
  (1..4).map{|x| ["annotation-ch00#{5+x}", "chapter#{x}"]}.to_h,
  (5..27).map{|x| ["annotation-ch0#{5+x}", "chapter#{x}"]}.to_h,
  {"annotation-ch061" =>"part2"},
  (28..54).map{|x| ["annotation-ch0#{6+x}", "chapter#{x}"]}.to_h,
  {"annotation-ch072" => "part3"},
  (55..63).map{|x| ["annotation-ch0#{7+x}", "chapter#{x}"]}.to_h,
  {"annotation-ch071" => "epilogue"}
].reduce(:merge)

package = Nokogiri::XML(open("annotated-elantris/OEBPS/volume.opf"))
toc = Nokogiri::XML(open("annotated-elantris/OEBPS/nav.xhtml"))
toc.at_css('ol') << "<li><a href=\"xhtml/annotation-ch001.xhtml\">Annotations</a><ol id=\"annotations\"></ol></li>"

Dir.glob('annotated-elantris/OEBPS/xhtml/annotation-ch*.xhtml').sort.each {|file|
  page = File.basename(file, '.xhtml')
  package.at_css('manifest') << "<item id=\"#{page}\" href=\"xhtml/#{page}.xhtml\" media-type=\"application/xhtml+xml\" />"
  package.at_css('spine') << "<itemref idref=\"#{page}\" />"

  if files.key?(page)
    chapter = files[page]
    chapter_file = Nokogiri::XML(open("annotated-elantris/OEBPS/xhtml/#{chapter}.xhtml"))
    annotation_file = Nokogiri::XML(open(file))

    case chapter
    when 'title'
      id = '#tit'
    when 'dedication'
      id = '#ded'
    when 'acknowledgments'
      id = '.FMH'
    when 'prologue'
      id = '.CT'
    when 'epilogue'
      id = '.CT'
    when /part/
      id = '.PT'
    else
      id = '.CN'
    end

    chapter_file.at_css(id).next = "<a href=\"#{page}.xhtml\">Go to Annotations</a><br>"
    unless chapter.include?('title') || chapter.include?('dedication') || chapter.include?('part')
      chapter_file.at_css('body') << "<a href=\"#{page}.xhtml\">Go to Annotations</a><br>"
    end

    annotation_file.at_css('h1').next = "<a href=\"#{chapter}.xhtml\">Back to Chapter</a><br>"
    annotation_file.at_css('body') << "<a href=\"#{chapter}.xhtml\">Back to Chapter</a><br>"

    toc.at_css('#annotations') << "<li><a href=\"xhtml/#{page}.xhtml\">#{annotation_file.at_css('h1').inner_html}</a></li>"

    File.open("annotated-elantris/OEBPS/xhtml/#{chapter}.xhtml", 'w') { |file| file.write(chapter_file.to_xhtml) }
    File.open(file, 'w') { |file| file.write(annotation_file.to_xhtml) }
  end
}

File.open("annotated-elantris/OEBPS/volume.opf", 'w') { |file| file.write(package.to_xml) }
File.open("annotated-elantris/OEBPS/nav.xhtml", 'w') { |file| file.write(toc.to_xhtml) }

File.delete('books/annotated-elantris.epub') if File.exists? 'books/annotated-elantris.epub'
ZipFileGenerator.new('annotated-elantris', 'books/annotated-elantris.epub').write()

puts '[epub] Generated annotated EPUB file'
