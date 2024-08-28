# Local Development

If you are interested in just generating the books, follow the guide on the README instead.

## Requirements

- Ruby
- Nokogiri gem installed (`gem install nokogiri`)
- `pandoc` installed and available (for all 3 formats)
- Paru gem installed (`gem install paru`)
- (pdf) `xhtml2pdf` for converting html to pdf
- (pdf) `pdftk` to stitch the final PDF file

### Notes

- The final 2 tools can be skipped if you don't care about the PDF generation.
- Edit the last line in `*.rb` to `:epub` / `:pdf` to only trigger the specific builds
- Windows users need wget. Download the latest wget.exe from https://eternallybored.org/misc/wget/ and add it's directory to the PATH environment variable or put it directly in C:\Windows.

## Generation

### Oathbringer

After downloading the repo and installing the requirements, just run

    ruby oathbringer.rb

All the generated files will be saved with the filename `Oathbringer.{epub|pdf|html}`

### Way of Kings Reread

To generate the book:

    ruby wok-reread.rb

All the generated files will be saved with the filename `wok-reread.{epub|pdf|html}`

### Words of Radiance Reread

To generate the book:

    ruby wor-reread.rb

All the generated files will be saved with the filename `books/wok-reread.{epub|pdf|html}`. This generation might take a while because it contains a lot of images. It doesn't have the best possible index either, but is still pretty readable.

### Edgedancer Reread

To generate the book:

    ruby edgedancer-reread.rb

All the generated files will be saved with the filename `books/edgedancer-reread.{epub|pdf|html}`. This generation might take a while because it contains a lot of images. It doesn't have the best possible index either, but is still pretty readable.

### Warbreaker Prime: Mythwalker

    ruby mythwalker.rb

All the generated files will be saved with the filename `books/mythwalker.{epub|pdf|html}`. This generation might take a while the script attempts to strip out unnecessary HTML.

### Oathbringer Reread

    ruby oathbringer-reread.rb

All the generated files will be saved with the filename `books/oathbringer-reread.{epub|pdf|html}`. This generation might take a while the script attempts to strip out unnecessary HTML.

### Skyward

    ruby skyward.rb

All the generated files will be saved with the filename `books/skyward.{epub|pdf|html}`. This generation might take a while the script attempts to strip out unnecessary HTML.

### Defending Elysium

This is just lazily using Pandoc, since there is just a single page.

    pandoc -t epub  https://brandonsanderson.com/defending-elysium/ -o defending-elysium.epub --epub-cover-image=covers/defending-elysium.jpg --epub-metadata=metadata/defending-elysium.xml
