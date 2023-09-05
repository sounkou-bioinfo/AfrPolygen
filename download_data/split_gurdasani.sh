#!/usr/bin/env bash
# Download and reformat gurdasani and co-workers data
dest_dir=${1:-"/protected/sounkoumahamane.toure/AfrPolygenData/SummaryStats"} ## root dir
temp=${dest_dir}/temp
project_dir="/home/sounkoumahamane.toure/Projects/AfrPolygen/" ## scripts dir
gwasvcfscript="${project_dir}/reformat_data/convert_sumstats_to_vcf.sh" ## tsv to bcf
plugin_bins_dir=/home/sounkoumahamane.toure/micromamba/envs/gwasprojects/bin
PATH=$PATH:$plugin_bins_dir
[[ -f ${gwasvcfscript} ]] || exit 
cd ${dest_dir} || exit
[[ -d ${temp} ]] || mkdir -p  ${temp}
##
## body sort
body() {
    IFS= read -r header
    printf '%s\n' "$header"
    "$@"
}
### grab annotated file
### split it and remove it
find ${dest_dir} -name "*annotated.txt.gz" | while read -r basestats; do 
    echo "${basestats}"
    # find studied cohorts
    base=${basestats/annotated.txt.gz/}
    cohorts=$(zcat "${basestats}" \
    | head -1 | tr " " "\n" | grep -i "no_" | cut -f2 -d" " | tr "\n" "," | sed 's/,$//')
    echo $cohorts
    echo $base
    studies=(${cohorts//no_/ })
    n_studies=${#studies[@]}
    if [[ ! -f ${base}_${studies[n_studies-1]}.gz ]] ; then
        zcat "${basestats}" \
        | awk -F" " -v ch=${cohorts//no_} -v outname_pref="${base}" '
        {   
            split(ch,studies,",")
            if( NR == 1 ){
            
                for( i in studies){
                    for( j = 1 ; j <= NF; j++){
                # betas

             if( $j == "beta_"studies[i] ){
                    beta[i]=j
                
                }
                if( $j == "se_"studies[i] ){
                    se[i]=j
                
                }
                if( $j == "pval_"studies[i] ){
                    pval[i]=j
                
                }
                if( $j == "no_"studies[i] ){
                    Nval[i]=j
                
                }
                if( $j == "af_"studies[i] ){
                    af[i]=j
                
                }
            
            
            }
            print "SNP\tCHR\tBP\tA1\tA2\tBeta\tSE\tFRQ\tN\tP\tMAF" | "gzip > " outname_pref "_" studies[i] ".gz"
        }
       

       
        }
        else {
            SNP=$1
            split($1,cord,":")
            chrom=cord[1]
            bp=cord[2]
            a1=cord[3]
            a2=cord[4]
         
            for( i in studies){
                maf=( $af[i] < 1- $af[i]? $af[i]:1-$af[i])
                if( $se[i] != "NA" ) print $1"\t"chrom"\t"bp"\t"a1"\t"a2"\t"$beta[i]"\t"$se[i]"\t"$af[i]"\t"$Nval[i]"\t"$pval[i]"\t"maf | "gzip > " outname_pref "_" studies[i] ".gz"
             }
          
            #  if(NR > 10) exit

        }
        }' 
    fi
    echo "${cohorts//no_/}" | tr "," "\n"  | while read -r study; do 
        echo "${base}_${study}.gz"
        echo ${base}_${study}.tsv.bgz
        echo "time zcat  ${base}_${study}.gz | body sort -k2,2 -k3,3n -T "${temp}"  | uniq | bgzip -c  > ${base}_${study}.tsv.bgz"
        time zcat  ${base}_${study}.gz | body sort -k2,2 -k3,3n -T "${temp}"  | uniq | bgzip -c  > ${base}_${study}.tsv.bgz
        echo "time tabix -S 1 -s2 -e 3 -b 3 ${base}_${study}.tsv.bgz"
        time tabix -S 1 -s2 -e 3 -b 3 ${base}_${study}.tsv.bgz
        echo "bash $gwasvcfscript ${base}_${study}.tsv.bgz"
        micromamba run -n gwasprojects bash $gwasvcfscript ${base}_${study}.tsv.bgz
        /bin/rm ${base}_${study}.gz $basestats
  done 
done