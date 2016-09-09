#!/bin/bash

# replace with locations of the binary and chain file
liftOver kabuki_hg18.bed hg18ToHg19.over.chain kabuki_hg19.bed unmapped.txt

# bases are on the negative strand
cat kabuki_hg19.bed | perl -nle '@a=split; if($a[3] =~ /([ACGT])\d+([ACGT])/){ $r = $1; $r =~ tr/ACGT/TGCA/; $a = $2; $a =~ tr/ACGT/TGCA/; print join("\t", @a[0..2], $r, $a) }' > kabuki_hg19.tsv

# create VCF file
~/github/learning_vcf_file/script/create_vcf.pl ~/genome/hg19/hg19.fa kabuki_hg19.tsv > kabuki_hg19.vcf

# dbNSFP
wget -c ftp://dbnsfp:dbnsfp@dbnsfp.softgenetics.com/dbNSFPv3.2a.zip
unzip dbNSFPv3.2a.zip
java search_dbNSFP32a -i kabuki_hg19.vcf -o kabuki_hg19_dbnsfp.out -v hg19

# repeat steps above with variants causing Miller syndrome
liftOver miller_hg18.bed ~/data/ucsc/hg18ToHg19.over.chain miller_hg19.bed unmapped.txt
# bases are on the positive strand
cat miller_hg19.bed | perl -nle '@a=split; if($a[3] =~ /([ACGT])\d+([ACGT])/){ print join("\t", @a[0..2], $1, $2) }' > miller_hg19.tsv
~/github/learning_vcf_file/script/create_vcf.pl ~/genome/hg19/hg19.fa miller_hg19.tsv > miller_hg19.vcf
java search_dbNSFP32a -i miller_hg19.vcf -o miller_hg19_dbnsfp.out -v hg19

# ClinVar variants

wget -c ftp://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh37/clinvar_20160831.vcf.gz

