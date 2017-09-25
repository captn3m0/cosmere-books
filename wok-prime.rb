require 'date'
require 'fileutils'
require 'nokogiri'
require_relative './methods'

FileUtils.mkdir_p('wok-prime')

BASE = 'https://brandonsanderson.com/'.freeze

links = [
  'the-way-of-kings-prime-jeksonsonvallano/',
  'altered-perceptions/',
  'way-of-kings-prime-chapter-1-dalenar-1/',
  'way-of-kings-prime-chapter-3-merin-1/',
  'way-of-kings-prime-chapter-5-merin-2/'
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
for i in 1..(links.length)
  complete_html = Nokogiri::HTML(open("wok-prime/#{i}.html"))
  page = complete_html.css('article')[0]

  ending = false

  page.traverse do |e|
    whitelist = ['p', 'div', 'span', 'article', 'h1', 'h2', 'h3', 'h4', 'a', 'h5', 'h6', 'i', 'text']
    blacklist = ['.post-meta', '.addthis_toolbox', '.book-links', 'post-nav']
    if (whitelist.include?(e.name) == false)
      e.remove
    end

    blacklist.each do |selector|
      page.css(selector).each do |e|
        e.remove
      end
    end
  end

  html += page.inner_html
end

File.open('books/wok-prime.html', 'w') { |file| file.write(html) }
puts '[html] Generated HTML file'

generate('wok-prime', :all)
