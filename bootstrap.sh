#!/bin/bash

# Generate all the books
mkdir books
bundle exec ruby edgedancer-reread.rb
bundle exec ruby oathbringer.rb
bundle exec ruby oathbringer-reread.rb
bundle exec ruby wok-prime.rb
bundle exec ruby wok-reread.rb
bundle exec ruby wor-reread.rb

cp -r books /output/
