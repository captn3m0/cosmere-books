# frozen_string_literal: true

require 'date'
require 'fileutils'
require 'nokogiri'
require_relative './methods'

FileUtils.mkdir_p('wok-prime')

BASE = 'https://brandonsanderson.com/'

links = [
  'the-way-of-kings-prime-jeksonsonvallano/',
  'altered-perceptions/',
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
  'the-way-of-kings-chapter-18-d/'
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

html = ''
(1..(links.length)).each do |i|
  complete_html = Nokogiri::HTML(open("wok-prime/#{i}.html"))
  page = complete_html.css('article')[0]

  ending = false

  page.traverse do |e|
    whitelist = %w[p div span article h1 h2 h3 h4 a h5 h6 i text]
    blacklist = ['.post-meta', '.addthis_toolbox', '.book-links', 'post-nav']
    e.remove if whitelist.include?(e.name) == false

    blacklist.each do |selector|
      page.css(selector).each(&:remove)
    end
  end

  html += page.inner_html
end

File.open('books/wok-prime.html', 'w') { |file| file.write(html) }
puts '[html] Generated HTML file'

generate('wok-prime', :all)
