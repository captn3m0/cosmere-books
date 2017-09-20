require 'date'
require 'fileutils'
require 'nokogiri'
require_relative './methods'
FileUtils.mkdir_p('oathbringer')

BASE = 'https://www.tor.com/2017/'.freeze

links = [
  '08/22/oathbringer-brandon-sanderson-prologue/',
  '08/29/oathbringer-brandon-sanderson-chapter-1-3/',
  '09/05/oathbringer-by-brandon-sanderson-chapters-4-6/'
]

manually_add_links = false;

if manually_add_links
  # Only downloads links already added to array <links>
  puts 'Downloading manually added links'
  links.last.split('/')
  month = links.last.split('/').first
  day = links.last.split('/')[1]
  next_date = Date.new(2017, month.to_i, day.to_i) + 7
else
  # Automatically adds all recent chapters
  puts 'Downloading all found links'
  chapter = Integer(links.last.split('-').last.gsub(/[^0-9]/, '')) + 1
  puts chapter
  next_date = Date.new(1970,01,01)
  loop do
    links.last.split('/')
    month = links.last.split('/').first
    day = links.last.split('/')[1]
    next_date = Date.new(2017, month.to_i, day.to_i) + 7
    links << "#{next_date.strftime("%m")}/#{next_date.strftime("%d")}/oathbringer-by-brandon-sanderson-chapters-#{chapter}-#{chapter + 2}/"
    chapter += 3;
    puts next_date
    break if next_date + 7 > Date.today
   end
   next_date += 7;
end

episode = 1

links.each do |link|
  url = BASE + link
  puts "Download #{url}"
  unless File.exist? "oathbringer/#{episode}.html"
    `wget --no-clobber "#{url}" --output-document "oathbringer/#{episode}.html" -o /dev/null`
  end
  episode += 1
end

# Now we have all the files
html = ''
for i in 1..(links.length)
  page = Nokogiri::HTML(open("oathbringer/#{i}.html")).css('.entry-content')
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
  url = links[i - 1]

  html += "<p>Visit <a href='#{url}'>tor.com</a> for discussion.</p>"
end

html += "<p>~fin\~<br>Next 3 chapters out on #{next_date}</p>"

File.open('books/Oathbringer.html', 'w') { |file| file.write(html) }
puts '[html] Generated HTML file'

generate('Oathbringer', :all)
