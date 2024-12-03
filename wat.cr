require "http/client"
require "dir"
require "lexbor"
Dir.mkdir_p("wat")
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
  "interludes-3-and-4",
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
  start = ending = false

  page.first.children.each do |e|
    if e.tag_name == "h3"
      # Create a new Lexbor H1 node instead
      e = Lexbor::Parser.new("<h1>#{e.inner_html}</h1>").root!

      start = true
    end
    # Chapter Arch heading images
    if e.tag_name == "figure" && e["class"].includes?("wp-block-image")
      start = true
    end

    ending = true if e.tag_text.includes?("Excerpted") && start

    e.remove! if !start || ending
  end
  chapter_html = page.first.inner_html
    .sub(/<h1/, "<h1 id='chapter-#{i - 1}'")
  html += chapter_html
end

File.write("books/wat2.html", html)
