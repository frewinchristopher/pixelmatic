## Synopsis

Pixelmatic is a Perl script that converts a bitmap image. All that is needed is the bitmap image in the same folder

## Code Example

Firstly the prerequisites for running Pixelmatic are Perl, Sass, and HAML.

The easiest way to get a starting example is running: `perl pixelmatic.pl thewave.png` or, if you prefer pokemon, `perl pixelmatic.pl shiny_charizard.png` (I have included thewave.png, a 80 x 55 pixel image here for your testing enjoyment.)

Upon runtime, a host of files are generated, in the following order,

style.scss (Printed by Pixelmatic)
style.css (Pixelmatic issues sass command itself)
index.haml (Printed by Pixelmatic)
index.html (Pixelmatic issues haml command itself)

Then simply open index.html in a browser to see what you've created!

## Motivation

Pixel art is neat for websites, but I couldn't find a tool that would generate a pixel by pixel series of divs by itself, so I built one.

## Known Issues

Because of the nature of what Pixelmatic is doing - creating a small div for every pixel in an image - it is optimally suited for .ico and small bitmaps. The run time because quite long for images larger than 200 x 200 with a single core machine, perhaps even prohibitively so.

I've also had a pain installing Image::Magick on mac OSX, that still hasnt been resolved, I always have to use my linux machine to run `pixelmatic.pl` :joy:

## Installation

Simply clone this repo to get access to the pixelmatic.pl script. It is recommended to run the test command first, but you can pass any valid file path to the Pixelmatic.
