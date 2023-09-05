#!/usr/bin/env bash
# convert gwas summstats to 
set -euo  pipefail
storage_directory=/protected/sounkoumahamane.toure/AfrPolygenData/Genomes
genome=${storage_directory}/GRCh37/human_g1k_v37.fasta
cytoBand=${storage_directory}/GRCh37/cytoBand.txt.gz
this_script_dir=$(dirname $0)
colheaders=${this_script_dir}/colheaders.tsv
plugin_bins_dir=/home/sounkoumahamane.toure/micromamba/envs/gwasprojects/bin
[[ -f ${genome} && -f ${genome}.fai ]] || { echo "genome files" ;  exit ;}
[[ -f ${colheaders} ]] || { echo "headers" ;  exit ;}
gwastats=${1:-"/protected/sounkoumahamane.toure/AfrPolygenData/SummaryStats/Platelet_count/plt_uganda.tsv.bgz"}
[[ -f ${gwastats} && ( ${gwastats} =~ ".tsv.bgz"$ &&  -f ${gwastats}.tbi   )  ]] || { echo "vcf files" ;  exit ;}
gwasname=$(basename ${gwastats} ".tsv.bgz" )
echo ${gwastats/.tsv.bgz/.bcf}
#[[ -f ${gwastats/.tsv.bgz/.bcf} ]] || \
time bcftools +${plugin_bins_dir}/munge.so --no-version -o ${gwastats/.tsv.bgz/.bcf} -Ob -C ${colheaders} --fai  ${genome}.fai -s $gwasname ${gwastats} 
#[[ -f ${gwastats/.tsv.bgz/.bcf.csi} ]] || \
time bcftools index --force ${gwastats/.tsv.bgz/.bcf}
[[ -f ${cytoBand}  ]] || { echo "cytoband files" ;  exit 0 ;}
#[[ -f ${gwastats/.tsv.bgz/.png} ]] || \
time assoc_plot.R \
  --cytoband ${cytoBand} \
  --vcf ${gwastats/.tsv.bgz/.bcf} \
  --png ${gwastats/.tsv.bgz/.png}