require 'date'
require 'fileutils'
require 'nokogiri'
require_relative './methods'

FileUtils.mkdir_p('oathbringer-reread')

BASE = 'https://www.tor.com'.freeze

links = [
  "/2018/01/25/introducing-the-oathbringer-reread/",
  "/2018/02/01/oathbringer-reread-prologue/",
  "/2018/02/08/oathbringer-reread-chapter-one/",
  "/2018/02/15/oathbringer-reread-chapter-two/",
  "/2018/02/22/oathbringer-reread-chapter-three/",
  "/2018/03/01/oathbringer-reread-chapter-four/",
  "/2018/03/08/oathbringer-reread-chapters-five-and-six/",
  "/2018/03/15/oathbringer-reread-chapter-seven/",
  "/2018/03/22/oathbringer-reread-chapters-eight-and-nine/",
  "/2018/03/29/oathbringer-reread-chapter-ten/",
  "/2018/04/05/oathbringer-reread-chapter-eleven/",
  "/2018/04/12/oathbringer-reread-chapter-12/",
  "/2018/04/19/oathbringer-reread-chapter-thirteen/",
  "/2018/04/26/oathbringer-reread-chapters-fourteen-and-fifteen/",
  "/2018/05/03/oathbringer-reread-chapter-16/",
  "/2018/05/10/oathbringer-reread-chapter-seventeen/",
  "/2018/05/17/oathbringer-reread-chapter-eighteen/",
  "/2018/05/24/oathbringer-reread-chapters-19-and-20-brandon-sanderson/",
  "/2018/05/31/oathbringer-reread-chapters-twenty-one-and-twenty-two/",
  "/2018/06/07/oathbringer-reread-chapters-twenty-three-and-twenty-four/",
  "/2018/06/14/oathbringer-reread-chapter-twenty-five/",
  "/2018/06/21/oathbringer-reread-chapters-twenty-six-and-twenty-seven/",
  "/2018/06/28/oathbringer-reread-chapter-twenty-eight/",
  "/2018/07/05/oathbringer-reread-chapters-twenty-nine-and-thirty/",
  "/2018/07/12/oathbringer-reread-chapters-thirty-one-and-thirty-two/",
  "/2018/07/19/oathbringer-reread-interludes-one-two-and-three/",
  "/2018/07/26/oathbringer-reread-chapter-thirty-three/",
  "/2018/08/02/oathbringer-reread-chapter-thirty-four/",
  "/2018/08/09/oathbringer-reread-chapter-thirty-five/",
  "/2018/08/16/oathbringer-reread-chapters-thirty-six-and-thirty-seven/",
  "/2018/08/23/oathbringer-reread-chapter-thirty-eight/",
  "/2018/08/30/oathbringer-reread-chapters-thirty-nine-and-forty/",
  "/2018/09/06/oathbringer-reread-chapters-forty-one-and-forty-two/",
  "/2018/09/13/oathbringer-reread-chapters-forty-three-and-forty-four/",
  "/2018/09/20/oathbringer-reread-chapters-forty-five-and-forty-six/",
  "/2018/09/27/oathbringer-reread-chapters-forty-seven-and-forty-eight/",
  "/2018/10/04/oathbringer-reread-chapter-forty-nine/",
  "/2018/10/11/oathbringer-reread-chapters-fifty-and-fifty-one/",
  "/2018/10/18/oathbringer-reread-chapter-fifty-two/",
  "/2018/10/25/oathbringer-reread-chapter-fifty-three/",
  "/2018/11/01/oathbringer-reread-chapter-fifty-four/",
  "/2018/11/08/oathbringer-reread-chapter-fifty-five/",
  "/2018/11/15/oathbringer-reread-chapter-fifty-six/",
  "/2018/11/29/oathbringer-reread-chapter-fifty-seven/",
  "/2018/12/06/oathbringer-reread-interlude-four-kaza/",
  "/2018/12/13/oathbringer-reread-interlude-five-taravangian/",
  "/2018/12/20/oathbringer-reread-interlude-six-venli/",
  "/2019/01/03/oathbringer-reread-chapters-fifty-eight-and-fifty-nine/",
  "/2019/01/10/oathbringer-reread-chapter-sixty/",
  "/2019/01/17/oathbringer-reread-chapter-sixty-one/",
  "/2019/01/24/oathbringer-reread-chapter-sixty-two/",
  "/2019/01/31/oathbringer-reread-chapter-sixty-three/",
  "/2019/02/07/oathbringer-reread-chapter-sixty-four/",
  "/2019/02/14/oathbringer-reread-chapter-sixty-five/",
  "/2019/02/21/oathbringer-reread-chapter-sixty-six/",
  "/2019/02/28/oathbringer-reread-chapter-sixty-seven/",
  "/2019/03/07/oathbringer-reread-chapter-sixty-eight/",
  "/2019/03/14/oathbringer-reread-chapter-sixty-nine/",
  "/2019/03/21/oathbringer-reread-chapter-seventy/",
  "/2019/03/28/oathbringer-reread-chapter-seventy-one/",
  "/2019/04/04/oathbringer-reread-chapter-seventy-two/",
  "/2019/04/11/oathbringer-reread-chapter-seventy-three/",
  "/2019/04/18/oathbringer-reread-chapter-seventy-four/",
  "/2019/04/25/oathbringer-reread-part-three-epigraphs/",
  "/2019/05/02/oathbringer-reread-chapter-seventy-five/",
  "/2019/05/09/oathbringer-reread-chapter-seventy-six/",
  "/2019/05/16/oathbringer-reread-chapter-seventy-seven/",
  "/2019/05/23/oathbringer-reread-chapter-seventy-eight/",
  "/2019/05/30/oathbringer-reread-chapters-seventy-nine-and-eighty/",
  "/2019/06/06/oathbringer-reread-chapters-eighty-one-and-eighty-two/",
  "/2019/06/13/oathbringer-reread-chapter-eighty-three/",
  "/2019/06/20/oathbringer-reread-chapter-eighty-four/",
  "/2019/06/27/oathbringer-reread-chapters-eighty-five-and-eighty-six/",
  "/2019/07/11/oathbringer-reread-chapter-eighty-seven/",
  "/2019/07/18/oathbringer-reread-parts-1-3-review/"
]

episode = 1

links.each do |link|
  url = BASE + link
  puts "Download #{url}"
  unless File.exist? "wor/#{episode}.html"
    `wget --no-clobber "#{url}" --output-document "oathbringer-reread/#{episode}.html" -o /dev/null`
  end
  episode += 1
end

# Now we have all the files
html = ''
for i in 1..(links.length)
  complete_html = Nokogiri::HTML(open("oathbringer-reread/#{i}.html"))
  page = complete_html.css('.entry-content')
  title = complete_html.css('.entry-title>a').inner_html
  ending = false
  page.children.each do |e|
    ending = true if e.class?('squib') || e.class?('post-end-spacer')
    e.remove if ending or e.class? 'ebook-link-wrapper'
  end
  html += "<h1>#{title}</h1>"
  html += page.inner_html

  url = BASE + links[i - 1]

  html += "<p>Visit <a href='#{url}'>tor.com</a> for discussion.</p>"
end

File.open('books/oathbringer-reread.html', 'w') { |file| file.write(html) }
puts '[html] Generated HTML file'

generate('oathbringer-reread', :all)
