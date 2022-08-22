#!/usr/bin/bash
for input_path in $1/*.trim.fastq.fa;do
PROGRAM=/app/program
REF=$2
input_file=`basename $input_path`
$PROGRAM/prodigal -i "$input_path" -a "$input_file".pt.fasta -p meta
perl $PROGRAM/RemoveTooShort.pl "$input_file".pt.fasta
rm "$input_file".pt.fasta
$PROGRAM/diamond blastp --sensitive --query "$input_file".pt.fasta.remshort --db $REF/prokaryotes.pep.uniq.diamond --out "$input_file".pt.fasta.remshort.tsv --outfmt 6
perl $PROGRAM/ParseSingle.pl "$input_file".pt.fasta.remshort.tsv
perl $PROGRAM/PileupKEGG.pl "$input_file".pt.fasta.remshort.tsv.parsed
perl $PROGRAM/KEGGID2KOID.pl "$input_file".pt.fasta.remshort.tsv.parsed.keggid $REF/genes_ko.list
rm "$input_file".pt.fasta.remshort.tsv
rm "$input_file".pt.fasta.remshort.tsv.parsed.keggid
done

