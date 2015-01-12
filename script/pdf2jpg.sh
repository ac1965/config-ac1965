#! /bin/sh

pdftoppm $1 $(basename $1 .pdf)
mogrify -format jpg *.ppm
