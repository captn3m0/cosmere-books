require 'fileutils'
require 'nokogiri'
require_relative './methods'

FileUtils.mkdir_p('skyward')

BASE = 'https://www.getunderlined.com'.freeze

links = [
  '/read/excerpt-reveal-start-reading-skyward-by-brandon-sanderson/'
]

episode = 1
links.each do |link|
  url = BASE + link
  puts "Download #{url}"
  unless File.exist? "skyward/#{episode}.html"
    `wget --no-clobber "#{url}" --output-document "skyward/#{episode}.html"`
  end
  episode += 1
end

html = '<title>Skyward</title>'
for i in 1..(links.length)
  complete_html = Nokogiri::HTML(open("skyward/#{i}.html"))
  page = complete_html.css('article')[0]
  html += page.inner_html
end


File.open('books/skyward.html', 'w') { |file| file.write(html) }
puts '[html] Generated HTML file'

generate('skyward', :all)
