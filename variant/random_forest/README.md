Random Forest classifier
========================

Training a Random Forest classifier for classifying genetic variants; more information on the analysis is in [analysis.R](https://github.com/davetang/machine_learning/blob/master/variant/random_forest/analysis.R). For introductory material on Random Forest, see my [Random Forest repository](https://github.com/davetang/learning_random_forest).

# ClinVar

Use the Review Status to select clinically significant variants; the highest level of [review status](https://www.ncbi.nlm.nih.gov/clinvar/docs/review_guidelines/) is four gold stars. There are only 23 variants with four stars, all of which are for cystic fibrosis.

~~~~{.bash}
# https://en.wikipedia.org/wiki/Cystic_fibrosis
# Cystic fibrosis (CF) is a genetic disorder that affects mostly the lungs, but also the pancreas, liver, kidneys, and intestine.
# Long-term issues include difficulty breathing and coughing up mucus as a result of frequent lung infections.
bcftools query -f '%CLNDBN\t%CLNREVSTAT\n' clinvar.vcf.gz | grep -i guideline
Cystic_fibrosis|not_provided,Cystic_fibrosis    guideline|single,no_assertion
Cystic_fibrosis|Congenital_bilateral_absence_of_the_vas_deferens|not_provided|Cystic_fibrosis,Cystic_fibrosis,Cystic_fibrosis   guideline|no_criteria|single|exp,no_assertion,no_assertion
Cystic_fibrosis guideline
Cystic_fibrosis guideline
Cystic_fibrosis|not_provided    guideline|single
Cystic_fibrosis|not_provided,Cystic_fibrosis,Cystic_fibrosis    exp|single,guideline,no_criteria
Cystic_fibrosis guideline
Cystic_fibrosis|not_provided    guideline|single
Cystic_fibrosis|Bronchiectasis_with_or_without_elevated_sweat_chloride_1\x2c_modifier_of|not_provided|Hereditary_pancreatitis|ivacaftor_response_-_Efficacy     guideline|no_criteria|no_criteria|no_criteria|exp
Cystic_fibrosis|not_provided    guideline|single
Cystic_fibrosis|not_provided|Hereditary_pancreatitis    guideline|single|no_criteria
Cystic_fibrosis|Hereditary_pancreatitis|ivacaftor_response_-_Efficacy   guideline|no_criteria|exp
Cystic_fibrosis,Cystic_fibrosis no_assertion,guideline
Cystic_fibrosis,Cystic_fibrosis|not_provided    exp,guideline|single
Cystic_fibrosis,Cystic_fibrosis,Cystic_fibrosis guideline,exp,no_assertion
Cystic_fibrosis guideline
Cystic_fibrosis guideline
Cystic_fibrosis|not_provided    guideline|no_criteria
Cystic_fibrosis guideline
Cystic_fibrosis guideline
Cystic_fibrosis|not_provided    guideline|no_criteria
Cystic_fibrosis guideline
Cystic_fibrosis|not_provided    guideline|single

# exp = reviewed by expert panel, which is equivalent to three stars
bcftools query -f '%CLNREVSTAT\n' clinvar.vcf.gz | sort | uniq -c | sort -k1rn | head
  58387 single
  29342 no_criteria
  11198 no_assertion
   5897 single|single
   2210 exp
   2005 mult
   1975 no_criteria|single
   1842 conf
   1387 single|single|single
   1273 no_criteria|no_criteria

# most expertly reviewed variants are for a few disorders
# https://ghr.nlm.nih.gov/condition/lynch-syndrome
# Lynch syndrome, often called hereditary nonpolyposis colorectal cancer (HNPCC)
# is an inherited disorder that increases the risk of many types of cancer,
# particularly cancers of the colon (large intestine) and rectum,
# which are collectively referred to as colorectal cancer
bcftools query -f '%CLNDBN\t%CLNREVSTAT\n' clinvar.vcf.gz | awk '$2=="exp" {print}' | sort | uniq -c | sort -k1rn | head
   1203 Lynch_syndrome  exp
    398 Breast-ovarian_cancer\x2c_familial_1    exp
    383 Breast-ovarian_cancer\x2c_familial_2    exp
    164 Cystic_fibrosis exp
     10 warfarin_response_-_Dosage      exp
      6 radiotherapy_response_-_Toxicity/ADR    exp
      4 Lynch_syndrome_I        exp
      2 anthracyclines_and_related_substances_response_-_Toxicity/ADR   exp
      2 antipsychotics_response_-_Toxicity/ADR  exp
      2 aspirin_response_-_Efficacy     exp
~~~~

Further annotation using dbNSFP.

~~~~{.bash}
gunzip clinvar.vcf.gz

# only works with uncompressed VCF
java search_dbNSFP32a -i clinvar.vcf -o clinvar.out -v hg19
# 68888 SNP(s) are found.
# 61254 SNP(s) are not found.

bgzip clinvar.vcf

# six variants with 4 stars could be annotated by dbNSFP
cat clinvar.out | awk -F'\t' '$180==4 {print}'  | wc -l
6
~~~~

## Expression specificity for ClinVar variants

~~~~{.bash}
# these are the six CF variants
cat clinvar.out | awk -F'\t' '$180==4 {print $208}'
TISSUE SPECIFICITY: Expressed in the respiratory airway, including bronchial epithelium, and in the female reproductive tract, including oviduct (at protein level). {ECO:0000269|PubMed:22207244}.; 
TISSUE SPECIFICITY: Expressed in the respiratory airway, including bronchial epithelium, and in the female reproductive tract, including oviduct (at protein level). {ECO:0000269|PubMed:22207244}.; 
TISSUE SPECIFICITY: Expressed in the respiratory airway, including bronchial epithelium, and in the female reproductive tract, including oviduct (at protein level). {ECO:0000269|PubMed:22207244}.; 
TISSUE SPECIFICITY: Expressed in the respiratory airway, including bronchial epithelium, and in the female reproductive tract, including oviduct (at protein level). {ECO:0000269|PubMed:22207244}.; 
TISSUE SPECIFICITY: Expressed in the respiratory airway, including bronchial epithelium, and in the female reproductive tract, including oviduct (at protein level). {ECO:0000269|PubMed:22207244}.; 
TISSUE SPECIFICITY: Expressed in the respiratory airway, including bronchial epithelium, and in the female reproductive tract, including oviduct (at protein level). {ECO:0000269|PubMed:22207244}.;

# ClinVar variants with expert panel assertion
cat clinvar.out | awk -F'\t' '$180==3 {print $179,$208}' | sort -u
Breast-ovarian cancer, familial 1 TISSUE SPECIFICITY: Isoform 1 and isoform 3 are widely expressed. Isoform 3 is reduced or absent in several breast and ovarian cancer cell lines.; 
Breast-ovarian cancer, familial 2 TISSUE SPECIFICITY: Highest levels of expression in breast and thymus, with slightly lower levels in lung, ovary and spleen.; 
Cystic fibrosis TISSUE SPECIFICITY: Expressed in the respiratory airway, including bronchial epithelium, and in the female reproductive tract, including oviduct (at protein level). {ECO:0000269|PubMed:22207244}.; 
Lynch syndrome .
Lynch syndrome I .
Lynch syndrome I TISSUE SPECIFICITY: Colon, lymphocytes, breast, lung, spleen, testis, prostate, thyroid, gall bladder and heart.; 
Lynch syndrome TISSUE SPECIFICITY: Colon, lymphocytes, breast, lung, spleen, testis, prostate, thyroid, gall bladder and heart.; 
Lynch syndrome TISSUE SPECIFICITY: Ubiquitously expressed. {ECO:0000269|PubMed:10856833}.; 
~~~~

# Grimm et al.

Using the variants provided by [Grimm et al.](https://www.ncbi.nlm.nih.gov/pubmed/25684150) as positive and negative sets of variants.

## False positives

Examples where Random Forest classified a negative variant as positive.

~~~~{.r}
# false positives, listed as positive but really is negative
data[c(7766,14528,19722,20147,23042,28612),c('CHR','Nuc.Pos','REF.Nuc','ALT.Nuc','X.RS.ID','True.Label')]
# CHR   Nuc.Pos REF.Nuc ALT.Nuc    X.RS.ID True.Label
# 7766   14  62016431       A       T rs35561533         -1
# 14528  19  11348960       G       A rs12609039         -1
# 19722   1 246930564       G       C     rs7779         -1
# 20147   1  44456013       G       C rs35904809         -1
# 23042  22  45944576       T       A  rs1802787         -1
# 28612   4 166403424       T       A rs34516004         -1
~~~~

## False negatives

Examples where Random Forest classified a positive variant as negative.

~~~~{.r}
# false negatives, i.e. listed as negative but really is positive
data[c(4015,6867,20187,22798,34844,36297,39089),c('CHR','Nuc.Pos','REF.Nuc','ALT.Nuc','X.RS.ID','True.Label')]
# CHR  Nuc.Pos REF.Nuc ALT.Nuc    X.RS.ID True.Label
# 4015   11 76853783       T       C  rs1052030          1
# 6867   13 52544715       C       A          ?          1
# 20187   1 45481018       G       A          ?          1
# 22798  22 36661906       A       G rs73885319          1
# 34844   8 21976710       T       C  rs7014851          1
# 36297   9 34649442       A       G  rs2070074          1
# 39089   X 31496398       T       C  rs1800279          1
~~~~

However, it is not certain whether these variants are truly negative.

* [rs1052030 is listed as benign](http://www.ncbi.nlm.nih.gov/clinvar/variation/43258/)
* [rs73885319 is listed only as a risk factor](http://www.ncbi.nlm.nih.gov/clinvar/variation/6080/)
* [rs7014851 is listed as uncertain significance](http://www.ncbi.nlm.nih.gov/clinvar/variation/7330/)
* [rs2070074 has conflicting information](http://www.ncbi.nlm.nih.gov/clinvar/variation/3613/)
* [rs1800279 has conflicting information](http://www.ncbi.nlm.nih.gov/clinvar/variation/11269/)

# Further annotating the Grimm et al. data set

The Grimm et al. variants are annotated with MutationTaster, MutationAssessor, PolyPhen2, CADD, SIFT, LRT, FatHMM, GERP, and PhyloP. More annotation information can be added to these variants using dbNSFP.

~~~~{.bash}
# combine all the datasets and save positive variants
cat ../DataS1/ToolScores/*.csv |
grep -v "^True" |
grep -v "PATCH" |
grep -v "chrMT" |
perl -anl -F/,/ -e '$F[2] =~ s/^chr//;
next unless $F[0] == 1;
print join("\t", "chr$F[2]", $F[3]-1, $F[3], $F[4], $F[5])' > positive.tsv

# combine all the datasets and save negative variants
cat ../DataS1/ToolScores/*.csv |
grep -v "^True" |
grep -v "PATCH" |
grep -v "chrMT" |
grep -v "HSCHR6" |
grep -v "HSCHR19" |
grep -v "chrGL000209" |
perl -anl -F/,/ -e '$F[2] =~ s/^chr//;
next unless $F[0] == -1;
print join("\t", "chr$F[2]", $F[3]-1, $F[3], $F[4], $F[5])' > negative.tsv

# sort files
cat positive.tsv | sort -k1,1V -k2,2n > blah
mv -f blah positive.tsv 
cat negative.tsv | sort -k1,1V -k2,2n > blah
mv -f blah negative.tsv 

# create a simple VCF file from the TSV file
~/github/learning_vcf_file/script/create_vcf.pl ~/genome/hg19/hg19.fa positive.tsv > positive.vcf
~/github/learning_vcf_file/script/create_vcf.pl ~/genome/hg19/hg19.fa negative.tsv > negative.vcf

# annotate using dbNSFP
java search_dbNSFP32a -i positive.vcf -o positive_dbnsfp.out -v hg19
# 36579 SNP(s) are found. Written to positive_dbnsfp.out
# 40 SNP(s) are not found. Written to positive_dbnsfp.out.err
java search_dbNSFP32a -i negative.vcf -o negative_dbnsft.out -v hg19
# 41833 SNP(s) are found. Written to negative_dbnsft.out
# 517 SNP(s) are not found. Written to negative_dbnsft.out.err

cat positive_dbnsfp.out | head -1 | transpose | nl | head
     1  #chr
     2  pos(1-based)
     3  ref
     4  alt
     5  aaref
     6  aaalt
     7  rs_dbSNP146
     8  hg19_chr
     9  hg19_pos(1-based)
    10  hg18_chr

# lots of annotation goodness
cat positive_dbnsfp.out | head -1 | transpose | nl | tail
   443  Gene damage prediction (cancer recessive disease-causing genes)
   444  Gene damage prediction (cancer dominant disease-causing genes)
   445  LoFtool_score
   446  Essential_gene
   447  MGI_mouse_gene
   448  MGI_mouse_phenotype
   449  ZFIN_zebrafish_gene
   450  ZFIN_zebrafish_structure
   451  ZFIN_zebrafish_phenotype_quality
   452  ZFIN_zebrafish_phenotype_tag
~~~~

