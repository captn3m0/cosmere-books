# frozen_string_literal: true

require 'date'
require 'fileutils'
require 'nokogiri'
require_relative './methods'

FileUtils.mkdir_p('elantris-annotations')

BASE = 'https://brandonsanderson.com'

links = ["/annotation-elantris-introduction/"] +
  ["/annotation-elantris-title-page/"] +
  ["/annotation-elantris-dedication/"] +
  ["/annotation-elantris-acknowledgements-page/"] +
  ["/annotation-elantris-prologue/"] +
  (1..27).map{|x| "/annotation-elantris-chapter-#{x}/"} +
  ["/annotation-elantris-part-one-wrap-up/"] +
  (28..45).map{|x| "/annotation-elantris-chapter-#{x}/"} +
  (1..2).map{|x| "/annotation-elantris-chapter-46-#{x}/"} +
  (47..48).map{|x| "/annotation-elantris-chapter-#{x}/"} +
  (1..2).map{|x| "/annotation-elantris-49-#{x}/"} +
  (50..52).map{|x| "/annotation-elantris-chapter-#{x}/"} +
  (1..3).map{|x| "/annotation-elantris-53-#{x}/"} +
  ["/annotation-elantris-chapter-54/"] +
  ["/annotation-elantris-part-two-wrap-up/"] +
  (55..57).map{|x| "/annotation-elantris-chapter-#{x}/"} +
  (1..4).map{|x| "/annotation-elantris-58-#{x}/"} +
  (1..2).map{|x| "/annotation-elantris-59-#{x}/"} +
  (1..4).map{|x| "/annotation-elantris-60-#{x}/"} +
  (1..4).map{|x| "/annotation-elantris-61-#{x}/"} +
  (1..3).map{|x| "/annotation-elantris-62-#{x}/"} +
  ["/annotation-elantris-chapter-63/"] +
  ["/annotation-elantris-epilogue/"] +
  ["/annotation-elantris-book-wrap-up/"]

titles = ["Introduction"] +
  ["Title Page"] +
  ["Dedication"] +
  ["Acknowledgements"] +
  ["Prologue"] +
  (1..27).map{|x| "Chapter #{x}"} +
  ["Part One Wrap-Up"] +
  (28..45).map{|x| "Chapter #{x}"} +
  (1..2).map{|x| "Chapter 46"} +
  (47..48).map{|x| "Chapter #{x}"} +
  (1..2).map{|x| "Chapter 49"} +
  (50..52).map{|x| "Chapter #{x}"} +
  (1..3).map{|x| "Chapter 53"} +
  ["Chapter 54"] +
  ["Part Two Wrap-Up"] +
  (55..57).map{|x| "Chapter #{x}"} +
  (1..4).map{|x| "Chapter 58"} +
  (1..2).map{|x| "Chapter 59"} +
  (1..4).map{|x| "Chapter 60"} +
  (1..4).map{|x| "Chapter 61"} +
  (1..3).map{|x| "Chapter 62"} +
  ["Chapter 63"] +
  ["Epilogue"] +
  ["Book Wrap-Up"]

episode=1
links.each do |link|
  url = BASE + link
  puts "Download #{url}"
  unless File.exist? "elantris-annotations/#{episode}.html"
    `wget --no-clobber "#{url}" --output-document "elantris-annotations/#{episode}.html" -o /dev/null`
  end
  episode+=1
end

html = '<html lang=en><head><title>Elantris Annotations</title></head><body>'

(1..(links.length)).each do |i|
  complete_html = Nokogiri::HTML(open("elantris-annotations/#{i}.html"))

  # Show all spoiler sections
  complete_html.css('.sh-content.sh-hide').each do |e|
    e.remove_attribute("style")
  end

  # For whatever reason, these pages have a different class on the container.
  if [82,83,84].include? i
    page = complete_html.css('.vc_col-sm-8 .wpb_wrapper')[1]
  else
    page = complete_html.css('.vc_col-sm-7 .wpb_wrapper')[0]
  end

  # Some chapters have the annotations split in several parts. This appends them all to their first parts.
  if [53,57,62,63,70,71,72,74,76,77,78,80,81,82,84,85].include? i
    html += "<hr>" + page.inner_html
  else
    html += "<h1>Annotations for #{titles[i - 1]}</h1>" + page.inner_html
  end
end

html += '</body></html>'

html.gsub! "Show Spoiler", "Spoiler Ahead"

File.open('books/elantris-annotations.html', 'w') { |file| file.write(html) }
puts '[html] Generated HTML file'

generate('elantris-annotations', :all)
