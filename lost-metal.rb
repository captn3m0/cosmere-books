# frozen_string_literal: true

require 'date'
require 'fileutils'
require 'nokogiri'
require_relative './methods'
FileUtils.mkdir_p('lost-metal')

BASE = 'https://www.tor.com/2022/'

links = [
  '09/19/read-the-lost-metal-by-brandon-sanderson-prologue-and-chapters-1-2/',
]

episode = 1

links.each do |link|
  url = BASE + link
  puts "Download #{url}"
  unless File.exist? "lost-metal/#{episode}.html"
    `wget --no-clobber "#{url}" --output-document "lost-metal/#{episode}.html" -o /dev/null`
  end
  episode += 1
end

# Now we have all the files
html = '<h1>Prologue</h1>'
for i in 1..(links.length)
  page = Nokogiri::HTML(open("lost-metal/#{i}.html")).css('.entry-content')
  start = ending = false
  page.children.each do |e|
    if e.name == 'h4'
      e.name = 'h1'
    end

    if e.name == 'h3'
      e.name = 'div'
    end

    start = true if e.class?('ebook-link-wrapper')
    ending = true if e.class?('frontmatter') && start

    e.remove if !start || ending || e.class?('ebook-link-wrapper')
  end

  html += page.inner_html
  url = BASE + links[i - 1]

  html += "<p>Visit <a href='#{url}'>tor.com</a> for discussion.</p>"
end

File.open('books/lost-metal.html', 'w') { |file| file.write(html) }
puts '[html] Generated HTML file'

generate('lost-metal', :all)
