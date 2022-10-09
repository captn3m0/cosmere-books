# frozen_string_literal: true

require 'uri'
require 'date'
require 'fileutils'
require 'nokogiri'
require_relative './methods'
FileUtils.mkdir_p('lost-metal')

BASE = 'https://www.tor.com/2022/'

links = [
  '09/19/read-the-lost-metal-by-brandon-sanderson-prologue-and-chapters-1-2/',
  '09/26/read-the-lost-metal-by-brandon-sanderson-chapters-3-4/',
  '10/03/read-the-lost-metal-by-brandon-sanderson-chapters-5-8/'
]

episode = 1

counter = 0

links.each do |link|
  url = BASE + link
  puts "Download #{url}"
  unless File.exist? "lost-metal/#{episode}.html"
    `wget --no-clobber "#{url}" --output-document "lost-metal/#{episode}.html" -o /dev/null`
  end
  episode += 1
end

# Now we have all the files
html = ''
for i in 1..(links.length)
  page = Nokogiri::HTML(open("lost-metal/#{i}.html")).css('.entry-content')
  start = ending = false
  page.children.each do |e|
    if ['h1', 'h2', 'h3', 'h4', 'hr'].include? e.name
      e.remove
    end

    if e.text ==' '
      e.remove
    end

    if e.name == 'p'
      e.children.each do |ee|
        if ee.name == 'img'
          u = URI::parse ee['src']
          if counter == 0
            e.add_previous_sibling "<h1>Prologue</h1>"
          else
            e.add_previous_sibling "<hr><h1> Chapter #{counter}"
          end
          counter += 1
          ee.delete 'srcset'
          ee.delete 'class'
          ee.delete 'loading'
          ee.delete 'sizes'
          ee.delete 'data-recalc-dims'
        end
      end
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
