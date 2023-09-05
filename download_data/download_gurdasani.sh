#!/usr/bin/env bash
# Download and reformat gurdasani and co-workers data
# split and bcf
# make sure environment  micromamba run -n gwasprojects works
this_script_dir=$(dirname $0)
cd $(dirname $0)
gwas_catalog_studies=$PWD/../data/gwascatalog/summary_statistics_table_export.gurdasani.tsv
dest_dir=/protected/sounkoumahamane.toure/AfrPolygenData/SummaryStats ## basedir for traits
splitingscript=${this_script_dir}/split_gurdasani.sh
[[ -f ${gwas_catalog_studies} && ${gwas_catalog_studies} =~ ".tsv"$  ]] || { echo "gwas cat"; exit; } 
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
' "${gwas_catalog_studies}"  \
| while read -r line;  do
outdir=$(echo $line | cut -f1 -d" ")
url=$(echo $line | cut -f2 -d" ")
echo "wget -c --no-check-certificate -P ${outdir} -e robots=off -nd -r --no-parent -A '*annotated.txt.gz' ${url}"
time wget -c --no-check-certificate -P ${outdir} -e robots=off -nd -r --no-parent -A '*annotated.txt.gz' ${url}
echo "time bash $splitingscript $dest_dir"
time  micromamba run -n gwasprojects bash $splitingscript $dest_dir
done
### split