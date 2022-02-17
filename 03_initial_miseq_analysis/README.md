#

## download data
```
wget -O data/raw/AR-ERCC4-122221.tar.gz
rclone copy box:SBGE/data/AR_ERCC4_101921/ data/raw/AR_ERCC4_101921
rclone copy box:SBGE/data/AR_ERCC4_101921/ data/raw/AR_ERCC4_101921
```

box:SBGE/data/AR_ERCC4_122221/20211222_192755/Fastq/ data/raw/AR_ERCC4_122221

```
module load pear
pear -f data/raw/AR_ERCC4_101921/SNPsOligoLib1_S1_L001_R1_001.fastq.gz \
    -r data/raw/AR_ERCC4_101921/SNPsOligoLib1_S1_L001_R2_001.fastq.gz \
    -o data/processed/SNPs-pool &

pear -f data/raw/AR_ERCC4_101921/notSNPsOligoLib2_S2_L001_R1_001.fastq.gz \
    -r data/raw/AR_ERCC4_101921/notSNPsOligoLib2_S2_L001_R2_001.fastq.gz \
    -o data/processed/not-SNPs-pool &

pear -f data/raw/AR_ERCC4_101921/indelOligoLib3_S3_L001_R1_001.fastq.gz \
    -r data/raw/AR_ERCC4_101921/indelOligoLib3_S3_L001_R2_001.fastq.gz \
    -o data/processed/indel-pool &
```

## Assemble paired end reads
```bash
pear -f data/raw/5FOApool-S3-L001-R1-001.fastq.gz \
    -r data/raw/5FOApool-S3-L001-R2-001.fastq.gz \
    -o data/processed/5FOApool

pear -f data/raw/galactosepool-S2-L001-R1-001.fastq.gz \
    -r data/raw/galactosepool-S2-L001-R2-001.fastq.gz \
    -o data/processed/galactosepool

pear -f data/raw/glucosepool-S1-L001-R1-001.fastq.gz \
    -r data/raw/glucosepool-S1-L001-R2-001.fastq.gz \
    -o data/processed/glucosepool
```

## Split reads into constituent parts
```
bash src/split-reads.sh
```

## Tabulate number of RTs matching desired sequences

## Processing single isolate Sanger reads
Retrieve data 
```
module load rclone
cloud='nihbox'

rclone copy ${cloud}:/SBGE/data/AR-single-isolate-sanger.zip data/raw/
unzip data/raw/AR-single-isolate-sanger.zip "*.seq" -d data/raw/
```

Split into parts
```
for folder in data/raw/Oligo_lib*; do
    for file in ${folder}/*.seq; do
        lib=$(echo ${file} | cut -d "/" -f 3 | cut -d "_" -f 2)
        sampleName=$(echo ${file} | cut -d "/" -f 4 | cut -d "_" -f 1)
        sampleNumber=$(echo ${file} | cut -d "/" -f 4 | cut -d "_" -f 4 | cut -d "." -f 1)
        outFile="data/processed/${lib}-${sampleName}-${sampleNumber}.tmp"
        python3 ../Xmera/bin/analyze-reads.py ${file} ${outFile}
    done
done

# Note that some return empty output!
```

Merge with table of RTs in R
```
# Process in R
module load R/3.6.3
R


library(data.table)
library(ggplot2)
library(foreach)
library(ggthemes)


printedOligos <- fread('../ERCC4.RT.txt', col.names=c('ID','oligo'))

# exclude first 15 and last 15 nucleotides
printedOligos[, endpoint := nchar(oligo) - 15]
printedOligos[, RT := substring(oligo, 16, endpoint)]
printedOligos[, RT := toupper(RT)]
setkey(printedOligos, RT)

fileList <- list.files('data/processed/', pattern='*.tmp')

splitreadsHeader <- c('plasmidL', 'barcodeL', 'sublibraryL', 'RT', 'sublibraryR', 'barcodeR', 'plasmidR')

    dat <- fread(paste0('data/processed/', fileList[2]), header=F)

o <- foreach(fileName=fileList, .combine='rbind') %do% {
    dat <- fread(paste0('data/processed/', fileName), header=F)
    if(nrow(dat) == 0) {return(NULL)}
    setnames(dat, splitreadsHeader)
    sample <- strsplit(fileName, '\\.')[[1]][1]
    dat[, 'sample' := sample]
    return(dat[])
}

setkey(o, RT)

o.merge <- merge(o, printedOligos)

o.merge[, c('sample', 'ID')]
```