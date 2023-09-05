#!/usr/bin/env bash
# install genome files and upload to zenodo
# make sure environment  micromamba run -n gwasprojects works
set -euo  pipefail
storage_directory=/protected/sounkoumahamane.toure/AfrPolygenData/Genomes
[[ -d ${storage_directory}/GRCh37 ]] || mkdir -p ${storage_directory}/GRCh37
[[ -d ${storage_directory}/GRCh37 ]] || mkdir -p ${storage_directory}/GRCh38
## grch37
[[ -f ${storage_directory}/GRCh37/human_g1k_v37.fasta ]] || {
time wget -O- ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz \
| gzip -d > ${storage_directory}/GRCh37/human_g1k_v37.fasta || true ;}
[[ -f  ${storage_directory}/GRCh37/human_g1k_v37.fasta.fai ]] || time samtools faidx ${storage_directory}/GRCh37/human_g1k_v37.fasta
[[ -f  ${storage_directory}/GRCh37/human_g1k_v37.fasta.bwt ]] || time bwa index ${storage_directory}/GRCh37/human_g1k_v37.fasta
time wget -c -P ${storage_directory}/GRCh37 http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/cytoBand.txt.gz
time wget -c  -P ${storage_directory}/GRCh37 http://hgdownload.cse.ucsc.edu/goldenpath/hg18/liftOver/hg18ToHg19.over.chain.gz
## grch38
[[ -f ${storage_directory}/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna ]] || {
time wget -O- ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz \
| gzip -d > ${storage_directory}/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna || true ; }
[[ -f ${storage_directory}/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.fai ]] || time samtools faidx ${storage_directory}/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna
[[ -f  ${storage_directory}/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.bwt ]] || time bwa index ${storage_directory}/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna
wget -P ${storage_directory}/GRCh38 http://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/cytoBand.txt.gz
wget -P ${storage_directory}/GRCh38 http://hgdownload.cse.ucsc.edu/goldenpath/hg18/liftOver/hg18ToHg38.over.chain.gz
wget -P ${storage_directory}/GRCh38 http://hgdownload.cse.ucsc.edu/goldenpath/hg19/liftOver/hg19ToHg38.over.chain.gz
wget -P ${storage_directory}/GRCh38 http://hgdownload.cse.ucsc.edu/goldenpath/hg19/liftOver/hg38ToHg19.over.chain.gz