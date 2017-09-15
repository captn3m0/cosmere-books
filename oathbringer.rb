require 'date'
require 'fileutils'
require 'nokogiri'
require_relative './methods'
FileUtils.mkdir_p("oathbringer")

BASE = 'https://www.tor.com/2017/'

links = [
    '08/22/oathbringer-brandon-sanderson-prologue/',
    '08/29/oathbringer-brandon-sanderson-chapter-1-3/',
    '09/05/oathbringer-by-brandon-sanderson-chapters-4-6/',
    '09/12/oathbringer-by-brandon-sanderson-chapters-7-9/'
]

links.last.split('/')

month = links.last.split('/').first
day = links.last.split('/')[1]

next_date = Date.new(2017, month.to_i, day.to_i) + 7

episode = 1

for link in links
    url = BASE + link
    puts "Download #{url}"
    if !File.exists? "oathbringer/#{episode}.html"
        `wget --no-clobber "#{url}" --output-document "oathbringer/#{episode}.html" -o /dev/null`
    end
    episode +=1
end

# Now we have all the files
html = ""
for i in 1..(links.length)
  page = Nokogiri::HTML(open("oathbringer/#{i}.html")).css('.entry-content')
  start = ending = false
  page.children.each do |e|
      if e.name == 'h3'
         e.name = 'h1'
         start = true
      end

      if e.attribute('class') and e['class'].include? 'frontmatter' and start
          ending = true
      end

      if !start or ending
          e.remove
      end
  end
  html += page.inner_html
  url = links[i-1]

  html += "<p>Visit <a href='#{url}'>tor.com</a> for discussion.</p>"
end

html += "<p>~fin\~<br>Next 3 chapters out on #{next_date.to_s}</p>"

File.open("books/Oathbringer.html", 'w') { |file| file.write(html) }
puts "[html] Generated HTML file"

generate("Oathbringer", :all)
