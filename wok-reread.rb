require 'date'
require 'fileutils'
require 'nokogiri'
require_relative './methods'

FileUtils.mkdir_p("wok")

BASE = 'https://www.tor.com/'

links = [
  "2013/03/14/the-way-of-kings-reread-introduction/",
  "2013/03/28/the-way-of-kings-reread-prelude-to-the-stormlight-archive/",
  "2013/04/04/the-way-of-kings-reread-prologue-to-kill/",
  "2013/04/11/the-way-of-kings-reread-chapter-1-and-chapter-2/",
  "2013/04/18/the-way-of-kings-reread-chapters-3-and-4/",
  "2013/04/25/the-way-of-kings-reread-chapters-5-and-6/",
  "2013/05/02/the-way-of-kings-reread-chapter-7-and-chapter-8/",
  "2013/05/09/the-way-of-kings-reread-chapters-9-and-10/",
  "2013/05/16/the-way-of-kings-reread-chapter-11/",
  "2013/05/23/the-way-of-kings-reread-interludes-1-2-3/",
  "2013/05/30/the-way-of-kings-reread-chapter-12/",
  "2013/06/06/the-way-of-kings-reread-chapters-13-and-14/",
  "2013/06/13/the-way-of-kings-reread-chapter-15/",
  "2013/06/20/the-way-of-kings-reread-chapters-16-and-17/",
  "2013/06/27/the-way-of-kings-reread-chapter-18/",
  "2013/07/11/the-way-of-kings-reread-chapters-19-and-20/",
  "2013/07/18/the-way-of-kings-reread-chapters-21-and-22/",
  "2013/07/25/the-way-of-kings-reread-chapter-23-and-24/",
  "2013/08/01/the-way-of-kings-reread-chapters-25-and-26/",
  "2013/08/08/the-way-of-kings-reread-chapters-27-and-28/",
  "2013/08/15/the-way-of-kings-reread-epigraphs-to-part-two/",
  "2013/08/22/the-way-of-kings-reread-interludes-i-4-i-5-and-i-6/",
  "2013/09/05/the-way-of-kings-reread-chapter-29/",
  "2013/09/12/the-way-of-kings-reread-chapter-30/",
  "2013/09/19/the-way-of-kings-reread-chapters-31-and-32/",
  "2013/09/26/the-way-of-kings-reread-chapter-33/",
  "2013/10/03/the-way-of-kings-reread-chapters-34-35-and-36/",
  "2013/10/10/the-way-of-kings-reread-chapter-37/",
  "2013/10/17/the-way-of-kings-reread-chapters-38-and-39/",
  "2013/10/24/the-way-of-kings-reread-chapters-40-and-41/",
  "2013/10/31/the-way-of-kings-reread-chapters-42-and-43/",
  "2013/11/07/the-way-of-kings-reread-chapter-44/",
  "2013/11/14/the-way-of-kings-reread-chapter-45/",
  "2013/11/21/the-way-of-kings-reread-chapter-46/",
  "2013/12/05/the-way-of-kings-reread-chapter-47/",
  "2013/12/12/the-way-of-kings-reread-chapter-48/",
  "2013/12/19/the-way-of-kings-reread-chapter-49/",
  "2014/01/02/the-way-of-kings-reread-chapters-50-and-51/",
  "2014/01/09/the-way-of-kings-reread-interludes-i-7-i-8-and-i-9/",
  "2014/01/16/the-way-of-kings-reread-chapter-52/",
  "2014/01/23/the-way-of-kings-reread-chapters-53-and-54/",
  "2014/01/30/the-way-of-kings-reread-chapter-55/",
  "2014/02/06/the-way-of-kings-reread-chapter-56/",
  "2014/02/13/the-way-of-kings-reread-chapter-57/",
  "2014/02/20/the-way-of-kings-reread-chapter-58/",
  "2014/02/27/the-way-of-kings-reread-chapter-59/",
  "2014/03/20/the-way-of-kings-reread-chapters-60-and-61/",
  "2014/03/27/the-way-of-kings-reread-chapters-62-and-63/",
  "2014/04/03/the-way-of-kings-reread-chapters-64-and-65/",
  "2014/04/10/the-way-of-kings-reread-chapters-66-and-67/",
  "2014/04/17/the-way-of-kings-reread-chapter-68/",
  "2014/04/24/the-way-of-kings-reread-chapter-69/",
  "2014/05/01/the-way-of-kings-reread-chapters-70-and-71/",
  "2014/05/08/the-way-of-kings-reread-chapters-72-and-73/",
  "2014/05/15/the-way-of-kings-reread-chapters-74-and-75/",
  "2014/05/22/the-way-of-kings-reread-epilogue-and-all-that-comes-after/",
  "2014/06/10/brandon-sanderson-answers-your-questions-about-the-way-of-kings/"
]

episode = 1

for link in links
    url = BASE + link
    puts "Download #{url}"
    if !File.exists? "wok/#{episode}.html"
        `wget --no-clobber "#{url}" --output-document "wok/#{episode}.html" -o /dev/null`
    end
    episode +=1
end

# Now we have all the files
html = ""
for i in 1..(links.length)
  complete_html = Nokogiri::HTML(open("wok/#{i}.html"))
  page = complete_html.css('.entry-content')
  title = complete_html.css('.entry-title>a').inner_html
  # Removes all UK cover images
  page.css('.alignleft').remove
  ending = false
  page.children.each do |e|

      if e.attribute('class') and (e['class'].include? 'squib' or e['class'].include? 'post-end-spacer')
          ending = true
      end

      if ending
        e.remove
      end
  end
  html += "<h1>#{title}</h1>"
  html += page.inner_html

  url = links[i-1]

  html += "<p>Visit <a href='#{url}'>tor.com</a> for discussion.</p>"
end

File.open("books/wok-reread.html", 'w') { |file| file.write(html) }
puts "[html] Generated HTML file"

generate("wok-reread", :all)
