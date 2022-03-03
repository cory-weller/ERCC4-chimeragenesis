# Saturated mutagenesis of NER proteins via chimeragenesis

## Installation requirements

Retrieve this repository, making sure to use `--recurse-submodules` to download the `Xmera` submodule.
```bash
git clone --recurse-submodules https://github.com/cory-weller/NER-mutagenesis.git
```

## Retrieve singularity image file
```bash
cid="77DD71E598E5B51B"
key="ANaVkMo47BvD0G8"
wget -O 'Xmera/src/Xmera.sif' "https://onedrive.live.com/download?cid=${cid}&resid=${cid}%2119128&authkey=${key}"
```

## Generate codon-shuffled sequences
### XPA
```
(
# Generate Sequence
cd XPA/ && \
singularity exec --bind ${PWD} ../Xmera/src/R.sif \
    ../Xmera/src/shuffle.R \
    XPA-cds.fasta \
    XPA-cds.fasta \
    ../data/external/Scer-codons.tsv && \
    fold -w 60 XPA-cds.min.fasta > XPA-min-homology.fasta && \
    rm XPA-cds.*.fasta

# Remove homopolymers
singularity exec --bind ${PWD} ../Xmera/src/Xmera.sif \
    python3 ../Xmera/src/homopolymers.py \
    XPA-min-homology.fasta \
    XPA-cds.fasta > XPA-shuffled.fasta && \
    rm XPA-min-homology.fasta
)
```

### ERCC1
```
(
# Generate Sequence
cd ERCC1/ && \
singularity exec --bind ${PWD} ../Xmera/src/R.sif \
    ../Xmera/src/shuffle.R \
    ERCC1-cds.fasta \
    ERCC1-cds.fasta \
    ../data/external/Scer-codons.tsv && \
    fold -w 60 ERCC1-cds.min.fasta > ERCC1-min-homology.fasta && \
    rm ERCC1-cds.*.fasta

# Remove homopolymers
singularity exec --bind ${PWD} ../Xmera/src/Xmera.sif \
    python3 ../Xmera/src/homopolymers.py \
    ERCC1-min-homology.fasta \
    ERCC1-cds.fasta > ERCC1-shuffled.fasta && \
    rm ERCC1-min-homology.fasta
)
```




