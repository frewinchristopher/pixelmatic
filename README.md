## Pixelmatic

Pixelmatic is currently two scripts: 

1. a Perl script that converts a bitmap image to a shadow-boxed. All that is needed is the bitmap image in the same folder as the script, and the file name of that image can be provided in the command line

2. A Python script that prints the contents of an .svg file - a square `rect` element for each and every pixel in the bitmap

These scripts work best for pixel art style images, but if you've got a workhorse of a computer / cloud instance, you could try passing large bitmaps.

## Example

The prerequisites for running the first Pixelmatic script are Perl, Sass, and HAML.

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

This is the same story for the python script. An .svg with tens of thousands of elements will grow quite large.

I've also had a pain installing Image::Magick on mac OSX, that still hasnt been resolved, I always have to use my linux machine to run `pixelmatic.pl` :joy:

## Installation

Simply clone this repo. It is recommended to run the test command first, but you can pass any valid file path to the Pixelmatic script.
