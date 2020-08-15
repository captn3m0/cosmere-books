#!/bin/bash

# Generate all the books
mkdir -p books

if [ -z "$1" ]
  then
    bundle exec ruby edgedancer-reread.rb
    bundle exec ruby oathbringer.rb
    bundle exec ruby oathbringer-reread.rb
    bundle exec ruby wok-reread.rb
    bundle exec ruby wor-reread.rb
    bundle exec ruby skyward.rb
    bundle exec ruby row.rb
    bundle exec ruby mythwalker.rb
    pandoc -t epub https://brandonsanderson.com/defending-elysium/ \
      --output=books/defending-elysium.epub \
      --epub-cover-image=covers/defending-elysium.jpg \
      --epub-metadata=metadata/defending-elysium.xml
    ./dark-one-preview.sh
  elif [[ "$1" == "dark-one" ]]; then
    ./dark-one-preview.sh
  else
    bundle exec ruby "$1.rb"
fi

cp -r books /output/
