# ERCC1

## Construct
Benchling entry with annotations located [here](https://benchling.com/s/seq-sLgdtah3L2TXNAmpcD4K?m=slm-CEY2EwVzAyTYSK47X7m0)

## Known variants
Known variants were pulled from gnomAD and HGMD (saved as [`ERCC1-gnomAD-variants.tsv`](ERCC1-gnomAD-variants.tsv) and [`ERCC1-HGMD-variants.tsv`](ERCC1-HGMD-variants.tsv) respectively). These two variants lists were filtered and merged to form [`ERCC1-known-variants.txt`](ERCC1-known-variants.tsv): 

```bash
cat <(cut -f 12 ERCC1-gnomAD-variants.tsv | awk 'NR > 1') \
    <(cut -f 12 ERCC1-HGMD-variants.tsv | awk 'NR > 1') | \
    grep -vP '[-+*]' > ERCC1-known-variants.txt

grep -v '>' ERCC1-known-variants.txt > ERCC1-indels.txt
```