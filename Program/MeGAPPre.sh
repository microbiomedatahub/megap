for i in /app/data/*.fastq;do
PROGRAM=/app/program
REF=/app/reference
$PROGRAM/fastp -i "$i" -o "$i".trim.fastq -G -3 -n 1 -l 90 -w 1 --adapter_fasta $REF/Adapter.fasta 
cp "$i".trim.fastq /app/program
md5sum "$i".trim.fastq
$PROGRAM/seqkit fq2fa "$i".trim.fastq -o "$i".trim.fastq.fa
rm "$i".trim.fastq
done

