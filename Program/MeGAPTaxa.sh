#!/usr/bin/bash
for input_path in $1/*.trim.fastq.fa;do
PROGRAM=/app/program
REF=$2
input_file=`basename $input_path`
$PROGRAM/mapseq "$input_path" $REF/RDP_BacArc.fasta.one.1200.3000.uniq.rem $REF/RDP_BacArc.fasta.one.1200.3000.mapseq > "$input_file".mapseq
perl $PROGRAM/ParseSingle.pl "$input_file".mapseq
perl $PROGRAM/PileupGeneraMDB.pl "$input_file".mapseq.parsed
rm "$input_file".mapseq
rm "$input_file".mapseq.parsed
done

