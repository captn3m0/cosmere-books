require 'date'
require 'fileutils'
require 'nokogiri'

FileUtils.mkdir_p("html")

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
    if !File.exists? "html/#{episode}.html"
        `wget --no-clobber "#{url}" --output-document "html/#{episode}.html" -o /dev/null`
    end
    episode +=1
end

# Now we have all the files
html = ""
for i in 1..3
    page = Nokogiri::HTML(open("html/#{i}.html")).css('.entry-content')
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
end

html += "<p>~fin\~<br>Next 3 chapters out on #{next_date.to_s}</p>"

# Write it in the book
File.open("Oathbringer.html", 'w') { |file| file.write(html) }
puts "[html] Generated HTML file"

# Convert it to epub
`pandoc -S -o Oathbringer.epub --epub-metadata=metadata.xml --epub-cover-image=cover.jpg Oathbringer.html`
puts "[epub] Generated EPUB file"

# Convert epub to a mobi
`ebook-convert Oathbringer.epub Oathbringer.mobi`
puts "[mobi] Generated MOBI file"

# Generate PDF as well
# First, lets make a better css version of the html
`pandoc Oathbringer.html -s -c style.css  -o Oathbringer_pdf.html`
puts "[pdf] Generated html for pdf"

# Now we convert the cover to a pdf
`convert cover.jpg cover.pdf`
puts "[pdf] Generated cover for pdf"

# Print the pdf_html file to pdf
`wkhtmltopdf Oathbringer_pdf.html /tmp/Oathbringer.pdf`
puts "[pdf] Generated PDF without cover"

# Join the cover and pdf together
`pdftk cover.pdf /tmp/Oathbringer.pdf cat output Oathbringer.pdf`
puts "[pdf] Generated PDF file"
