# https://stackoverflow.com/a/42533209/368328
def command?(name)
  [name,
   *ENV['PATH'].split(File::PATH_SEPARATOR).map {|p| File.join(p, name)}
  ].find {|f| File.executable?(f)}
end

def commands?(commands)
  commands.map {|c| command? c}
end

def format_match(format)
  [:all, format].include? format
end


def generate(name, format=:all)
  if command? 'pandoc' and format_match(:epub)
    # Convert it to epub
    `pandoc -S -o #{name}.epub --epub-metadata=metadata.xml --epub-cover-image=cover.jpg #{name}.html`
    puts "[epub] Generated EPUB file"
  else
    puts "[error] Can't generate EPUB without pandoc"
  end

  if command? 'ebook-convert' and format_match(:mobi)
    # Convert epub to a mobi
    `ebook-convert #{name}.epub #{name}.mobi`
    puts "[mobi] Generated MOBI file"
  else
    puts "[error] Can't generate MOBI without ebook-convert"
  end

  if commands? ['pandoc', 'convert', 'wkhtmltopdf', 'pdftk'] and format_match(:pdf)
    # Generate PDF as well
    # First, lets make a better css version of the html
    `pandoc #{name}.html -s -c style.css  -o #{name}_pdf.html`
    puts "[pdf] Generated html for pdf"
    # Now we convert the cover to a pdf
    `convert cover.jpg cover.pdf`
    puts "[pdf] Generated cover for pdf"

    # Print the pdf_html file to pdf
    `wkhtmltopdf #{name}_pdf.html /tmp/#{name}.pdf`
    puts "[pdf] Generated PDF without cover"

    # Join the cover and pdf together
    `pdftk cover.pdf /tmp/#{name}.pdf cat output #{name}.pdf`
    puts "[pdf] Generated PDF file"
  else
    puts "[error] Please check README for PDF dependencies"
  end
end
