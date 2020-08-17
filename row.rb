# frozen_string_literal: true

require 'date'
require 'fileutils'
require 'nokogiri'
require_relative './methods'
FileUtils.mkdir_p('row')

BASE = 'https://www.tor.com/2020/'

links = [
  '07/23/read-rhythm-of-war-by-brandon-sanderson-prologue-and-chapter-one/',
  '07/28/read-rhythm-of-war-by-brandon-sanderson-chapters-two-and-three/',
  '08/04/read-rhythm-of-war-by-brandon-sanderson-chapters-four-and-five/',
  '08/11/read-rhythm-of-war-by-brandon-sanderson-chapter-six/'
]

# Automatically adds all recent chapters
puts 'Downloading all found links'
chapter = 5
next_date = Date.new(1970, 1, 1)
loop do
  links.last.split('/')
  month = links.last.split('/').first
  day = links.last.split('/')[1]
  next_date = Date.new(2020, month.to_i, day.to_i) + 7
  break if next_date > Date.today

  ending_chapter = [chapter + 2, 32].min
  links << "#{next_date.strftime('%m')}/#{next_date.strftime('%d')}/read-rhythm-of-war-by-brandon-sanderson-chapters-#{chapter}-#{ending_chapter}/"
  chapter += 3
  break if next_date + 7 > Date.today
end
next_date += 7

episode = 1

links.each do |link|
  url = BASE + link
  puts "Download #{url}"
  unless File.exist? "row/#{episode}.html"
    `wget --no-clobber "#{url}" --output-document "row/#{episode}.html" -o /dev/null`
  end
  episode += 1
end

# Now we have all the files
html = ''
(1..(links.length)).each do |i|
  page = Nokogiri::HTML(open("row/#{i}.html")).css('.entry-content')
  start = ending = false
  page.children.each do |e|
    if e.name == 'h3'
      e.name = 'h1'
      start = true
    end

    ending = true if e.class?('frontmatter') && start

    e.remove if !start || ending
  end
  html += page.inner_html
  url = BASE + links[i - 1]
end

html += "<p>Next 3 chapters out on #{next_date}</p>"

File.open('books/row.html', 'w') { |file| file.write(html) }
puts '[html] Generated HTML file'

generate('row', :all)
