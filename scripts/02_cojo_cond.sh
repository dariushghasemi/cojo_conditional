#!/bin/bash

#SBATCH --job-name gcta
#SBATCH --output %j_cojo_cond.log
#SBATCH --partition cpuq
#SBATCH --cpus-per-task 1
#SBATCH --mem 2G
#SBATCH --time 1-00:00:00

source /exchange/healthds/singularity_functions

bed="/exchange/healthds/pQTL/INTERVAL/Genetic_QC_files/bed/qc_recoded_harmonised/impute_recoded_selected_sample_filter_hq_var_new_id_alleles_"

#  seq.13125.45
chrom=17
#SNP=17_26695467
locus=17_25183026_30075846
#random=wV5zX4XX8kvPPe9wgJPh
p_cojo=1.256913021618904e-11

# list of COJO variants without headers
tail -n+2 step_1/${locus}_step1.jma.cojo | cut -f2 > step_1/lead_list.txt

mkdir -p step_2/

# gcta  \
#   --bfile   ${bed}${chrom}  \
#   --cojo-p  $p_cojo  \
#   --extract   $locus/${random}_locus_only.snp.list  \
#   --cojo-file $locus/${random}_sum.txt   \
#   --cojo-cond $locus/snps_to_adjust.snp  \
#   --out step_2/${locus}_${SNP}_step2

gcta  \
  --bfile  ${bed}${chrom}  \
  --cojo-p $p_cojo  \
  --extract   step_1/17_25183026_30075846_subset.snps \
  --cojo-file step_1/17_25183026_30075846_subset.regenie \
  --cojo-cond step_1/lead_list.txt  \
  --out step_2/${locus}_test_26617425_step2
