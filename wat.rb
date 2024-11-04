# frozen_string_literal: true

require 'date'
require 'fileutils'
require 'nokogiri'
require_relative './methods'
FileUtils.mkdir_p('wat')

BASE = 'https://reactormag.com/read-wind-and-truth-by-brandon-sanderson-'

links = [
  'preface-and-prologue/',
  'chapters-1-and-2/',
  'chapters-3-and-4/',
  'chapters-5-and-6/',
  'chapters-7-8-and-9/',
  'chapters-10-and-11/',
  'chapters-12-and-13/',
  'interludes-1-and-2/',
  'chapters-14-and-15/',
  'chapters-16-17-and-18/',
  'chapters-19-and-20/',
  'chapters-21-and-22/',
  'chapters-23-and-24/',
  'chapters-25-and-26/',
]

# Automatically adds all recent chapters
puts 'Downloading all found links'
episode = 1

links.each do |link|
  url = BASE + link
  puts "Download #{url}"
  unless File.exist? "wat/#{episode}.html"
    `wget --no-clobber "#{url}" --output-document "wat/#{episode}.html" -o /dev/null`
  end
  episode += 1
end

# Now we have all the files
html = ''
audiobook_links = []
(1..(links.length)).each do |i|
  page = Nokogiri::HTML(open("wat/#{i}.html")).css('article-content')
  page.css('a[href^="https://soundcloud.com/macaudio-2/"]').each do |sc_url|
    audiobook_links << sc_url['href']
  end
  start = ending = false
  page.children.each do |e|
    if e.name == 'h3'
      e.name = 'h1'
      start = true
    end

    ending = true if e.text.include?("Excerpted") && start

    e.remove if !start || ending
  end
  chapter_html = page.inner_html.sub(/<h1/, "<h1 id='chapter-#{i-1}'")
  html += chapter_html
  url = BASE + links[i - 1]
end

File.open('books/wat.html', 'w') { |file| file.write(html) }
puts '[html] Generated HTML file'

File.open('books/wat-audio.txt', 'w') { |file| file.write(audiobook_links.join("\n")) }
puts '[html] Generated Audiobook Listing'

generate('wat', :all)
