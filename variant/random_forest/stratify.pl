#!/usr/bin/env perl

use strict;
use warnings;

my $usage = "Usage: $0 <clinvar.vcf> <significance code>\n";
my $infile = shift or die $usage;
my $code = shift or die $usage;

if ($infile =~ /\.gz$/){
   open(IN, '-|', "gunzip -c $infile") || die "Could not open $infile: $!\n";
} else {
   open(IN, '<', $infile) || die "Could not open $infile: $!\n";
}

VARIANT: while(<IN>){
   chomp;
   my $current_line = $_;
   if ($current_line =~ /^#/){
      print "$current_line\n";
   } else {
      if (/CLNSIG=(.*?);/){
         my $clnsig = $1;
         # split by pipes or commas
         my @clnsig = split(/\||,/, $clnsig);

         # has only one significance code
         if (scalar(@clnsig) == 1){
            if ($clnsig == $code){
               print "$current_line\n";
               next VARIANT;
            }
         }

         # $match if there is a match to input code
         my ($benign, $pathogenic, $match) = (0, 0, 0);
         foreach my $c (@clnsig){
            if ($c == 2 || $c == 3){
               $benign = 1;
            }
            if ($c == 4 || $c == 5){
               $pathogenic = 1;
            }
            if ($c == $code){
               $match = 1;
            }
         }

         # check and skip conflicting codes
         if ($benign == 1 && $pathogenic == 1){
            next VARIANT;
         }

         if ($match == 1){
            print "$current_line\n";
         }
      }
   }
}
close(IN);

exit(0);

