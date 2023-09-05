#!/usr/bin/env bash
# install gwas-vcf munging headers 
project_dir=$(dirname $0)/..
cd ${project_dir} || exit 
echo  ${project_dir}
wget https://raw.githubusercontent.com/neurogenomics/MungeSumstats/master/data/sumstatsColHeaders.rda
which Rscript
(Rscript -e 'load("sumstatsColHeaders.rda"); write.table(sumstatsColHeaders, "sumstatsColHeaders.tsv", quote=FALSE, sep="\t", row.names=FALSE, col.names=FALSE)' \
awk -F"\t" -v OFS="\t" '
  ($1~"^ALT" || $1~"^EFF" || $1~"^MINOR" || $1~"^INC" || $1~"T[eE][sS][tT][eE][dD]" || $1=="EA") && $2=="A2" {$2="A1"}
  ($1~"^REF" || $1~"^NON" || $1~"^OTHER" || $1~"^MAJOR" || $1~"^DEC" || $1=="NEA") && $2=="A1" {$2="A2"}
  ($1=="A2FREQ" || $1=="A2FRQ") && $2=="FRQ" {$2="A2FRQ"}
  ($1=="EFFECTIVE_N" || $1=="NEFF") && $2=="N" {$2="NEFF"} {print}' sumstatsColHeaders.tsv
echo -e "CHR_NAME\tCHR"
echo -e "BP_GRCH38\tBP"
echo -e "CHR\tCHR"
echo -e "CHR_POSITION\tBP"
echo -e "BP\tBP"
echo -e "Beta\tBETA"
echo -e "Beta\tBETA"
echo -e "GENPOS\tBP"
echo -e "NAME\tSNP"
echo -e "VARIANT_ID\tSNP"
echo -e "AL1\tA1"
echo -e "AL2\tA2"
echo -e "A1\tA2"
echo -e "A2\tA1"
echo -e "IMPINFO\tINFO"
echo -e "IMPUTATION\tINFO"
echo -e "R2HAT\tINFO"
echo -e "RSQ\tINFO"
echo -e "EFFECT_WEIGHT\tBETA"
echo -e "INV_VAR_META_BETA\tBETA"
echo -e "Beta\tBETA"
echo -e "MAF\tMAF"
echo -e "ALL_INV_VAR_META_BETA\tBETA"
echo -e "ALL_META_SAMPLE_N\tN"
echo -e "INV_VAR_META_SEBETA\tSE"
echo -e "ALL_INV_VAR_META_SEBETA\tSE"
echo -e "SE\tSE"
echo -e "LOG10_P\tLP"
echo -e "LOG10P\tLP"
echo -e "MLOG10P\tLP"
echo -e "P.SE\tP"
echo -e "INV_VAR_META_P\tP"
echo -e "ALL_INV_VAR_META_P\tP"
echo -e "P\tP"
echo -e "FRQ\tFRQ"
echo -e "N\tN"
echo -e "FREQ_EFFECT\tFRQ"
echo -e "ALL_META_AF\tFRQ"
echo -e "NCAS\tN_CAS"
echo -e "NCON\tN_CON"
echo -e "Weight\tNEFF"
echo -e "NEFFDIV2\tNEFFDIV2"
echo -e "HetISq\tHET_I2"
echo -e "HetISqt\tHET_I2"
echo -e "HetPVa\tHET_P"
echo -e "HetPVal\tHET_P"
echo -e "logHetP\tHET_LP"
echo -e "Direction\tDIRE"
echo -e "DIRE\tDIRE") >  reformat_data/colheaders.tsv
/bin/rm sumstatsColHeaders.rda sumstatsColHeaders.tsv