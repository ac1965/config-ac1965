#!/bin/env perl
#

while (<>) {
    printf "%s\n", $1 if (/videoThumbs\['(.*)?'\]/);
}
