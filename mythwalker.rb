# frozen_string_literal: true

require 'date'
require 'fileutils'
require 'nokogiri'
require_relative './methods'

FileUtils.mkdir_p('mythwalker')

BASE = 'https://brandonsanderson.com'

links = [
  "/warbreaker-prime-mythwalker-prologue/",
  "/warbreaker-prime-mythwalker-chapter-one/",
  "/warbreaker-prime-mythwalker-chapter-two/",
  "/warbreaker-prime-mythwalker-chapter-three/",
  "/warbreaker-prime-mythwalker-chapter-four/",
  "/warbreaker-prime-mythwalker-chapter-five/",
  "/warbreaker-prime-mythwalker-chapter-six/",
  "/warbreaker-prime-mythwalker-chapter-seven/",
  "/warbreaker-prime-mythwalker-chapter-eight/",
  "/warbreaker-prime-mythwalker-chapter-nine/",
  "/warbreaker-prime-mythwalker-chapter-ten/",
  "/warbreaker-prime-mythwalker-chapter-eleven/",
  "/warbreaker-prime-mythwalker-chapter-twelve/",
  "/warbreaker-prime-mythwalker-chapter-thirteen/",
  "/warbreaker-prime-mythwalker-chapter-fourteen/",
  "/warbreaker-prime-mythwalker-chapter-fifteen/",
  "/warbreaker-prime-mythwalker-chapter-sixteen/",
  "/warbreaker-prime-mythwalker-chapter-seventeen/",
  "/warbreaker-prime-mythwalker-chapter-eighteen/",
  "/warbreaker-prime-mythwalker-chapter-nineteen/",
  "/warbreaker-prime-mythwalker-chapter-twenty/",
  "/warbreaker-prime-mythwalker-chapter-twenty-one/",
  "/warbreaker-prime-mythwalker-chapter-twenty-two/",
  "/warbreaker-deleted-scenes-mab-the-cook/",
]

titles = ["Prologue"] + (1..22).map{|x| "Chapter #{x}"} + ["Deleted Scenes: Mab the Cook"]

episode=1
links.each do |link|
  url = BASE + link
  puts "Download #{url}"
  unless File.exist? "mythwalker/#{episode}.html"
    `wget --no-clobber "#{url}" --output-document "mythwalker/#{episode}.html" -o /dev/null`
  end
  episode+=1
end

html = '<html lang=en><head><title>Warbreaker Prime: Mythwalker</title></head><body>'

(1..(links.length)).each do |i|
  complete_html = Nokogiri::HTML(open("mythwalker/#{i}.html"))
  page = complete_html.css('.vc_col-sm-7 .wpb_wrapper')[0]
  html += "<h1>#{titles[i - 1]}</h1>" + page.inner_html
end

html += '</body></html>'

File.open('books/mythwalker.html', 'w') { |file| file.write(html) }
puts '[html] Generated HTML file'

generate('mythwalker', :all)
