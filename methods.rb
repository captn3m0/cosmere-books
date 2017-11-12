module Nokogiri
  module XML
    # Patch to add class?
    class Node
      def class?(*classes)
        present = false
        if attribute('class')
          present = true
          classes.each do |klass|
            present &&= self['class'].include? klass
          end
        end
        present
      end
    end
  end
end

# https://stackoverflow.com/a/42533209/368328
def command?(cmd)
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exts.each { |ext|
      exe = File.join(path, "#{cmd}#{ext}")
      return exe if File.executable?(exe) && !File.directory?(exe)
    }
  end
  return nil
end

def commands?(commands)
  commands.map { |c| command? c }
end

def format_match(format, format_to_match)
  [:all, format_to_match].include? format
end

def gen_epub(name, format)
  return unless format_match(format, :epub)
  begin
    require 'paru/pandoc'
    Paru::Pandoc.new do
      from 'html'
      to 'epub'
      epub_metadata "metadata/#{name}.xml"
      epub_cover_image "covers/#{name}.jpg"
      data_dir Dir.pwd
      output "books/#{name}.epub"
    end.convert File.read("books/#{name}.html")
    puts '[epub] Generated EPUB file'
  rescue LoadError
    puts "[error] Can't generate EPUB without paru"
  end
end

def gen_mobi(name, format)
  if command?('ebook-convert') && format_match(format, :mobi)
    # Convert epub to a mobi
    `ebook-convert books/#{name}.epub books/#{name}.mobi`
    puts '[mobi] Generated MOBI file'
  else
    puts "[error] Can't generate MOBI without ebook-convert"
  end
end

def gen_pdf(name, format)
  if commands?(%w[pandoc convert wkhtmltopdf pdftk]) && format_match(format, :pdf)
    # Generate PDF as well
    # First, lets make a better css version of the html
    `pandoc books/#{name}.html -s -c ../epub.css  -o books/#{name}_pdf.html`
    puts '[pdf] Generated html for pdf'

    # Print the pdf_html file to pdf
    `wkhtmltopdf books/#{name}_pdf.html books/#{name}-nocover.pdf`
    puts '[pdf] Generated PDF without cover'

    # Join the cover and pdf together
    `pdftk covers/#{name}.pdf books/#{name}-nocover.pdf cat output books/#{name}.pdf`
    puts '[pdf] Generated PDF file'
  else
    puts '[error] Please check README for PDF dependencies'
  end
end

def generate(name, format = :all)
  gen_epub(name, format)
  gen_mobi(name, format)
  gen_pdf(name, format)
end
