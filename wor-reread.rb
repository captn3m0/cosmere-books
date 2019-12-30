# frozen_string_literal: true

require 'date'
require 'fileutils'
require 'nokogiri'
require_relative './methods'

FileUtils.mkdir_p('wor')

BASE = 'https://www.tor.com'

links = [
  '/2014/06/12/introducing-the-words-of-radiance-reread/',
  '/2014/06/12/words-of-radiance-reread-prologue/',
  '/2014/06/19/words-of-radiance-reread-chapter-1/',
  '/2014/06/26/words-of-radiance-reread-chapter-2/',
  '/2014/07/03/words-of-radiance-reread-chapter-three/',
  '/2014/07/10/words-of-radiance-reread-chapter-4/',
  '/2014/07/17/words-of-radiance-reread-chapter-5/',
  '/2014/07/24/words-of-radiance-reread-chapter-6/',
  '/2014/07/31/words-of-radiance-reread-chapter-7/',
  '/2014/08/07/words-of-radiance-reread-chapter-8/',
  '/2014/08/14/words-of-radiance-reread-chapter-9/',
  '/2014/08/21/words-of-radiance-reread-chapter-10/',
  '/2014/08/28/words-of-radiance-reread-chapter-11/',
  '/2014/09/04/words-of-radiance-reread-chapter-12/',
  '/2014/09/11/words-of-radiance-reread-interlude-1/',
  '/2014/09/18/words-of-radiance-reread-interlude-2/',
  '/2014/09/25/words-of-radiance-reread-interlude-3/',
  '/2014/10/02/words-of-radiance-reread-interlude-4/',
  '/2014/10/09/words-of-radiance-reread-chapter-13/',
  '/2014/10/16/words-of-radiance-reread-chapter-14/',
  '/2014/10/23/words-of-radiance-reread-chapter-15/',
  '/2014/10/30/words-of-radiance-reread-chapter-16/',
  '/2014/11/06/words-of-radiance-reread-chapter-17/',
  '/2014/11/13/words-of-radiance-reread-chapter-18/',
  '/2014/11/20/words-of-radiance-reread-chapter-19/',
  '/2014/12/04/words-of-radiance-reread-chapter-20/',
  '/2014/12/11/words-of-radiance-reread-chapter-21/',
  '/2014/12/18/words-of-radiance-reread-chapter-22/',
  '/2015/01/08/words-of-radiance-reread-chapter-23/',
  '/2015/01/15/words-of-radiance-reread-chapter-24/',
  '/2015/01/22/words-of-radiance-reread-chapter-25/',
  '/2015/01/29/words-of-radiance-reread-chapter-26/',
  '/2015/02/05/words-of-radiance-reread-chapter-27/',
  '/2015/02/12/words-of-radiance-reread-chapter-28/',
  '/2015/02/19/words-of-radiance-reread-chapter-29/',
  '/2015/02/26/words-of-radiance-reread-chapter-30/',
  '/2015/03/05/words-of-radiance-reread-chapter-31/',
  '/2015/03/12/words-of-radiance-reread-chapter-32/',
  '/2015/03/19/words-of-radiance-reread-chapter-33/',
  '/2015/03/26/words-of-radiance-reread-chapter-34/',
  '/2015/04/02/words-of-radiance-reread-part-2-epigraphs/',
  '/2015/04/09/words-of-radiance-reread-interludes-5-and-6/',
  '/2015/04/16/words-of-radiance-reread-interludes-7-and-8/',
  '/2015/04/23/words-of-radiance-reread-chapter-35/',
  '/2015/04/30/words-of-radiance-reread-chapter-36/',
  '/2015/05/07/words-of-radiance-reread-chapter-37/',
  '/2015/05/14/words-of-radiance-reread-chapter-38/',
  '/2015/05/21/words-of-radiance-reread-chapter-39/',
  '/2015/05/28/words-of-radiance-reread-chapter-40/',
  '/2015/06/04/words-of-radiance-reread-chapter-41/',
  '/2015/06/11/words-of-radiance-reread-chapter-42/',
  '/2015/06/18/words-of-radiance-reread-chapter-43/',
  '/2015/06/25/words-of-radiance-reread-chapter-44/',
  '/2015/07/02/words-of-radiance-reread-chapter-45/',
  '/2015/07/09/words-of-radiance-reread-chapter-46/',
  '/2015/07/23/words-of-radiance-reread-chapter-47/',
  '/2015/07/30/words-of-radiance-reread-chapter-48/',
  '/2015/08/06/words-of-radiance-reread-chapter-49/',
  '/2015/08/13/words-of-radiance-reread-chapter-50/',
  '/2015/08/20/words-of-radiance-reread-chapter-51/',
  '/2015/08/27/words-of-radiance-reread-chapter-52/',
  '/2015/09/03/words-of-radiance-reread-chapter-53/',
  '/2015/09/10/words-of-radiance-reread-chapter-54/',
  '/2015/09/17/words-of-radiance-reread-chapter-55/',
  '/2015/09/24/words-of-radiance-reread-chapter-56/',
  '/2015/10/01/words-of-radiance-reread-chapter-57/',
  '/2015/10/08/words-of-radiance-reread-chapter-58/',
  '/2015/10/15/words-of-radiance-reread-interlude-9/',
  '/2015/10/22/words-of-radiance-reread-interlude-10/',
  '/2015/10/29/words-of-radiance-reread-interlude-11/',
  '/2015/11/05/words-of-radiance-reread-chapter-59/',
  '/2015/11/12/words-of-radiance-reread-chapter-60/',
  '/2015/11/19/words-of-radiance-reread-chapter-61/',
  '/2015/12/03/words-of-radiance-reread-chapter-62/',
  '/2015/12/10/words-of-radiance-reread-chapter-63/',
  '/2015/12/17/words-of-radiance-reread-chapter-64/',
  '/2016/01/07/words-of-radiance-reread-chapter-65/',
  '/2016/01/14/words-of-radiance-reread-chapter-66/',
  '/2016/01/21/words-of-radiance-reread-chapter-67/',
  '/2016/01/28/words-of-radiance-reread-chapter-68/',
  '/2016/02/04/words-of-radiance-reread-chapter-69/',
  '/2016/02/11/words-of-radiance-reread-chapter-70/',
  '/2016/02/18/words-of-radiance-reread-chapter-71/',
  '/2016/02/25/words-of-radiance-reread-chapter-72/',
  '/2016/03/03/words-of-radiance-reread-chapter-73/',
  '/2016/03/10/words-of-radiance-reread-chapter-74/',
  '/2016/03/17/words-of-radiance-reread-chapter-75/',
  '/2016/03/24/words-of-radiance-reread-part-4-epigraphs/',
  '/2016/03/31/words-of-radiance-reread-interludes-12-and-13/',
  '/2016/04/07/words-of-radiance-reread-interlude-14/',
  '/2016/04/14/words-of-radiance-reread-chapter-76/',
  '/2016/04/21/words-of-radiance-reread-chapter-77/',
  '/2016/04/28/words-of-radiance-reread-chapter-78/',
  '/2016/05/05/words-of-radiance-reread-chapter-79/',
  '/2016/05/12/words-of-radiance-reread-chapter-80/',
  '/2016/05/19/words-of-radiance-reread-chapter-81/',
  '/2016/05/26/words-of-radiance-reread-chapter-82/',
  '/2016/06/02/words-of-radiance-reread-chapter-83/',
  '/2016/06/09/words-of-radiance-reread-chapter-84/',
  '/2016/06/16/words-of-radiance-reread-chapter-85/',
  '/2016/06/23/words-of-radiance-reread-chapter-86/',
  '/2016/06/30/words-of-radiance-reread-chapter-87/',
  '/2016/07/14/words-of-radiance-reread-chapter-88/',
  '/2016/07/28/words-of-radiance-reread-chapter-89/',
  '/2016/08/04/words-of-radiance-reread-epilogue-and-what-comes-next/'
]

episode = 1

links.each do |link|
  url = BASE + link
  puts "Download #{url}"
  unless File.exist? "wor/#{episode}.html"
    `wget --no-clobber "#{url}" --output-document "wor/#{episode}.html" -o /dev/null`
  end
  episode += 1
end

# Now we have all the files
html = ''
for i in 1..(links.length)
  complete_html = Nokogiri::HTML(open("wor/#{i}.html"))
  page = complete_html.css('.entry-content')
  title = complete_html.css('.entry-title>a').inner_html
  ending = false
  page.children.each do |e|
    ending = true if e.class?('squib') || e.class?('post-end-spacer')
    e.remove if ending
  end
  html += "<h1>#{title}</h1>"
  html += page.inner_html

  url = BASE + links[i - 1]

  html += "<p>Visit <a href='#{url}'>tor.com</a> for discussion.</p>"
end

File.open('books/wor-reread.html', 'w') { |file| file.write(html) }
puts '[html] Generated HTML file'

generate('wor-reread', :all)
