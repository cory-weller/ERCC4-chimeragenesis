# XPA 

## Construct
Benchling entry with annotations located [here](https://benchling.com/s/seq-OZUTSJZt7lvNWohrzHgl?m=slm-g9ouxQhzFjbkGL8NAjU2)

## Known variants
Known variants were pulled from gnomAD and HGMD (saved as [`XPA-gnomAD-variants.tsv`](XPA-gnomAD-variants.tsv) and [`XPA-HGMD-variants.tsv`](XPA-HGMD-variants.tsv) respectively). These two variants lists were filtered and merged to form [`XPA-known-variants.txt`](XPA-known-variants.tsv): 

```bash
cat <(cut -f 12 XPA-gnomAD-variants.tsv | awk 'NR > 1') \
    <(cut -f 12 XPA-HGMD-variants.tsv | awk 'NR > 1') | \
    grep -vP '[-+*]' > XPA-known-variants.txt

grep -v '>' XPA-known-variants.txt > XPA-indels.txt
```