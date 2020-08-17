# cosmere-books ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/captn3m0/cosmere-books) ![Docker Pulls](https://img.shields.io/docker/pulls/captn3m0/cosmere-books) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/captn3m0/cosmere-books/latest) ![GitHub](https://img.shields.io/github/license/captn3m0/cosmere-books) ![GitHub last commit](https://img.shields.io/github/last-commit/captn3m0/cosmere-books)

![Books in the Cosmere](https://i.imgur.com/NymmBq4.png)

Scripts to generate books from the [Cosmere](https://coppermind.net/wiki/Cosmere) using various public sources. Currently supports the following books:

1.  Oathbringer (Serialized till Chapter 32)
1.  Way of Kings Reread
1.  Words of Radiance Reread
1.  Edgedancer Reread
1.  Oathbringer Reread
1.  Skyward (Serialized till Chapter 15)
1.  Defending Elysium
1.  Dark One (Preview Chapter)
1. Rhythm of War (Serialized publication on tor.com in progress)
1. Warbreaker Prime: Mythwalker

For obvious reasons, the converted ebooks are not part of this repo. You must download and run the script on your own machine to generate the copies.

The code for this is mostly adapted from [hoshruba](https://github.captnemo.in/hoshruba).

You can download sample files (Lorem Ipsum) from <http://ge.tt/8R61oXm2> to see a sample of how the generated files look.

## Rhythm of War

>The chapter-by-chapter serialization of Rhythm of War, Brandon Sanderson’s fourth volume in The Stormlight Archive series. New chapters go live every Tuesday up to the November 17, 2020 release date.

## Oathbringer

Tor.com is publishing Oathbringer in serialized form till Chapter 32. This script downloads all of these posts and converts them into a publishable format, including epub, mobi, pdf and html. You can find the tor.com announcement at https://www.tor.com/2017/08/15/brandon-sanderson-oathbringer-serialization-announcement/.

## Way of Kings Reread

Join Michael Pye (aka The Mad Hatter) and Carl Engle-Laird as they dive into the details of Sanderson’s complex new world of Roshar.

Find out more at <https://www.tor.com/features/series/the-way-of-kings-reread-on-torcom/>.

## Words of Radiance Reread

Welcome to the reread of Brandon Sanderson’s second Stormlight Archive series book Words of Radiance! This reread will be a collaborative effort between Tor.com’s own editorial assistant Carl Engle-Laird and long-time Tor.com commenter and Sanderson beta-reader Alice Arneson. This new partnership promises to be as potent as that between spren and Radiant. Join them in the Storm Cellar as they evaluate, discuss, question, and generally kibitz their way through the Words of Radiance.

More details at <https://www.tor.com/series/words-of-radiance-reread-on-torcom/>

## Edgedancer Reread

Join Alice Arneson and Lyndsey Luther for a reread of Brandon Sanderson’s Cosmere novella, Edgedancer, which fills in some of the details for Lift and Nalan between their appearances in Words of Radiance and the next time we see them in Oathbringer.

More details at <https://www.tor.com/series/edgedancer-reread-brandon-sanderson/>

## Way of Kings: Prime

Brandon published Way of Kings Prime as a free ebook, which you can download from here: https://www.brandonsanderson.com/the-way-of-kings-prime/. It is now available for free in EPUB/MOBI/PDF formats from the link.

## Oathbringer Reread

> Join Alice Arneson and Lyndsey Luther for a reread of Brandon Sanderson’s Oathbringer, the third novel in the Stormlight Archive epic fantasy series.

More details at https://www.tor.com/series/oathbringer-reread-brandon-sanderson/

## Skyward

> Skyward by #1 New York Times bestselling author Brandon Sanderson is the first book in an epic new series about a girl who dreams of becoming a pilot in a dangerous world at war for humanity’s future. We know you can't wait for the book to finally hit shelves on 11/6/18, so we're releasing new chapters here every week!

See more details at [underlined](https://www.getunderlined.com/read/excerpt-reveal-start-reading-skyward-by-brandon-sanderson/) or [brandonsanderson.com](https://brandonsanderson.com/books/skyward/skyward/)

## Defending Elysium

> This story originally appeared in the October/November 2008 Asimov’s Science Fiction (in the US) and the UPC Science Fiction collection (in Europe). It was winner of the UPC science fiction award, and was the last short story Brandon wrote before he sold Elantris to Tor.

> The story was first named honorable mention in a Writers of the Future contest in early 2003. (Brandon got the phone call from an editor buying Elantris in April 2003.) A few years later, he did a couple of serious revisions of the story and then submitted it to the UPC award in Spain. It won first place, and subsequently sold in the US to Asimov’s Science Fiction—which was Brandon’s first (and so far only) fiction appearance in a major print magazine. It was given an honorable mention in Gardner Dozois’s The Year’s Best Science Fiction anthology for 2008.

More details at https://brandonsanderson.com/defending-elysium/. Annotations at https://brandonsanderson.com/annotation-Recent-Short-Stories-Defending-Elysium/

## Dark One

>Brandon Sanderson’s Dark One is a break from the norm; it’s a graphic novel from Vault Comics, originally announced as being in the works two years ago, based on an original idea from Sanderson. The book will be written by Collin Kelly and Jackson Lanzing from a story by Sanderson, with art by Nathan Gooden and colors from Kurt Michael Russell. Lettering on the project comes from Deron Bennett.

> The chapter below was originally intended to be Vault Comics’ Free Comic Book Day release this year.

More details at <https://www.hollywoodreporter.com/heat-vision/dark-one-excerpt-brandon-sanderson-unveils-fantasy-graphic-novel-1297122>.

The script generates a CBZ file.

## Warbreaker Prime: Mythwalker

Below description from [Sanderson's website](https://www.brandonsanderson.com/warbreaker-prime-mythwalker-prologue/), written by Peter:

>When Brandon shelved Mythwalker in August 2001 because he felt it wasn’t working (one of its issues was that it felt clichéd, but there are other issues that I’ll discuss following later chapters), he planned to get back to it eventually.
But there were still elements and characters left over in those books that could be used to tell other stories. Warbreaker follows one of the storylines from Mythwalker that was left when the elements used in the Mistborn trilogy were taken out.
But that is not all that Mythwalker is. Its main character and its magic system have not been cannibalized. What you will read here [...] is an interesting story in its own right, even though it has problems. And some of you will be frustrated that the story remains unfinished.

>So it is probably best to view these chapters just as a window on early Brandon Sanderson, when he tried something and failed. This was the first novel in Brandon’s adult writing career that he started writing but never finished. If you want insight into his creative process, I think this is a great place to look.

## Requirements

[Docker](https://docs.docker.com/install/) installed.

## Generation

Once you have `docker` setup, run the following command inside an empty directory. This will download
all the books from scratch and copy the final books into it.

```bash
docker pull captn3m0/cosmere-books
docker run --rm --volume "$(pwd):/output" captn3m0/cosmere-books:latest [bookname]
```

The last is an optional bookname, which can be one of the following:

```
dark-one
edgedancer-reread
mythwalker
oathbringer
oathbringer-reread
row
skyward
wok-reread
wor-reread
```

If none is passed, all books will be generated. The entire build (for all books combined) roughly takes 15 minutes on a single core system (excluding the Docker pull).

As an example, you'd like to get a ebook for Rhythm of War, run the following command:

	docker run --rm --volume "$(pwd):/output" captn3m0/cosmere-books:latest row

## Extra

If you'd like to see any other books covered here, please [create an issue](https://github.com/captn3m0/cosmere-books/issues/new), or reach out to me: <https://captnemo.in/contact/>

## Development

If you'd like to hack on the project locally, see [HACKING.md](HACKING.md).

## LICENSE

This is licensed under WTFPL. See COPYING file for the full text.

## Other Projects

- Another project that does ebook generation for Warbreaker: https://github.com/guusj/books
- A list of my other EBook generation projects: https://captnemo.in/ebooks/, includes a link to other related projects as well
