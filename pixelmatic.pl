#!/usr/bin/perl -w

# Packages
use Image::Magick;
use Image::Size;

# =======================================================================================================================================================
# ============================================================== #
# This is a perl preprocessor that takes any image and creates a #
# SCSS grid (originally inspired from a variety of pixel codepens - dropppelt image )
# ============================================================== #


# =======================================================================================================================================================
# =========================================== #
# Get input - series of names and image paths #
# =========================================== #

my $imageName = $ARGV[0]; # second in pair: path to image
my $animationFlag;
if ($ARGV[1]) {
  print "Animation option detected...\n";
  $animationFlag = $ARGV[1]; # second in pair: path to image
} else {
  $animationFlag = "";
}

# =======================================================================================================================================================
# ======================================== #
# Name and open output SCCS and HAML files #
# ======================================== #
open S, ">style.scss" or die "Cannot open SCSS file: $!";
open H, ">index.haml" or die "Cannot open HAML file: $!";
open HT, ">index.html" or die "Cannot open HTML file: $!";

# place library here to read image and put color data into array colors //TODO: implement "number of colors option"
my $image = Image::Magick->new or die;
my $read = $image -> Read($imageName);
(my $imageWidth, my $imageHeight) = imgsize($imageName);
my $numPixels = $imageWidth * $imageHeight;

# build flat array of x colors
for (my $y=0; $y<$imageHeight; $y++) {
  for (my $x=0; $x<$imageWidth; $x++) {
    my @rgb = $image->GetPixels(
        width     => 1,
        height    => 1,
        x         => $x,
        y         => $y,
        map       =>'RGB',
        #normalize => 1
    );
    my $hex = &rgbToHex($rgb[0] / 256, $rgb[1] / 256, $rgb[2] / 256);
    push(@colors, $hex);
  }
}
$lengthColors = scalar(@colors);

# get unique entries in colors (only need one variable, no matter how many colors there are)
%seen = ();
foreach $item (@colors) {
	push(@uniqColors, $item) unless $seen{$item}++;
}
$lengthUniqColors = scalar(@uniqColors);

# build reverse lookup hash of form {normal hex name --> css var name}
%colorMap = (); # initialize hash
for (my$i=0;$i<$lengthUniqColors;$i++) {
  $colorMap{$uniqColors[$i]} = "\$p$i"; # naming convention of colors in SCCS $d0, $d1, $d3 etc
}

# Global vars for the scss
print "Printing style.scss...\n";
# CHFE 24.04.2017 -
print S "// This file generated from perl preprocessor pixelmatic.pl\n";
print S "// https://github.com/frewinchristopher/pixelmatic\n";
print S "\n";

print S "// Global vars \n";
print S "\$pixel-size: 4px;\n"; # right now hardcoded as 8 pixels
print S "\n";

# Print definitions of Colors
$totalOccur = 0;
print S "// Color definitions (total of $lengthUniqColors colors, total of $numPixels pixels) \n";
for (my$i=0;$i<$lengthUniqColors;$i++) {
  my $numOccur = grep { $_ eq  $uniqColors[$i] } @colors; # find number of times this color occurs
  $totalOccur = $totalOccur + $numOccur;
  print S "$colorMap{$uniqColors[$i]}: $uniqColors[$i]; /* occurs $numOccur times */\n";
}
print S "/* (Total sum of occurances: $totalOccur check: $numPixels) */";
print S "\n";

# define the mixin from http://codepen.io/roborich/pen/dqoDj
print S "// Mixin borrowed from http://codepen.io/roborich/pen/dqoDj\n";
print S "\@mixin pixelmatic(\$art, \$size: 10px){\n";
print S "\tdisplay: block;\n";
print S "\theight: \$size;\n";
print S "\twidth: \$size;\n";
print S "\t\$shadow: 0 0 transparent;\n";
print S "\t\@for \$y from 1 through length(\$art){\n";
print S "\t\t\@for \$x from 1 through length(nth(\$art, \$y)){\n";
print S "\t\t\t\$shadow: \$shadow\n";
print S "\t\t\t+ \", \" + \n";
print S "\t\t\t(\$x * \$size)\n";
print S "\t\t\t+ \" \" + \n";
print S "\t\t\t(\$y * \$size) \n";
print S "\t\t\t+ \" \" + \n";
print S "\t\t\tnth(nth(\$art, \$y), \$x) ;\n";
print S "\t\t}\n";
print S "\t}\n";
print S "\tbox-shadow: unquote(\$shadow);\n";
print S "}\n";

# use the 'pixelmatic' include for each pixel
my $x = 0;
my $y = 0;
for (my$i=0;$i<$lengthColors;$i++) {
  my $delay = $i;
  print S ".pixel-$i {\n";
  print S "\tposition: absolute;\n";
  print S "\tleft: \$pixel-size * $x; top: \$pixel-size * $y;\n"; # x and y positions
  print S "\twidth: \$pixel-size; height: \$pixel-size;\n"; # x and y positions
  print S "\tbackground-color: $colorMap{$colors[$i]};\n";
  if ($animationFlag eq "-a") { # CHFE 28 April 2018 - animation flag!
    print S "\tanimation: slideIn 3s infinite;\n";
    print S "\tanimation-delay: $delay s;\n";
  }
  print S "}\n";
  if ($x == $imageWidth - 1) { # CHFE 25 April 2017 - subtract 1 since perl is 0 indexed
    $x = 0;
    $y = $y + 1
  } else {
    $x = $x + 1;
  }
}

# define slide animation:
if ($animationFlag eq "-a") { # CHFE 28 April 2018 - animation flag!
  print S "\@keyframes slideIn {\n";
  print S "\t0% {\n";
  print S "\t\ttransform: translateX(-900px);\n";
  print S "\t}\n";
  print S "\t100% { transform: translateX(0); }\n";
  print S "}\n";
}

print S "\n";

# print page styles
print S "// Page Styles\n";
print S "html,body { height: 100%; }\n";
print S "body {\n";
print S "\tdisplay: flex;\n";
print S "\talign-items: center;\n";
print S "\tjustify-content: center;\n";
print S "}\n";

print S ".container {\n";
print S "\tposition: relative;\n";
print S "\twidth: 240px;\n";
print S "\theight: 320px;\n";
print S "}\n";

# done writing. close file
close S;
print "Done.\n";

#######################################
### Post Processing using Ruby Gems ###
#######################################


# Generate style.css using sass command line (its a gem of ruby)
print "Generating style.css...\n";
`sass style.scss > style.css`;
print "Done.\n";


# Print HAML file
print "Printing index.haml...\n";
print H ".container\n";
for (my$i=0;$i<$lengthColors;$i++) {
      print H "\t.pixel-$i\n"; # has to end with semicolor
}

close H;
print "Done.\n";

# Get generated html using haml command line (its a gem of ruby)
print "Generating index.html...\n";
$generatedHTML = `haml index.haml`;

# Generate full HTML file
print HT "<!DOCTYPE HTML>\n
<html>\n
<head>\n
    <!-- This html was automatically generated from the perl preprocessor pixelmatic.pl -->\n
    <!-- https://github.com/frewinchristopher/pixelmatic -->\n
    <link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\">\n
</head>\n

<body>"; # body tag
print HT $generatedHTML; # generated HTML from haml
print HT "</body>"; # end body tag
print HT "</html>"; # end html tag
close HT;
print "Done.\n";

# helper function - converts RGB color to its Hex equivalent
sub rgbToHex {
    $red=$_[0];
    $green=$_[1];
    $blue=$_[2];
    $string=sprintf ("#%2.2X%2.2X%2.2X",$red,$green,$blue);
    return ($string);
}
