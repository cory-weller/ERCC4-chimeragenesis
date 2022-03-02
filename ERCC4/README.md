# README

## Get Data

```bash
wget -O 'Xmera/src/Xmera.sif' 'https://onedrive.live.com/download?cid=77DD71E598E5B51B&resid=77DD71E598E5B51B%2119128&authkey=ANaVkMo47BvD0G8'
```

## Initialize codon usage table
Will be used for any saturated mutagenesis or deletion scan. Yeast codon usage table retrieved from [kazusa.or.jp](https://www.kazusa.or.jp/codon/cgi-bin/showcodon.cgi?species=4932&aa=1&style=N) and the body of the table was saved as  `codonTable.txt` which is parsed and processed by [`formatCodons.py`](https://github.com/cory-weller/Xmera/blob/b33db0d/bin/formatCodons.py) into [`codons.txt`](seqs/codons.txt):
```
(
cd seqs && \
if [ ! -f "codons.txt" ]; then python3 ../Xmera/bin/formatCodons.py > "codons.txt"; fi 
)
```

## Generate codon-shuffled ERCC4
Shuffling ERCC4:
```bash
( cd seqs/ && Rscript ../Xmera/bin/shuffle.R ERCC4.cds.fasta ERCC4.cds.fasta )
```

The script [`shuffle.R`](https://github.com/cory-weller/Xmera/blob/b33db0d/bin/shuffle.R) generates five new `fasta` files with various % identity shared with [`ERCC4.cds.fasta`](seqs/ERCC4.cds.fasta), but we only need [`ERCC4.cds.min.fasta`](seqs/ERCC4.cds.min.fasta).
```bash
rm seqs/ERCC4.cds.low.fasta
rm seqs/ERCC4.cds.medium.fasta
rm seqs/ERCC4.cds.high.fasta
rm seqs/ERCC4.cds.max.fasta
```

The [`homopolymers.py`](https://github.com/cory-weller/Xmera/blob/b33db0d/bin/homopolymers.py) script removes homopolymers. See `class fasta` within the script for exact replacements.
```bash
( cd seqs/ && \
python3 ../Xmera/bin/homopolymers.py ERCC4.cds.min.fasta ERCC4.cds.fasta > ERCC4.min_homology.fasta
)
```
Generating the final shuffled sequence, [`ERCC4.min_homology.fasta`](seqs/ERCC4.min_homology.fasta) to be ordered by gene synthesis.

## Saturated mutagenesis of ERCC4
```bash
mkdir 01_ERCC4_mutagenesis
python3 Xmera/bin/buildMutagenicRTs.py \
    --first seqs/ERCC4.min_homology.fasta \
    --second seqs/ERCC4.cds.fasta \
    --length 163 \
    --codons seqs/codons.txt \
    --upstream seqs/ERCC4.upstream.fasta \
    --downstream seqs/ERCC4.downstream.fasta \
    > 01_ERCC4_mutagenesis/ERCC4_mutagenesis.fasta
```

## HGVS parsing for generating known ERCC4 variants
```bash
python3 ../Xmera/bin/parseHGVS.py 02_known_variants/indels.txt > 02_known_variants/ERCC4.knownVariants.fasta
```

## Add primers
```bash
python3 ../Xmera/bin/addPrimers.py 01_ERCC4_mutagenesis/ERCC4_mutagenesis.fasta 301 | grep "SNP=True" > ERCC4.RT.txt
python3 ../Xmera/bin/addPrimers.py 01_ERCC4_mutagenesis/ERCC4_mutagenesis.fasta 302 | grep "SNP=False" >> ERCC4.RT.txt
python3 ../Xmera/bin/addPrimers.py 02_known_variants/ERCC4.knownVariants.fasta 303  >> ERCC4.RT.txt
```

