# AfrPolygen
Gather, reformat and analyse African ancestry GWAS summary statistics
## Dependencies
construct a micromamba environement with necessary tools
for each analysis steps
### Data prep and conversions 
```{bash}
git clone https://github.com/sounkou-bioinfo/AfrPolygen.git --branch main
cd AfrPolygen
micromamba env create --file gwasprojects.yaml
# install bcftools
micromamba run -n  gwasprojects bash ./reformat_data/install_score.sh
# install headers convertion map
# make sure this mapping is correct
micromamba run -n  gwasprojects bash ./reformat_data/install_munge_headers.sh
# install genome files
micromamba run -n  gwasprojects bash ./reformat_data/install_genomes.sh

```
## Organisation
### Data prep
#### Download and reformat summary statistics
#### Download LD reference files
#### Download ancestry frequencies files
#### harmonize summary stats, LD and frequency files
### Analyses
#### Meta-analyses 