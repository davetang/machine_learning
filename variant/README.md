Machine learning on variants
============================

List of manually collected variants that are known to be pathogenic.

* Known pathogenic variants for [Kabuki syndrome](https://en.wikipedia.org/wiki/Kabuki_syndrome) from the work of [Ng et al. in Nature Genetics 2010](http://www.ncbi.nlm.nih.gov/pubmed/20711175); variants available in [Supplementary Table 3](http://www.nature.com/ng/journal/v42/n9/extref/ng.646-S1.pdf)
* Known pathogenic variants for [Miller syndrome](https://en.wikipedia.org/wiki/Miller_syndrome) from the work of [Ng et al. in Nature Genetics 2010](http://www.ncbi.nlm.nih.gov/pubmed/19915526); variants are available in Table 4

# ClinVar variants

Accessing and using data in [ClinVar](http://www.ncbi.nlm.nih.gov/clinvar/docs/maintenance_use/#download)

~~~~{.bash}
# download and index data
wget -c ftp://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh37/clinvar_20160831.vcf.gz
gunzip clinvar_20160831.vcf.gz
bgzip clinvar_20160831.vcf
tabix -p vcf clinvar_20160831.vcf.gz

# how many variants?
gunzip -c clinvar_20160831.vcf.gz | grep -v "^#" | wc -l
130740

# Variant Clinical Significance
# 0 - Uncertain significance
# 1 - not provided
# 2 - Benign
# 3 - Likely benign
# 4 - Likely pathogenic
# 5 - Pathogenic
# 6 - drug response
# 7 - histocompatibility
# 255 - other
bcftools query -f '%CLNSIG\n' clinvar_20160831.vcf.gz | head
5
5
2
0
5
3
5
0
2

# tally of clinical significance
bcftools query -f '%CLNSIG\n' clinvar_20160831.vcf.gz  | sort | uniq -c | sort -k1rn | head
  31464 0
  26623 5
  12895 3
  12565 2
  11198 1
   6006 4
   4058 255
   2955 0|0
   2792 5|5
   1033 2|2

# how many variant have conflicting codes?
bcftools query -f '%CLNSIG\n' clinvar_20160831.vcf.gz  |
perl -nle 'next if /^\d+$/;
@l = split(/\||,/);
for($i=1; $i<=$#l; ++$i){
   if ($l[0] != $l[$i]){
       print; last
   }
}' | wc -l
12685

# how many of the Kabuki syndrome variants are in ClinVar?
# two out of six
cat kabuki_hg19.bed |
sed 's/^chr//' |
bedtools intersect -a stdin -b clinvar_20160831.vcf.gz -u
12      49420553        49420554        c.G15195A       0       +
12      49432650        49432651        c.C8488T        0       +

# and Miller syndrome?
# nine out of eleven
cat miller_hg19.bed |
sed 's/^chr//' |
bedtools intersect -a stdin -b clinvar_20160831.vcf.gz -u
16      72045982        72045983        G56A    0       +
16      72048539        72048540        C403T   0       +
16      72050941        72050942        G454A   0       +
16      72055099        72055100        C595T   0       +
16      72055109        72055110        G605A   0       +
16      72055109        72055110        G605C   0       +
16      72056284        72056285        C730T   0       +
16      72057434        72057435        C1036T  0       +
16      72057434        72057435        C1036T  0       +
~~~~

# Further reading

* Sarah Ng's [PhD thesis](https://digital.lib.washington.edu/researchworks/bitstream/handle/1773/21834/Ng_washington_0250E_11012.pdf)

