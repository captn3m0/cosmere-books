require "http/client"
require "dir"
require "lexbor"
require "./epub"

Dir.mkdir_p("wat/chapters")
BASE = "https://reactormag.com/read-wind-and-truth-by-brandon-sanderson-"

LINKS = [
  "preface-and-prologue/",
  "chapters-1-and-2/",
  "chapters-3-and-4/",
  "chapters-5-and-6/",
  "chapters-7-8-and-9/",
  "chapters-10-and-11/",
  "chapters-12-and-13/",
  "interludes-1-and-2/",
  "chapters-14-and-15/",
  "chapters-16-17-and-18/",
  "chapters-19-and-20/",
  "chapters-21-and-22/",
  "chapters-23-and-24/",
  "chapters-25-and-26/",
  "chapters-27-and-28/",
  "chapters-29-and-30/",
  "chapters-31-and-32/",
  "chapter-33/",
  "interludes-3-and-4/",
]

# Automatically adds all recent chapter
puts "Downloading all found links"
episode = 1

LINKS.each do |link|
  url = BASE + link
  puts "Download #{url}"
  unless File.exists? "wat/#{episode}.html"
    HTTP::Client.get(url) do |response|
      if response.success?
        File.open("wat/#{episode}.html", "w") do |file|
          IO.copy(response.body_io, file)
        end
      else
        puts "Failed to download #{url} #{response.status_code}"
      end
    end
  end
  episode += 1
end

# # Now we have all the files
html = ""

(1..(LINKS.size)).each do |i|
  page_html = File.open("wat/#{i}.html").gets_to_end
  page = Lexbor::Parser.new(page_html).css("article-content")
  start = false

  page.first.children.each do |e|
    # puts e.tag_name
    if e.tag_name == "h3"
      e2 = Lexbor::Parser.new("<h1>#{e.inner_html}</h1>").nodes(:h1).first
      e2.inner_html = e.inner_html
      e = e2
    end

    if e.tag_name == "h1" || e.tag_name == "h3"
      start = true
    end

    # Chapter Arch heading images
    if e.tag_name == "figure" && e["class"].includes?("wp-block-image")
      start = true
    end

    if start && e.tag_text.includes?("Excerpted")
      break
    elsif start
      html += e.to_html
    end
  end
end

file_chapter_index = 1
split_html = ""
Lexbor::Parser.new(html).nodes(:body).first.children.each do |ee|
  if ee.tag_name == "figure" && ee["class"].includes?("wp-block-image") && split_html != ""
    File.write("wat/chapters/#{file_chapter_index}.html", <<-XHTML
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
    <head>
      <meta charset="utf-8" />
      <meta name="generator" content="github/captn3m0/cosmere-ebooks" />
      <title>Untitled</title>
    </head>
    <body epub:type="bodymatter">
    <section id="section" class="level1 unnumbered">
    #{split_html}
    </section>
    </body>
    </html>
    XHTML
    )
    split_html = ""
    file_chapter_index += 1
  end
  split_html += ee.to_html
end

generator = EPUBGenerator.new("wat/chapters", "wat.epub")
generator.generate
