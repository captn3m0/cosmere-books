# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'nokogiri'
require_relative './methods'

NAME = 'fires-of-december'
DIR = NAME
FileUtils.mkdir_p([DIR, 'books'])

BLOG = 'https://www.dragonsteelbooks.com/blogs/the-cognitive-realm/'
COVER = 'https://mpd-biblio-covers.imgix.net/9781250462657.jpg'

# Chapters 1 & 2 were not posted on the blog
parts = [{
  chapter: 1,
  pdf: 'https://cdn.shopify.com/s/files/1/0266/6633/6336/files/The_Fires_of_December_Sample_Chapters_1_and_2.pdf',
  video: 'Wvp60G2oLDw'
}]

{
  3 => 'the-fires-of-december-sample-chapters-3-4',
  5 => 'the-fires-of-december-sample-5-and-6',
  7 => 'the-fires-of-december-sample-7-and-8'
}.each do |chapter, slug|
  file = "#{DIR}/#{chapter}.html"
  `curl --silent --location "#{BLOG}#{slug}" --output "#{file}"` unless File.exist? file
  page = Nokogiri::HTML(File.read(file))
  parts << {
    chapter: chapter,
    pdf: page.at_css('a[href*=".pdf"]')['href'],
    video: page.at_css('iframe[src*="youtube.com/embed/"]')['src'][%r{embed/([\w-]+)}, 1]
  }
end

cover = "#{DIR}/cover.jpg"
`curl --silent --location "#{COVER}" --output "#{cover}"` unless File.exist? cover

parts.each do |part|
  base = "#{DIR}/#{part[:chapter]}"
  unless File.exist? "#{base}.pdf"
    puts "Download #{part[:pdf]}"
    `curl --silent --location "#{part[:pdf]}" --output "#{base}.pdf"`
  end
  unless File.exist? "#{base}.m4a"
    puts "Download #{part[:video]}"
    `yt-dlp --quiet --no-progress -f 'ba[ext=m4a][language^=en]/ba[ext=m4a]' -o "#{base}.m4a" "https://www.youtube.com/watch?v=#{part[:video]}"`
  end
  unless File.exist? "#{base}.json"
    puts "[whisper] Finding narration in chapters #{part[:chapter]} & #{part[:chapter] + 1}"
    json = `uv run --quiet fires-of-december-trim.py "#{base}.m4a" "#{base}.pdf" #{part[:chapter]}`
    abort "[error] Could not trim #{base}.m4a" unless $?.success?
    File.write("#{base}.json", json)
  end
  part.merge!(JSON.parse(File.read("#{base}.json"), symbolize_names: true))
  puts "[audio] #{part[:chapter]}: #{part[:start]}s \"#{part[:opening]}\" .. #{part[:end]}s \"#{part[:closing]}\""
end

if commands?(%w[pdftk pdfinfo identify convert]).all?
  page = `pdfinfo #{DIR}/1.pdf`.match(/Page size:\s+([\d.]+) x ([\d.]+)/)
  width = `identify -format %w "#{cover}"`.to_i
  height = (width * page[2].to_f / page[1].to_f).round
  density = 72 * width / page[1].to_f
  `convert "#{cover}" -resize #{width}x#{height}^ -gravity center -extent #{width}x#{height} \
    -units PixelsPerInch -density #{density} -compress jpeg -quality 92 "#{DIR}/cover.pdf"`
  pdfs = parts.map { |p| "#{DIR}/#{p[:chapter]}.pdf" }.join(' ')
  `pdftk #{DIR}/cover.pdf #{pdfs} cat output books/#{NAME}.pdf`
  puts '[pdf] Generated PDF file'
else
  puts '[error] Please install pdftk and imagemagick for the PDF'
end

metadata = [";FFMETADATA1", 'title=The Fires of December (Sample Chapters)', 'artist=Brandon Sanderson',
            'album=The Fires of December', 'composer=Michael Kramer', 'genre=Audiobook']
offset = 0
parts.each do |part|
  trimmed = "#{DIR}/#{part[:chapter]}-trimmed.m4a"
  `ffmpeg -v error -y -ss #{part[:start]} -to #{part[:end]} -i "#{DIR}/#{part[:chapter]}.m4a" -c copy "#{trimmed}"`
  length = (`ffprobe -v error -show_entries format=duration -of csv=p=0 "#{trimmed}"`.to_f * 1000).round
  metadata += ['[CHAPTER]', 'TIMEBASE=1/1000', "START=#{offset}", "END=#{offset + length}",
               "title=Chapters #{part[:chapter]} & #{part[:chapter] + 1}"]
  offset += length
end
File.write("#{DIR}/metadata.txt", metadata.join("\n"))
File.write("#{DIR}/concat.txt", parts.map { |p| "file '#{p[:chapter]}-trimmed.m4a'" }.join("\n"))

`ffmpeg -v error -y -f concat -safe 0 -i #{DIR}/concat.txt -i #{DIR}/metadata.txt -i "#{cover}" \
  -map 0:a -map 2:v -map_metadata 1 -map_chapters 1 -c copy -disposition:v attached_pic \
  -f mp4 books/#{NAME}.m4b`
puts '[m4b] Generated M4B file'
