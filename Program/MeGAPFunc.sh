for i in /app/data/*.trim.fastq.fa;do
PROGRAM=/app/program
REF=/app/reference
$PROGRAM/prodigal -i "$i" -a "$i".pt.fasta -p meta
perl $PROGRAM/RemoveTooShort.pl "$i".pt.fasta
rm "$i".pt.fasta.gff
rm "$i".pt.fasta
$PROGRAM/diamond blastp --sensitive --query "$i".pt.fasta.remshort --db $REF/prokaryotes.pep.uniq.diamond --out "$i".pt.fasta.remshort.tsv --outfmt 6
perl $PROGRAM/ParseSingle.pl "$i".pt.fasta.remshort.tsv
perl $PROGRAM/PileupKEGG.pl "$i".pt.fasta.remshort.tsv.parsed
perl $PROGRAM/KEGGID2KOID.pl "$i".pt.fasta.remshort.tsv.parsed.keggid $REF/genes_ko.list
rm "$i".pt.fasta.remshort.tsv
rm "$i".pt.fasta.remshort.parsed.keggid
done

