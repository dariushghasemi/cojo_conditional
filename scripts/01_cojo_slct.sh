#!/bin/bash

#SBATCH --job-name gcta
#SBATCH --output %j_cojo_slct_5e8.log
#SBATCH --partition cpuq
#SBATCH --cpus-per-task 1
#SBATCH --mem 1G
#SBATCH --time 1-00:00:00

# load paramters and softwares
source /scratch/dariush.ghasemi/projects/cojo_conditional/config/config
source /exchange/healthds/singularity_functions

#---------------------------------# 
# COJO using inputs from finemapping pipe

# gcta  \
#   --bfile   ../$locus/${random} \
#   --cojo-p 0.0001 \
#   --extract ../$locus/${random}_locus_only.snp.list \
#   --cojo-file ../$locus/${random}_sum.txt \
#   --cojo-slct \
#   --out step_1/${locus}_step1

#---------------------------------# 

# extract locus components
chr=$(echo $locus | cut -d_ -f1)
beg=$(echo $locus | cut -d_ -f2)
end=$(echo $locus | cut -d_ -f3)

# outputs
gwas="$odir/${locus}_subset.regenie"
snp_list="$odir/${locus}_subset.snps"
ofile="$odir/step_1/${locus}_step1"

# create output directory
mkdir -p $odir/step_1

# subset of GWAS to restrict to region
tabix -h ${PWAS} $chr:$beg-$end | awk '{ {print $3,$4,$5,$6,$10,$11,$13,$14} }' > $gwas

# optional for GCTA: prepare list of variants at the locus
cat  $gwas | awk '{print $1}' > $snp_list

# or
##zcat ${PWAS} | awk '{if($1==6 && $2<32786291 && $2>31405620) {print $3}}' > seq.13435.31.list
##zcat ${PWAS} | awk '{if($1==6 && $2<32786291 && $2>31405620) {print $3,$4,$5,$6,$10,$11,$13,$14}}' > seq.13435.31.sum

echo "==============================="
echo "A subset of GWAS including SNPs in ${locus} locus was created."
echo "==============================="


gcta  \
  --bfile  ${bed}${chr} \
  --cojo-p  $p_cojo \
  --extract   $snp_list \
  --cojo-file $gwas \
  --cojo-slct  \
  --out  $ofile

  # --extract   ../glm_model/out/${seqid}/${locus}.variants \
  # --cojo-file ../glm_model/out/${seqid}/${locus}.sum.txt \