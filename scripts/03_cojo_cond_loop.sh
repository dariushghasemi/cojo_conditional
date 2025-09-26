#!/bin/bash

#SBATCH --job-name gcta
#SBATCH --output %j_cojo_cond.log
#SBATCH --partition cpuq
#SBATCH --cpus-per-task 1
#SBATCH --mem 2G
#SBATCH --time 1-00:00:00

# load paramters and softwares
source /scratch/dariush.ghasemi/projects/cojo_conditional/config/config
source /exchange/healthds/singularity_functions

#---------------------------------# 

# extract locus components
chr=$(echo $locus | cut -d_ -f1)

# inputs and outputs
gwas="$odir/${locus}_subset.regenie"
snp_list="$odir/${locus}_subset.snps"
cojo_list="$odir/step_1/${locus}_step1.jma.cojo"
lead_list="$odir/step_1/${locus}_lead.snps"

# list of COJO variants without headers
tail -n+2 $cojo_list | cut -f2 > $lead_list

# create output directory
mkdir -p $odir/step_2

#---------------------------------#
# run conditional analysis for all lead SNPs
while read Lk; do
  SNP=$(echo $Lk | tr ':' '_')
  mkdir -p $odir/step_2/${SNP}/

  OUT="$odir/step_2/${SNP}/${locus}_LOO"
  snps2adjust="$odir/step_2/${SNP}/${locus}_LOO.adjusted4"

  grep -v "^${Lk}$" $lead_list | paste -sd'\n' - > ${snps2adjust}
 
  gcta \
    --bfile ${bed}${chr} \
    --extract   $snp_list \
    --cojo-file $gwas \
    --cojo-cond "$snps2adjust" \
    --cojo-wind $window \
    --out "$OUT"
done < $lead_list

