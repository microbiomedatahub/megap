#! /usr/local/bin/perl -w

use warnings;
use strict;

my ($input, $output, $temp, $seq, $count, $pretemp) = 0;
my (%id_Hash) = ();

$input = $ARGV[0];
open(INPUT, "$input") or die "Can't open \"$input\"\n";

$output = "$input.remshort";
open(OUTPUT, ">$output") or die "Can't open \"$output\"\n";

$seq = "";
$count = 0;
open(INPUT, "$input") or die "Can't open \"$input\"\n";
while(<INPUT>){
        if(/^\>(\S+)/){
                if($count == 0){
                        $temp = $1;
                        $seq = "";
                        $count = 1;
                        next;
                }
                elsif($count == 1){
                        $pretemp = $temp;
                        $temp = $1;
                        if($seq =~ /^\S\S\S\S\S\S\S\S\S\S\S\S\S\S\S\S\S\S\S\S/){
                                print OUTPUT ">$pretemp\n$seq\n";
                        }
                        $seq = "";
                }
        }
        elsif(/^(\S+)\s*$/){
                $seq = "$seq$1";
        }
}
if($seq =~ /^\S\S\S\S\S\S\S\S\S\S\S\S\S\S\S\S\S\S\S\S/){
        print OUTPUT ">$temp\n$seq\n";
}
close INPUT;
close OUTPUT;
exit;

