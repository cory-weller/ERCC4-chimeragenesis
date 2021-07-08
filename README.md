# README

## Initialize codon usage table
Will be used for any saturated mutagenesis or deletion scan. Yeast codon usage table retrieved from [kazusa.or.jp](https://www.kazusa.or.jp/codon/cgi-bin/showcodon.cgi?species=4932&aa=1&style=N) and the body of the table was saved as  `codonTable.txt` which is parsed and processed by [`formatCodons.py`](Xmera/bin/formatCodons.py) into [`codons.txt`](seqs/codons.txt):
```
(
cd seqs && \
if [ ! -f "codons.txt" ]; then python3 ../Xmera/bin/formatCodons.py > "codons.txt"; fi 
)
```

## Generate codon-shuffled ercc4
Shuffling ercc4:
```bash
( cd seqs/ && Rscript ../Xmera/bin/shuffle.R ercc4.cds.fasta ercc4.cds.fasta )
```

The script [`shuffle.R`](shuffle.R) generates five new `fasta` files with various % identity shared with [`ercc4.cds.fasta`](seqs/ercc4.cds.fasta), but we only need [`ercc4.cds.min.fasta`](seqs/ercc4.cds.min.fasta).
```bash
rm seqs/ercc4.cds.low.fasta
rm seqs/ercc4.cds.medium.fasta
rm seqs/ercc4.cds.high.fasta
rm seqs/ercc4.cds.max.fasta
```

The [`homopolymers.py`](Xmera/bin/homopolymers.py) script removes homopolymers. See `class fasta` within the script for exact replacements.
```bash
( cd seqs/ && \
python3 ../Xmera/bin/homopolymers.py ercc4.cds.min.fasta ercc4.cds.fasta > ercc4.min_homology.fasta
)
```
Generating the final shuffled sequence, [`ercc4.min_homology.fasta`](seqs/ercc4.min_homology.fasta) to be ordered by gene synthesis.

