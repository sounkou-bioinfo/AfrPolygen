#!/usr/bin/bash
# download bigsnpr reference frequency  and pc loading files
# tabix , index and create bigsnpr object files
bigsnpr_base_dir=/mnt/d/AfrPolygenData/SummixBigsnprFIles
cat << EOF > Download_bigsnpr.R
  runonce::download_file(
     "https://figshare.com/ndownloader/files/31620968",  # for real analyses (849 MB)
    dir = "$bigsnpr_base_dir", fname = "ref_freqs.csv.gz")
   
  runonce::download_file(
    "https://figshare.com/ndownloader/files/31620953",  # for real analyses (847 MB)
    dir = "$bigsnpr_base_dir", fname = "projection.csv.gz")

# coefficients to correct for overfitting of PCA
correction <- c(1, 1, 1, 1.008, 1.021, 1.034, 1.052, 1.074, 1.099,
1.123, 1.15, 1.195, 1.256, 1.321, 1.382, 1.443)
writeLines(correction,"$bigsnpr_base_dir/correction_factors.txt")
EOF
cat Download_bigsnpr.R
Rscript Download_bigsnpr.R