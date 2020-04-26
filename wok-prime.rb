# frozen_string_literal: true

require 'date'
require 'fileutils'
require 'nokogiri'
require_relative './methods'

FileUtils.mkdir_p('wok-prime')

BASE = 'https://brandonsanderson.com/'

links = [
  'the-way-of-kings-prime-jeksonsonvallano/',
  'way-of-kings-prime-chapter-1-dalenar-1/',
  'way-of-kings-prime-chapter-3-merin-1/',
  'way-of-kings-prime-chapter-5-merin-2/',
  'way-of-kings-prime-chapter-12-merin-3/',
  'way-of-kings-prime-chapter-17-merin-4/',
  'way-of-kings-prime-chapter-22-merin-5/',
  'dragonsteel-prime-chapter-25-bridge-four-1/',
  'dragonsteel-prime-chapter-28-bridge-four-2/',
  'dragonsteel-prime-chapter-30-bridge-four-3/',
  'dragonsteel-prime-chapter-31-bridge-four-4/',
  'dragonsteel-prime-chapter-33-bridge-four-5/',
  'dragonsteel-prime-chapter-35-bridge-four-6/',
  'dragonsteel-prime-chapter-37-bridge-four-7/',
  'the-way-of-kings-chapter-13-d/',
  'the-way-of-kings-chapter-15-d/',
  'the-way-of-kings-chapter-16-d/',
  'the-way-of-kings-chapter-18-d/',
  'the-way-of-kings-chapter-20-d/',
  'the-way-of-kings-chapters-23-and-24-d/',
  'the-way-of-kings-chapter-26-d/',
  'the-way-of-kings-chapter-28-d/',
  'the-way-of-kings-early-brainstorms-outlines/',
  'the-way-of-kings-tiens-death-attempt-1/'
]

episode = 1

links.each do |link|
  url = BASE + link
  puts "Download #{url}"
  unless File.exist? "wok-prime/#{episode}.html"
    `wget --no-clobber "#{url}" --output-document "wok-prime/#{episode}.html" -o /dev/null`
  end
  episode += 1
end

html = '<html lang=en><head><title>Way of Kings Prime</title></head><body>'

(1..(links.length)).each do |i|
  complete_html = Nokogiri::HTML(open("wok-prime/#{i}.html"))
  page = complete_html.css('.vc_col-sm-7 .vc_column-inner .wpb_content_element .wpb_wrapper')[0]

  ending = false

  begin
    page.traverse do |e|
      whitelist = %w[p div span article h1 h2 h3 h4 a h5 h6 i text]
      blacklist = ['.post-meta', '.addthis_toolbox', '.book-links', 'post-nav']
      e.remove if whitelist.include?(e.name) == false

      blacklist.each do |selector|
        page.css(selector).each(&:remove)
      end
    end
  rescue Exception => e
    puts e
    puts page.class
  end

  html += "<h1>#{links[i - 1][0...-1]}</h1>" + page.inner_html
end

html += '</body></html>'

File.open('books/wok-prime.html', 'w') { |file| file.write(html) }
puts '[html] Generated HTML file'

generate('wok-prime', :all)
