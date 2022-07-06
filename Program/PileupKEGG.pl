#! /usr/local/bin/perl -w

use warnings;
use strict;

my ($input, $output, $kegg_id, $homo, $len, $score, $torpk, $aa, $le, $rpk, $permil, $tpm) = 0;
my (%abu_Hash, %len_Hash) = ();

$input = $ARGV[0];
open(INPUT, "$input") or die "Can't open \"$input\"\n";

$output = "$input.keggid";
open(OUTPUT, ">$output") or die "Can't open \"$output\"\n";

while(<INPUT>){
    if(/^\S+\s+(\S+?:\S+?)\;size\S+\s+(\S+)\s+(\S+)\s+\S.+?\s+(\S+)\s*$/){
        $kegg_id = $1;
        $homo = $2;
        $len = $3;
        $score = $4;
        if($homo >= 0.4){
            if($score >= 70){
                if(exists($abu_Hash{$kegg_id})){
                    $abu_Hash{$kegg_id} += 1;
                    $len_Hash{$kegg_id} += $len;
                }
                else{
                    $abu_Hash{$kegg_id} = 1;
                    $len_Hash{$kegg_id} = $len;
                }
            }
        }
    }
}
close INPUT;
$torpk = 0;
foreach $aa (keys %abu_Hash){
    $le = $len_Hash{$aa};
    $rpk = ($abu_Hash{$aa} * 1000) / $le;
    $torpk = $torpk + $rpk;
}
$permil = $torpk/1000000;
foreach $aa (keys %abu_Hash){
    $le = $len_Hash{$aa};
    $rpk = ($abu_Hash{$aa} * 1000) / $le;
    $tpm = $rpk/$permil;
    print OUTPUT "$aa\t$abu_Hash{$aa}\t$tpm\n";
}
close OUTPUT;
exit;
