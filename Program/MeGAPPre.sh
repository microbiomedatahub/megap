#!/usr/bin/bash
for input_path in $1/*.fastq;do
PROGRAM=/app/program
REF=$2
input_file=`basename $input_path`
$PROGRAM/fastp -i "$input_path" -o "$input_file".trim.fastq -G -3 -n 1 -l 90 -w 1 --adapter_fasta $REF/Adapter.fasta 
$PROGRAM/seqkit fq2fa "$input_file".trim.fastq -o "$input_file".trim.fastq.fa
rm "$input_file".trim.fastq
done

