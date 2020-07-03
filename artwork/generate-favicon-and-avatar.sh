#!/bin/dash

## Favicon and Logo
rm -rf favicon
mkdir favicon
convert ezup-logo-rounded.svg favicon/favicon.png # for stagit
rsvg-convert -a -w 32 -f svg ezup-logo-rounded.svg -o favicon/logo.svg && convert favicon/logo.svg favicon/logo.png && rm favicon/logo.svg # for stagit

## Avatar
rm -rf avatar
mkdir avatar
rsvg-convert -a -w 160 -f svg ezup-logo-square.svg -o avatar/160x160.svg
convert avatar/160x160.svg -background '#f5f5f5' -gravity center -extent 200x200 avatar/200x200.png
rm avatar/160x160.svg

