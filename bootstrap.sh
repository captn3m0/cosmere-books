#!/bin/bash

# Generate all the books
mkdir -p books

if [ -z "$1" ]
  then
    bundle exec ruby edgedancer-reread.rb
    bundle exec ruby oathbringer.rb
    bundle exec ruby oathbringer-reread.rb
    bundle exec ruby wok-prime.rb
    bundle exec ruby wok-reread.rb
    bundle exec ruby wor-reread.rb
    bundle exec ruby skyward.rb
  else
    bundle exec ruby "$1.rb"
fi

cp -r books /output/
