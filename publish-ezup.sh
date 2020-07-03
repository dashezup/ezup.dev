#!/bin/dash

## Dependencies: tidy, imagemagick, sed, librsvg

rm -rf .web
mkdir .web
cp -R keys .web/

## HTML

tidy --tidy-mark no --quiet yes -m index.html
#tidy --tidy-mark no --quiet yes --indent-spaces 2 --indent auto --indent-spaces 2 -m index.html
#tidy --tidy-mark no --quiet yes --vertical-space auto --wrap 0 --indent 0 --hide-comments yes -o .web/index.html index.html
cp index.html .web/
## Encode Email address
sed -i 's/dash@ezup.dev/\&#x64;\&#x61;\&#x73;\&#x68;\&#x40;\&#x65;\&#x7A;\&#x75;\&#x70;\&#x2E;\&#x64;\&#x65;\&#x76;/g' .web/index.html
sed -i 's/dashezup@disroot.org/\&#x64;\&#x61;\&#x73;\&#x68;\&#x65;\&#x7A;\&#x75;\&#x70;\&#x40;\&#x64;\&#x69;\&#x73;\&#x72;\&#x6F;\&#x6F;\&#x74;\&#x2E;\&#x6F;\&#x72;\&#x67;/g' .web/index.html
sed -i 's/dashezup@protonmail.com/\&#x64;\&#x61;\&#x73;\&#x68;\&#x65;\&#x7A;\&#x75;\&#x70;\&#x40;\&#x70;\&#x72;\&#x6F;\&#x74;\&#x6F;\&#x6E;\&#x6D;\&#x61;\&#x69;\&#x6C;\&#x2E;\&#x63;\&#x6F;\&#x6D;/g' .web/index.html

## Favicon
cp artwork/ezup-logo-rounded.svg .web/favicon.svg
cp artwork/favicon/* .web/

## CSS and Fonts
cp -r styles .web/
cp -r fonts .web/

## Blog
cp -r blog/public .web/blog
