# cosmere-books

![Books in the Cosmere](https://i.imgur.com/NymmBq4.png)

Scripts to generate books from the [Cosmere](https://coppermind.net/wiki/Cosmere) using various public sources. Currently supports the following books:

1.  Oathbringer (Serialized till Chapter 32)
2.  Way of Kings Reread
3.  Words of Radiance Reread
4.  Edgedancer Reread
5.  Way of Kings Prime
6.  Oathbringer Reread (Ongoing)
7.  Skyward (Serialized till Chapter 15)
8.  Defending Elysium

For obvious reasons, the converted ebooks are not part of this repo. You must download and run the script on your own machine to generate the copies.

The code for this is mostly adapted from [hoshruba](https://github.captnemo.in/hoshruba).

You can download sample files (Lorem Ipsum) from <http://ge.tt/8R61oXm2> to see a sample of how the generated files look.

## Oathbringer

Tor.com is publishing Oathbringer in serialized form till Chapter 32. This script downloads all of these posts and converts them into a publishable format, including epub, mobi, pdf and html. You can find the tor.com announcement at https://www.tor.com/2017/08/15/brandon-sanderson-oathbringer-serialization-announcement/.

The script figures out all the chapter URLs, so I just run it every Tuesday now (it doesn't need updates).

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

> For it([Altered Perceptions anthology](https://www.indiegogo.com/projects/altered-perceptions)), I’m letting people see—for the first time—a large chunk of the original version of The Way of Kings, which I wrote in 2002–2003. This version is very different, and involves a different course in life for Kaladin as a character—all due to a simple decision he makes one way in this book, but a completely different way in the published novel.

> These chapters are quite fun, as I consider what happened in The Way of Kings Prime (as I now call it) to be an "alternate reality" version of the events in the published books. The characters are almost all exactly the same people, but their backstories are different, and that has transformed who they are and how they react to the world around them. Roshar is similar, yet wildly different, as this was before I brought in the spren as a major world element.

You can read more at the announcement at [BrandonSanderson.com](https://brandonsanderson.com/chapters-from-the-original-draft-of-the-way-of-kings-available-in-anthology-to-benefit-robison-wells/)

# Oathbringer Reread (Ongoing)

> Join Alice Arneson and Lyndsey Luther for a reread of Brandon Sanderson’s Oathbringer, the third novel in the Stormlight Archive epic fantasy series.

More details at https://www.tor.com/series/oathbringer-reread-brandon-sanderson/

# Skyward

> Skyward by #1 New York Times bestselling author Brandon Sanderson is the first book in an epic new series about a girl who dreams of becoming a pilot in a dangerous world at war for humanity’s future. We know you can't wait for the book to finally hit shelves on 11/6/18, so we're releasing new chapters here every week!

See more details at [underlined](https://www.getunderlined.com/read/excerpt-reveal-start-reading-skyward-by-brandon-sanderson/) or [brandonsanderson.com](https://brandonsanderson.com/books/skyward/skyward/)

# Defending Elysium

> This story originally appeared in the October/November 2008 Asimov’s Science Fiction (in the US) and the UPC Science Fiction collection (in Europe). It was winner of the UPC science fiction award, and was the last short story Brandon wrote before he sold Elantris to Tor.

> The story was first named honorable mention in a Writers of the Future contest in early 2003. (Brandon got the phone call from an editor buying Elantris in April 2003.) A few years later, he did a couple of serious revisions of the story and then submitted it to the UPC award in Spain. It won first place, and subsequently sold in the US to Asimov’s Science Fiction—which was Brandon’s first (and so far only) fiction appearance in a major print magazine. It was given an honorable mention in Gardner Dozois’s The Year’s Best Science Fiction anthology for 2008.

More details at https://brandonsanderson.com/defending-elysium/. Annotations at https://brandonsanderson.com/annotation-Recent-Short-Stories-Defending-Elysium/

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
edgedancer-reread
oathbringer
oathbringer-reread
skyward
wok-prime
wok-reread
wor-reread
```

If none is passed, all books will be generated. The entire build (for all books combined) roughly takes 15 minutes on a single core system (excluding the Docker pull).

So if you'd like to get a ebook for the Way of Kings re-read, run the following command:

	docker run --rm --volume "$(pwd):/output" captn3m0/cosmere-books:latest wok-reread

## Extra

If you'd like to see any other books covered here, please [create an issue](https://github.com/captn3m0/cosmere-books/issues/new), or reach out to me: <https://captnemo.in/contact/>

## Development

If you'd like to hack on the project locally, see [HACKING.md](HACKING.md).

## LICENSE

This is licensed under WTFPL. See COPYING file for the full text.

## Other Projects

- Another project that does ebook generation for Warbreaker: https://github.com/guusj/books
- A list of my other EBook generation projects: https://captnemo.in/ebooks/, includes a link to other related projects as well