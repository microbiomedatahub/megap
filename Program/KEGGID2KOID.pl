#! /usr/local/bin/perl -w

use warnings;
use strict;

my ($input, $ref, $output, $aa, $bb, $cc) = 0;
my (@ar) = ();
my (%gene_Hash, %ko_Hash, %koa_Hash) = ();

$input = $ARGV[0];
open(INPUT, "$input") or die "Can't open \"$input\"\n";

$ref = $ARGV[1];
open(REF, "$ref") or die "Can't open \"$ref\"\n";

$output = "$input.ko.tsv";
open(OUTPUT, ">$output") or die "Can't open \"$output\"\n";

open(INPUT, "$input") or die "Can't open \"$input\"\n";
while(<INPUT>){
    if(/^(\S+)\s+\S+\s+(\S+)\s*$/){
        $gene_Hash{$1} = $2;
    }
}
close INPUT;

open(REF, "$ref") or die "Can't open \"$ref\"\n";
while(<REF>){
    if(/^(\S+)\s+(\S+?)\s*$/){
        if(exists($ko_Hash{$1})){
            $ko_Hash{$1} = "$ko_Hash{$1}\t$2";
        }
        else{
            $ko_Hash{$1} = $2;
        }
    }
}
close REF;

foreach $aa (sort keys %gene_Hash){
    if(exists($ko_Hash{$aa})){
            @ar = ();
            @ar = split(/\t/,$ko_Hash{$aa});
            foreach $bb (@ar){
                if(exists($koa_Hash{$bb})){
                        $koa_Hash{$bb} += $gene_Hash{$aa};
                }
                else{
                    $koa_Hash{$bb} = $gene_Hash{$aa};
                }
            }
    }
    else{
        next;
    }
}
foreach $cc (sort keys %koa_Hash){
    print OUTPUT "$cc\t$koa_Hash{$cc}\n";
}
close OUTPUT;
exit
