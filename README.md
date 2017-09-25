# cosmere-books

![Books in the Cosmere](https://i.imgur.com/NymmBq4.png)

Scripts to generate books from the [Cosmere]() using various public sources. Currently supports the following books:

1. Oathbringer (Serialized till Chapter 32)
2. Way of Kings Reread
3. Words of Radiance Reread
4. Edgedancer Reread
5. Way of Kings Prime

For obvious reasons, the converted ebooks are not part of this repo. You must download
and run the script on your own machine to generate the copies.

The code for this is mostly adapted from [hoshruba](https://github.captnemo.in/hoshruba).

You can download sample files (Lorem Ipsum) from <http://ge.tt/8R61oXm2> to see a sample of how the generated files look.

## Oathbringer

Tor.com is publishing Oathbringer in serialized form till Chapter 32. This script
downloads all of these posts and converts them into a publishable format, including
epub, mobi, pdf and html. You can find the tor.com announcement at https://www.tor.com/2017/08/15/brandon-sanderson-oathbringer-serialization-announcement/

## Way of Kings Reread

Join Michael Pye (aka The Mad Hatter) and Carl Engle-Laird as they dive into the details of Sanderson’s complex new world of Roshar.

Find out more at https://www.tor.com/features/series/the-way-of-kings-reread-on-torcom/

## Words of Radiance Reread

Welcome to the reread of Brandon Sanderson’s second Stormlight Archive series book Words of Radiance! This reread will be a collaborative effort between Tor.com’s own editorial assistant Carl Engle-Laird and long-time Tor.com commenter and Sanderson beta-reader Alice Arneson. This new partnership promises to be as potent as that between spren and Radiant. Join them in the Storm Cellar as they evaluate, discuss, question, and generally kibitz their way through the Words of Radiance.

More details at https://www.tor.com/series/words-of-radiance-reread-on-torcom/

## Edgedancer Reread

Join Alice Arneson and Lyndsey Luther for a reread of Brandon Sanderson’s Cosmere novella, Edgedancer, which fills in some of the details for Lift and Nalan between their appearances in Words of Radiance and the next time we see them in Oathbringer.

More details at https://www.tor.com/series/edgedancer-reread-brandon-sanderson/

## Way of Kings: Prime

>For it([Altered Perceptions anthology](https://www.indiegogo.com/projects/altered-perceptions)), I’m letting people see—for the first time—a large chunk of the original version of The Way of Kings, which I wrote in 2002–2003. This version is very different, and involves a different course in life for Kaladin as a character—all due to a simple decision he makes one way in this book, but a completely different way in the published novel.

>These chapters are quite fun, as I consider what happened in The Way of Kings Prime (as I now call it) to be an "alternate reality" version of the events in the published books. The characters are almost all exactly the same people, but their backstories are different, and that has transformed who they are and how they react to the world around them. Roshar is similar, yet wildly different, as this was before I brought in the spren as a major world element.

You can read more at the announcement at [BrandonSanderson.com](https://brandonsanderson.com/chapters-from-the-original-draft-of-the-way-of-kings-available-in-anthology-to-benefit-robison-wells/)

## Requirements

- Ruby
- Nokogiri gem installed (`gem install nokogiri`)
- `pandoc` installed and available (for all 3 formats)
- Paru gem installed (`gem install paru`)
- (mobi only): `ebook-convert` (from calibre) available to generate the mobi file
- (pdf) `wkhtmltopdf` for converting html to pdf
- (pdf) `pdftk` to stitch the final PDF file

- The final 2 tools can be skipped if you don't care about the PDF generation.
- You can also skip calibre if you only want the EPUB file.
- Edit the last line in `*.rb` to `:epub` / `:mobi`, `:pdf` to only trigger the specific builds
- Windows users need wget. Download the latest wget.exe from https://eternallybored.org/misc/wget/ and add it's directory to the PATH environment variable or put it directly in C:\Windows.

## Generation

## Oathbringer

After downloading the repo and installing the requirements, just run

    ruby oathbringer.rb

All the generated files will be saved with the filename `Oathbringer.{epub|pdf|mobi|html}`

## Way of Kings Reread

To generate the book:

    ruby wok-reread.rb

All the generated files will be saved with the filename `wok-reread.{epub|pdf|mobi|html}`

## Words of Radiance Reread

To generate the book:

    ruby wor-reread.rb

All the generated files will be saved with the filename `books/wok-reread.{epub|pdf|mobi|html}`. This generation might take a while because it contains a lot of images. It doesn't have the best possible index either, but is still pretty readable.

## Edgedancer Reread

To generate the book:

    ruby edgedancer-reread.rb

All the generated files will be saved with the filename `books/edgedancer-reread.{epub|pdf|mobi|html}`. This generation might take a while because it contains a lot of images. It doesn't have the best possible index either, but is still pretty readable.

## Way of Kings Prime

    ruby wok-prime.rb

All the generated files will be saved with the filename `books/wok-prime.{epub|pdf|mobi|html}`. This generation might take a while the script attempts to strip out unnecessary HTML.

## Extra

If you'd like to see any other books covered here, please create an issue, or reach out to me: <https://captnemo.in/contact/>

# LICENSE

This is licensed under WTFPL. See COPYING file for the full text.
