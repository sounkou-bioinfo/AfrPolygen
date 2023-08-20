#!/usr/bin/bash
### download and index genome files for harmonization
# supposes samtools and bwa is accessible
micromamba activate 
GENOMEFILEDIR=/mnt/d/AfrPolygenData/GenomeFiles
[[ -d $GENOMEFILEDIR ]] || mkdir -p $GENOMEFILEDIR
cd $GENOMEFILEDIR || exit
## download fasta
echo "wget -O- ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz gzip -d > ${GENOMEFILEDIR}/GRCh37/human_g1k_v37.fasta"
time wget -c -O- ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz | gzip -d > "${GENOMEFILEDIR}/GRCh37/human_g1k_v37.fasta"
## indexes
echo samtools faidx "${GENOMEFILEDIR}/GRCh37/human_g1k_v37.fasta"
time samtools faidx "${GENOMEFILEDIR}/GRCh37/human_g1k_v37.fasta"
echo bwa index "${GENOMEFILEDIR}/GRCh37/human_g1k_v37.fasta"
time bwa index "${GENOMEFILEDIR}/GRCh37/human_g1k_v37.fasta"
## download visualization files
time wget -c -P "${GENOMEFILEDIR}/GRCh37" http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/cytoBand.txt.gz
time wget -c -P "${GENOMEFILEDIR}/GRCh37" http://hgdownload.cse.ucsc.edu/goldenpath/hg18/liftOver/hg18ToHg19.over.chain.gz
ref_hg19="${GENOMEFILEDIR}/GRCh37/human_g1k_v37.fasta"
## download hg38
time wget -c -O- ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz \
    |gzip -d > "${GENOMEFILEDIR}/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna"
## index
time samtools faidx "${GENOMEFILEDIR}/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna"
time bwa index "${GENOMEFILEDIR}/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna"
## cyto file
time wget -c -P "${GENOMEFILEDIR}/GRCh38" http://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/cytoBand.txt.gz
time wget -c  -P "${GENOMEFILEDIR}/GRCh38" http://hgdownload.cse.ucsc.edu/goldenpath/hg18/liftOver/hg18ToHg38.over.chain.gz
time wget -c -P "${GENOMEFILEDIR}/GRCh38" http://hgdownload.cse.ucsc.edu/goldenpath/hg19/liftOver/hg19ToHg38.over.chain.gz
ref_hg38="${GENOMEFILEDIR}/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna"