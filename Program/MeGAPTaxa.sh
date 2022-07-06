for i in /app/data/*.trim.fastq.fa;do
PROGRAM=/app/program
REF=/app/reference
$PROGRAM/mapseq "$i" $REF/RDP_BacArc.fasta.one.1200.3000.uniq.rem $REF/RDP_BacArc.fasta.one.1200.3000.mapseq > "$i".mapseq
perl $PROGRAM/ParseSingle.pl "$i".mapseq
perl $PROGRAM/PileupGeneraMDB.pl "$i".mapseq.parsed
rm "$i".mapseq
rm "$i".mapseq.parsed
done

