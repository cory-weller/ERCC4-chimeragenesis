#

## download data
wget -O data/raw/AR-ERCC4-122221.tar.gz \


## Assemble paired end reads
```bash
pear -f seqs/5FOApool-S3-L001-R1-001.fastq.gz \
    -r seqs/5FOApool-S3-L001-R2-001.fastq.gz \
    -o 5FOApool

pear -f galactosepool-S2-L001-R1-001.fastq.gz \
    -r galactosepool-S2-L001-R2-001.fastq.gz \
    -o galactosepool

pear -f glucosepool-S1-L001-R1-001.fastq.gz \
    -r glucosepool-S1-L001-R2-001.fastq.gz \
    -o glucosepool
```

## Split reads into constituent parts
```
python3 Xmera/bin/analyze-reads.py glucosepool-assembled.fastq glucosepool-splitreads.tab
python3 Xmera/bin/analyze-reads.py galactosepool-assembled.fastq galactosepool-splitreads.tab
python3 Xmera/bin/analyze-reads.py 5FOApool-assembled.fastq 5FOApool-splitreads.tab
```

## Tabulate number of RTs matching desired sequences