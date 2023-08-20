#!/usr/bin/bash
# Download and reformat gurdasani and co-workers data
gwas_catalog_studies=../data/gwascatalog/summary_statistics_table_export.tsv
dest_dir=/mnt/d/AfrPolygenData/SummaryStats
cd $(dirname $0)
[[ -f ${gwas_catalog_studies} && ${gwas_catalog_studies} =~ ".tsv"$  ]] || exit
echo "${gwas_catalog_studies/tsv/gurdasani.tsv}"
[[ -d ${dest_dir} ]] || mkidr -p ${dest_dir}
awk -F"\t" -v dd=${dest_dir} '
{
#if(NR  1) { print $6" "$12}
if ( $0 ~ /Uganda Genome Resource Enables Insights into Population History and Genomic Discovery in Africa/)
{   gsub(" +","_", $0);
    gsub("\"","", $0);
    print dd"/"$6" "$12"/"
}
}
' "${gwas_catalog_studies}" | head -1    | while read -r line;  do
outdir=$(echo $line | cut -f1 -d" ")
url=$(echo $line | cut -f2 -d" ")
wget -c --no-check-certificate -P ${outdir} -e robots=off -nd -r --no-parent -A '*annotated.txt.gz' ${url}
ls ${outdir}/*
done