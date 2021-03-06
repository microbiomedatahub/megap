#! /usr/local/bin/perl -w

use warnings;
use strict;

my ($input, $output, $aa, $ref, $ref2, $counter, $name, $genus_counter, $unclassified_genus, $mapg, $fin) = 0;
my (%name_Hash, %genus_Hash) = ();

$input = $ARGV[0];
open(INPUT, "$input") or die "Can't open \"$input\"\n";

$output = "$input.genus.m16s";
open(OUTPUT, ">$output") or die "Can't open \"$output\"\n";

$genus_counter = 0;
while(<INPUT>){
    if(/^(\S+)\t+CRW\S+/){
        next;
    }
    elsif(/^(\S+)\t+\S+\t+\S+\t+(\S+)\t+(\d+)\t+\S+\t+\S+\t+\S+\t+\S+\t+\S+\t+\S+\t+\S+\t+\S+\t+\S+\t+\S+\t+\S.+?\t+\S+\t+\S+\t+\S.+?\t+\S+\t+\S+\t+\S.+?\t+\S+\t+\S+\t+\S.+?\t+\S+\t+\S+\t+(\S.+?)\t+\S+\t+\S+/){
        if($2 >= 0.94){
            if($3 >= 100){
                $genus_counter += 1;
                if(exists($genus_Hash{$4})){
                    $genus_Hash{$4} += 1;
                }
                else{
                    $genus_Hash{$4} = 1;
                }
            }
        }
    }
}
close INPUT;

foreach $aa (sort keys %genus_Hash){
    print OUTPUT "$aa\t$genus_Hash{$aa}\n";
}
close OUTPUT;
exit;

