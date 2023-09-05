#!/usr/bin/env bash
# install bcfools and plugins
mamba_env=/home/sounkoumahamane.toure/micromamba/envs/gwasprojects/
## make sure zlib is istalled
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${mamba_env}/include
export LDFLAGS="-L${mamba_env}/lib"
export CFLAGS="-I${mamba_env}/include"
export CPATH="${mamba_env}/include"
cd ../score
wget https://github.com/samtools/bcftools/releases/download/1.16/bcftools-1.16.tar.bz2
tar xjvf bcftools-1.16.tar.bz2
cd bcftools-1.16
/bin/rm -f plugins/{score.{c,h},{munge,liftover,blupx,metal}.c}
echo https://raw.githubusercontent.com/freeseek/score/master/{score.{c,h},{munge,liftover,blupx,metal}.c} \
| tr " " "\n" |xargs -I {} wget -P plugins {} 
make
/bin/cp bcftools plugins/{munge,liftover,score,metal,blupx}.so $mamba_env/bin/
wget -P $HOME/bin https://personal.broadinstitute.org/giulio/score/assoc_plot.R
chmod a+x $mamba_env/bin/assoc_plot.R
make 
./configure 
cd htslib-1.16
make 
./configure 
cd ..
make 
/bin/cp bcftools htslib*/tabix plugins/* $mamba_env/bin/
wget -P $mamba_env https://raw.githubusercontent.com/freeseek/score/master/assoc_plot.R
chmod a+x $mamba_env/bin/assoc_plot.R
cd ..
rm -rf bcftools-1.16*
export BCFTOOLS_PLUGINS="$mamba_env/bin"