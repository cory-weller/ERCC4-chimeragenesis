#!/usr/bin/env bash

python3 ../Xmera/bin/analyze-reads.py \
    data/processed/glucosepool.assembled.fastq \
    data/processed/glucosepool-splitreads.tab

python3 ../Xmera/bin/analyze-reads.py \
    data/processed/galactosepool.assembled.fastq \
    data/processed/galactosepool-splitreads.tab

python3 ../Xmera/bin/analyze-reads.py \
    data/processed/5FOApool.assembled.fastq \
    data/processed/5FOApool-splitreads.tab

python3 ../Xmera/bin/analyze-reads.py \
    data/processed/indel-pool.assembled.fastq \
    data/processed/indel-pool-splitreads.tab

python3 ../Xmera/bin/analyze-reads.py \
    data/processed/not-SNPs-pool.assembled.fastq \
    data/processed/not-SNPs-pool-splitreads.tab

python3 ../Xmera/bin/analyze-reads.py \
    data/processed/SNPs-pool.assembled.fastq \
    data/processed/SNPs-pool-splitreads.tab