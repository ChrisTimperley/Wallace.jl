#!/bin/bash
# Find all markdown files in the tutorials directory and compile to HTML
# within the same directory, using pandoc.
for f in `dirname $0`/*.md
do
  `pandoc $f > ${f%.md}.html`
done
