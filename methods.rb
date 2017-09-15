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
    `pandoc -S -o books/#{name}.epub --epub-metadata=metadata/#{name}.xml --epub-cover-image=covers/#{name}.jpg books/#{name}.html`
    puts "[epub] Generated EPUB file"
  else
    puts "[error] Can't generate EPUB without pandoc"
  end

  if command? 'ebook-convert' and format_match(:mobi)
    # Convert epub to a mobi
    `ebook-convert books/#{name}.epub books/#{name}.mobi`
    puts "[mobi] Generated MOBI file"
  else
    puts "[error] Can't generate MOBI without ebook-convert"
  end

  if commands? ['pandoc', 'convert', 'wkhtmltopdf', 'pdftk'] and format_match(:pdf)
    # Generate PDF as well
    # First, lets make a better css version of the html
    `pandoc books/#{name}.html -s -c style.css  -o books/#{name}_pdf.html`
    puts "[pdf] Generated html for pdf"

    # Print the pdf_html file to pdf
    `wkhtmltopdf #{name}_pdf.html books/#{name}-nocover.pdf`
    puts "[pdf] Generated PDF without cover"

    # Join the cover and pdf together
    `pdftk covers/#{name}.pdf books/#{name}-nocover.pdf cat output books/#{name}.pdf`
    puts "[pdf] Generated PDF file"
  else
    puts "[error] Please check README for PDF dependencies"
  end
end
