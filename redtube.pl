#! /usr/bin/env perl

use File::Path;

my $dirname = '/home/tjy/MEGA/backup/RedTube';
my @pathArray = ($dirname);
mkpath (@pathArray);

while (<>) {
  chomp;
  if (my ($url) = $_ =~ /source src=\"(.*)?\" type=/) {
        my @a = split /\//, $url;
        my ($name, $tmp) = split /\?/, $a[$#a];
        $url = "\"" . $url . "\"";
        my $file = sprintf "%s/%s", $dirname, $name;
	      my $cmd = sprintf "curl -o %s %s", $file, $url;
        if (-f $file) {
	          printf "[Skip Exists : %s]\n", $name;
        } else {
	          printf "[Download: %s]\n", $name;
	          system $cmd;
        }
	      exit 0;
  }
}
