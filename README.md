# cosmere-books

Scripts to generate books from the [Cosmere]() using various public sources. Currently supports the following books:

1. Oathbringer (Serialized till Chapter 32)
2. Way of Kings Reread

For obvious reasons, the converted ebooks are not part of this repo. You must download
and run the script on your own machine to generate the copies.

The code for this is mostly adapted from [hoshruba](https://github.captnemo.in/hoshruba).

You can download sample files (Lorem Ipsum) from <http://ge.tt/8R61oXm2> to see a sample of how the generated files look.

## Oathbringer

Tor.com is publishing Oathbringer in serialized form till Chapter 32. This script
downloads all of these posts and converts them into a publishable format, including
epub, mobi, pdf and html. You can find the tor.com announcement at https://www.tor.com/2017/08/15/brandon-sanderson-oathbringer-serialization-announcement/

## Way of Kings Reread

>Join Michael Pye (aka The Mad Hatter) and Carl Engle-Laird as they dive into the details of Sanderson’s complex new world of Roshar. Find out more at https://www.tor.com/features/series/the-way-of-kings-reread-on-torcom/

## Requirements

- Ruby
- Nokogiri gem installed (`gem install nokogiri`)
- Unix system with `wget` installed
- `pandoc` installed and available (for all 3 formats)
- (mobi only): `ebook-convert` (from calibre) available to generate the mobi file
- (pdf) `wkhtmltopdf` for converting html to pdf
- (pdf) `pdftk` to stitch the final PDF file

- The final 2 tools can be skipped if you don't care about the PDF generation.
- You can also skip calibre if you only want the EPUB file.
- Edit the last line in `setup.rb` to `:epub` / `:mobi`, `:pdf` to only trigger the specific builds

## Generation

## Oathbringer

After downloading the repo and installing the requirements, just run

    ruby setup.rb

All the generated files will be saved with the filename `Oathbringer.{epub|pdf|mobi|html}`

## Way of Kings Reread


To generate the book:

    ruby wok-reread.rb

All the generated files will be saved with the filename `wok-reread.{epub|pdf|mobi|html}`

# LICENSE

This is licensed under WTFPL. See COPYING file for the full text.
