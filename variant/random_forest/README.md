Random Forest classifier
========================

[Random Forest](https://github.com/davetang/learning_random_forest) is one of many machine learning approaches that usually works quite well. Here we will build a Random Forest classifier for classifying benign and pathogenic genetic variants. To begin I will require training data; I will use ClinVar and the SwissVarSelected variants from Grimm et al. 2015, and annotate the variants using [dbNSFP](https://sites.google.com/site/jpopgen/dbNSFP).

# dbNSFP

[dbNSFP](https://sites.google.com/site/jpopgen/dbNSFP) is a database developed for functional prediction and annotation of all potential non-synonymous single-nucleotide variants (nsSNVs) in the human genome. The latest version is 3.3 and the zip file is ~14G in size; all nsSNVs are stored hence the large file size.

~~~~{.bash}
wget -c ftp://dbnsfp:dbnsfp@dbnsfp.softgenetics.com/dbNSFPv3.3a.zip
~~~~

Once downloaded, there's a Java program that you can use to obtain annotations for your variants. Currently, the search program supports two file formats: VCF format or a custom format. The program automatically recognises a VCF file if its extension is "*.vcf" and it will query the database by the CHR, POS, REF, and ALT columns. I prefer to work with VCF files.

~~~~{.bash}
java search_dbNSFP33a 
Usage: search_dbNSFP33a [Options] -i input_file_name -o output_file_name
Options (not necessary):
-v human_genome_version
   human_genome_version=hg18, hg19 or hg38, default=hg38
   for example "-v hg19"
-c list_of_chromosomes_to_search
   chromosomes are represented by 1,2,...,22,X,Y, separated by commas
   default=all chromosomes
   for example "-c 1,3,22,X"
-w list_of_columns_to_write_to_output_file
   columns are represented by 1,2,..., separated by commas,
   continuous number block can be simplified by begin-end
   default=all columns
   for example "-w 1-6,8"
-p
   preserve all columns of the input vcf file in the output file
   only work if the input file is in vcf format
   may require large memory for a large vcf file
-s
   will search attached database(s) dbscSNV (and SPIDEX, if available)
   will be outputed to output_file_name.dbscSNV (and output_file_name.SPIDEX)

# example running in the directory where you unzipped dbNSFPv3.3a.zip
java search_dbNSFP33a -i ~/github/machine_learning/variant/kabuki_hg19.vcf -o ~/github/machine_learning/variant/kabuki_hg19_dbnsfp.out -v hg19
Searching based on hg19 coordinates:
        Searching chr12

6 SNP(s) are found. Written to ~/github/machine_learning/variant/kabuki_hg19_dbnsfp.out

cat ~/github/machine_learning/variant/kabuki_hg19_dbnsfp.out | head -2 | transpose | column -t | head -20
#chr                                         12
pos(1-based)                                 49026348
ref                                          A
alt                                          C
aaref                                        Y
aaalt                                        X
rs_dbSNP147                                  .
hg19_chr                                     12
hg19_pos(1-based)                            49420131
hg18_chr                                     12
hg18_pos(1-based)                            47706398
genename                                     KMT2D
cds_strand                                   -
refcodon                                     TAT
codonpos                                     3
codon_degeneracy                             2
Ancestral_allele                             A
AltaiNeandertal                              A/A
Denisova                                     A/A
Ensembl_geneid                               ENSG00000167548

# CADD scores
cat ~/github/machine_learning/variant/kabuki_hg19_dbnsfp.out | head -2 | transpose | column -t | grep CADD
CADD_raw                                     14.894778
CADD_raw_rankscore                           0.99788
CADD_phred                                   48
~~~~

# ClinVar

ClinVar uses a "Review Status" to rank the significance of variants; the highest [Review Status](https://www.ncbi.nlm.nih.gov/clinvar/docs/review_guidelines/) is four gold stars. I wanted to select variants that have four gold stars but there are only 23 variants with four stars, all of which are for cystic fibrosis. [Cystic fibrosis](https://en.wikipedia.org/wiki/Cystic_fibrosis) (CF) is a genetic disorder that affects mostly the lungs, but also the pancreas, liver, kidneys, and intestine. Long-term issues include difficulty breathing and coughing up mucus as a result of frequent lung infections.

* The one star review status refers to "single submitter - criteria provided" assertions
* I'm not sure where two stars when
* The three star review status refers to "expert panel" assertions
* The four star review status refers to "practice guideline" assertions

~~~~{.bash}
# download latest version of ClinVar
wget ftp://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh37/clinvar_20170104.vcf.gz
# index
tabix -p vcf clinvar_20170104.vcf.gz

# how many variants?
zcat clinvar_20170104.vcf.gz | grep -v "^#" | wc -l
232624

##INFO=<ID=CLNREVSTAT,Number=.,Type=String,Description="no_assertion - No assertion provided, no_criteria - No assertion criteria provided, single - Criteria provided single submitter, mult - Criteria provided multiple submitters no conflicts, conf - Criteria provided conflicting interpretations, exp - Reviewed by expert panel, guideline - Practice guideline">
# most are single
bcftools query -f '%CLNREVSTAT\n' clinvar_20170104.vcf.gz | sort | uniq -c | sort -k1rn | head
 125507 single
  26998 no_criteria
  22832 single|single
  10625 no_assertion
   6775 single|single|single
   3840 exp
   2395 conf
   2363 mult
   2286 no_criteria|single
   1980 mult|single

# which have four stars?
bcftools query -f '%CLNREVSTAT\n' clinvar_20170104.vcf.gz | grep -i guideline
guideline|single,no_assertion
guideline|no_criteria|mult|exp|single,no_assertion,no_assertion
guideline|single
guideline|single
guideline|single
exp|single,guideline,no_criteria
guideline
guideline|single|single
guideline|no_criteria|single|single|exp
guideline|mult
guideline|single|single
guideline|single|exp|single
no_assertion,guideline|single
exp,guideline|single
guideline,exp,no_assertion
guideline
guideline|single
guideline|no_criteria|single
guideline
guideline
guideline|no_criteria|single
guideline|single|single
guideline|mult

# what disorders have four stars?
##INFO=<ID=CLNDBN,Number=.,Type=String,Description="Variant disease name">
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
# most expertly reviewed variants are for a few disorders
# https://ghr.nlm.nih.gov/condition/lynch-syndrome
# Lynch syndrome, often called hereditary nonpolyposis colorectal cancer (HNPCC)
# is an inherited disorder that increases the risk of many types of cancer,
# particularly cancers of the colon (large intestine) and rectum,
# which are collectively referred to as colorectal cancer
bcftools query -f '%CLNDBN\t%CLNREVSTAT\n' clinvar_20170104.vcf.gz | awk '$2=="exp" {print}' | sort | uniq -c | sort -k1rn | head
   1300 Breast-ovarian_cancer\x2c_familial_2    exp
   1196 Lynch_syndrome  exp
   1129 Breast-ovarian_cancer\x2c_familial_1    exp
    157 Cystic_fibrosis exp
      9 warfarin_response_-_Dosage      exp
      6 radiotherapy_response_-_Toxicity/ADR    exp
      3 Lynch_syndrome_I        exp
      2 anthracyclines_and_related_substances_response_-_Toxicity/ADR   exp
      2 antipsychotics_response_-_Toxicity/ADR  exp
      2 efavirenz_response_-_Metabolism/PK      exp
~~~~

What are the statistics on the clinical significance of the variants?

* 0 - Uncertain significance
* 1 - not provided
* 2 - Benign
* 3 - Likely benign
* 4 - Likely pathogenic
* 5 - Pathogenic
* 6 - drug response
* 7 - histocompatibility
* 255 - other

~~~~{.bash}
##INFO=<ID=CLNSIG,Number=.,Type=String,Description="Variant Clinical Significance, 0 - Uncertain significance, 1 - not provided, 2 - Benign, 3 - Likely benign, 4 - Likely pathogenic, 5 - Pathogenic, 6 - drug response, 7 - histocompatibility, 255 - other">
bcftools query -f '%CLNSIG\n' clinvar_20170104.vcf.gz | sort | uniq -c | sort -k1rn | head
  77815 0
  29289 5
  27305 3
  15385 2
  11675 0|0
  10659 1
   6531 4
   4572 255
   4552 3|3
   3392 5|5

# there are actually no histocompatibility variants
bcftools query -f '%CLNSIG\n' clinvar_20170104.vcf.gz | grep 7
# returns nothing
~~~~

## Annotating ClinVar variants with dbNSFP.

~~~~{.bash}
# dbNSFP only works with uncompressed VCF
gunzip -c clinvar_20170104.vcf.gz > clinvar_20170104.vcf

# ClinVar variants are on hg19
cat clinvar_20170104.vcf| grep reference=
##reference=GRCh37.p13

# run dbNSFP
java search_dbNSFP33a -i ~/github/machine_learning/variant/random_forest/clinvar_20170104.vcf -o ~/github/machine_learning/variant/random_forest/clinvar_20170104.out -v hg19
96860 SNP(s) are found. Written to ~/github/machine_learning/variant/random_forest/clinvar_20170104.out
135028 SNP(s) are not found. Written to ~/github/machine_learning/variant/random_forest/clinvar_20170104.out.err
~~~~

A lot of SNVs were not found; perhaps they are synonymous variants that are not included in dbNSFP? I should stratify the variants in the ClinVar VCF file based on their clinical significance and run dbNSFP on them separately. I would like to have just benign (class 2) and pathogenic (class 5) variants. As noted above, the `CLNSIG` information can have more than one code, which are separated by a pipe; I would like to exclude variants with conflicting codes, i.e. listed with both benign/likely benign and pathogenic/likely pathogenic. There are also cases where a comma is present. I will assume they are meant to be pipes.

~~~~{.bash}
bcftools query -f '%CLNSIG\n' clinvar_20170104.vcf.gz  | grep , | head
0|5|5|5|5|5|5|5|5|5|5|5|5|5|5|5|5|5|5|5|5|5|5,5|5|5|5|5|5|5|5|5|5|5|5|5
5|5,5|5
5,5
3,2|2|2
1,1
0,0
5,0
0,0
0|0|0,0|0|0,0|0|0
0,0
~~~~

I wrote a Perl script to stratify the variants.

~~~~{.bash}
./stratify.pl 
Usage: ./stratify.pl <clinvar.vcf> <significance code>

# pathogenic
./stratify.pl clinvar_20170104.vcf 5  | grep -v "^#" | wc -l
69940

# benign
./stratify.pl clinvar_20170104.vcf 2  | grep -v "^#" | wc -l
44919

# likely pathogenic
./stratify.pl clinvar_20170104.vcf 4  | grep -v "^#" | wc -l
15827

# likely benign
./stratify.pl clinvar_20170104.vcf 3  | grep -v "^#" | wc -l
73175
~~~~

Re-run dbNSFP

~~~~{.bash}
./stratify.pl clinvar_20170104.vcf 2 > clinvar_20170104_class_2.vcf
./stratify.pl clinvar_20170104.vcf 5 > clinvar_20170104_class_5.vcf

java search_dbNSFP33a -i ~/github/machine_learning/variant/random_forest/clinvar_20170104_class_2.vcf -o ~/github/machine_learning/variant/random_forest/clinvar_20170104_class_2.out -v hg19
6586 SNP(s) are found. Written to ~/github/machine_learning/variant/random_forest/clinvar_20170104_class_2.out
22784 SNP(s) are not found. Written to ~/github/machine_learning/variant/random_forest/clinvar_20170104_class_2.out.err

java search_dbNSFP33a -i ~/github/machine_learning/variant/random_forest/clinvar_20170104_class_5.vcf -o ~/github/machine_learning/variant/random_forest/clinvar_20170104_class_5.out -v hg19
23132 SNP(s) are found. Written to ~/github/machine_learning/variant/random_forest/clinvar_20170104_class_5.out
17149 SNP(s) are not found. Written to ~/github/machine_learning/variant/random_forest/clinvar_20170104_class_5.out.err
~~~~

As expected, more pathogenic variants are non-synonymous. (Though the numbers returned by dbNSFP do not correspond to the total number of SNVs in the VCF files.)

## Expression specificity for ClinVar variants

dbNSFP also contains expression data. What's the tissue specificity of the CF variants?

~~~~{.bash}
# clinvar_golden_stars is stored in column 184
# Tissue_specificity is stored in column 212
# remember that only CF variants have four golden stars
# column 183 is clinvar_trait
cat clinvar_20170104.out | awk -F'\t' '$184==4 {print $183,$212}'
cat clinvar_20170104.out | awk -F'\t' '$184==4 {print $183,$212}'
Cystic fibrosis TISSUE SPECIFICITY: Expressed in the respiratory airway, including bronchial epithelium, and in the female reproductive tract, including oviduct (at protein level). {ECO:0000269|PubMed:22207244}.; 
Cystic fibrosis TISSUE SPECIFICITY: Expressed in the respiratory airway, including bronchial epithelium, and in the female reproductive tract, including oviduct (at protein level). {ECO:0000269|PubMed:22207244}.; 
Cystic fibrosis TISSUE SPECIFICITY: Expressed in the respiratory airway, including bronchial epithelium, and in the female reproductive tract, including oviduct (at protein level). {ECO:0000269|PubMed:22207244}.; 
Cystic fibrosis TISSUE SPECIFICITY: Expressed in the respiratory airway, including bronchial epithelium, and in the female reproductive tract, including oviduct (at protein level). {ECO:0000269|PubMed:22207244}.; 
Cystic fibrosis TISSUE SPECIFICITY: Expressed in the respiratory airway, including bronchial epithelium, and in the female reproductive tract, including oviduct (at protein level). {ECO:0000269|PubMed:22207244}.; 
Cystic fibrosis TISSUE SPECIFICITY: Expressed in the respiratory airway, including bronchial epithelium, and in the female reproductive tract, including oviduct (at protein level). {ECO:0000269|PubMed:22207244}.; 
~~~~

What about variants with three golden stars?

~~~~{.bash}
# ClinVar variants with expert panel assertion
cat clinvar_20170104.out | awk -F'\t' '$184==3 {print $183,$212}' | wc -l
546

trastuzumab response - Efficacy TISSUE SPECIFICITY: Found on monocytes, neutrophils and eosinophil platelets.; 
carbamazepine response - Dosage TISSUE SPECIFICITY: Found in liver. {ECO:0000269|PubMed:12878321}.; 
warfarin response - Dosage .
Breast-ovarian cancer, familial 2 TISSUE SPECIFICITY: Highest levels of expression in breast and thymus, with slightly lower levels in lung, ovary and spleen.; 
Breast-ovarian cancer, familial 2 TISSUE SPECIFICITY: Highest levels of expression in breast and thymus, with slightly lower levels in lung, ovary and spleen.; 
Breast-ovarian cancer, familial 2 TISSUE SPECIFICITY: Highest levels of expression in breast and thymus, with slightly lower levels in lung, ovary and spleen.; 
Breast-ovarian cancer, familial 2 TISSUE SPECIFICITY: Highest levels of expression in breast and thymus, with slightly lower levels in lung, ovary and spleen.; 
Breast-ovarian cancer, familial 2 TISSUE SPECIFICITY: Highest levels of expression in breast and thymus, with slightly lower levels in lung, ovary and spleen.; 
Breast-ovarian cancer, familial 2 TISSUE SPECIFICITY: Highest levels of expression in breast and thymus, with slightly lower levels in lung, ovary and spleen.; 
Breast-ovarian cancer, familial 2 TISSUE SPECIFICITY: Highest levels of expression in breast and thymus, with slightly lower levels in lung, ovary and spleen.; 
~~~~

# Grimm et al.

The study by [Grimm et al. 2015](https://www.ncbi.nlm.nih.gov/pubmed/25684150) provides several benchmark datasets. I will use the SwissVarSelected dataset that are on assembled chromosomes.

~~~~{.bash}
cat ../DataS1/ToolScores/swissvar_selected_tool_scores.csv | cut -f3 -d',' | sort -u
CHR
chr1
chr10
chr11
chr12
chr13
chr14
chr15
chr16
chr17
chr18
chr19
chr2
chr20
chr21
chr22
chr3
chr4
chr5
chr6
chr7
chr8
chr9
chrGL000209.1
chrHG1287_PATCH
chrHG1308_PATCH
chrHG1433_PATCH
chrHG185_PATCH
chrHG299_PATCH
chrHG305_PATCH
chrHG339_PATCH
chrHG344_PATCH
chrHG79_PATCH
chrHG7_PATCH
chrHSCHR19LRC_LRC_I_CTG1
chrHSCHR6_MHC_COX
chrHSCHR6_MHC_DBB
chrHSCHR6_MHC_MANN
chrHSCHR6_MHC_MCF
chrHSCHR6_MHC_QBL
chrHSCHR6_MHC_SSTO
chrMT
chrX
chrY

cat ../DataS1/ToolScores/swissvar_selected_tool_scores.csv |
grep -v "^True" |
grep -v "chr[GHM]" |
perl -anl -F/,/ -e '$F[2] =~ s/^chr//;
next unless $F[0] == 1;
print join("\t", "$F[2]", $F[3]-1, $F[3], $F[4], $F[5])' |
sort -k1,1V -k2,2n > positive.tsv

# how many pathogenic?
cat positive.tsv | wc -l
4457

cat ../DataS1/ToolScores/swissvar_selected_tool_scores.csv |
grep -v "^True" |
grep -v "chr[GHM]" |
perl -anl -F/,/ -e '$F[2] =~ s/^chr//;
next unless $F[0] == -1;
print join("\t", "$F[2]", $F[3]-1, $F[3], $F[4], $F[5])' |
sort -k1,1V -k2,2n > negative.tsv

# how many benign?
cat negative.tsv | wc -l
7736
~~~~

I have a simply script in my [learning_vcf_file GitHub repository](https://github.com/davetang/learning_vcf_file) that can create a VCF file from TSV files containing the chromosome, start and end coordinates, reference and alternative bases. The script requires a FASTA copy of the reference genome to make sure that the provided reference base is correct.

~~~~{.bash}
~/github/learning_vcf_file/script/create_vcf.pl ~/genome/hg19/hg19_no_chr.fa positive.tsv > positive.vcf
~/github/learning_vcf_file/script/create_vcf.pl ~/genome/hg19/hg19_no_chr.fa negative.tsv > negative.vcf
~~~~

Now we can annotate the SwissVarSelected variants using dbNSFP.

~~~~{.bash}
java search_dbNSFP33a -i ~/github/machine_learning/variant/random_forest/positive.vcf -o ~/github/machine_learning/variant/random_forest/positive.out -v hg19
4387 SNP(s) are found. Written to ~/github/machine_learning/variant/random_forest/positive.out
6 SNP(s) are not found. Written to ~/github/machine_learning/variant/random_forest/positive.out.err

java search_dbNSFP33a -i ~/github/machine_learning/variant/random_forest/negative.vcf -o ~/github/machine_learning/variant/random_forest/negative.out -v hg19
7563 SNP(s) are found. Written to ~/github/machine_learning/variant/random_forest/negative.out
143 SNP(s) are not found. Written to ~/github/machine_learning/variant/random_forest/negative.out.err
~~~~

# Random Forest

Now that we have two sets of training data we can build our Random Forest classifier.

~~~~{.bash}
# ClinVar variants 2 for benign and 5 for pathogenic
cat clinvar_20170104_class_2.out | grep -v "^#" | wc -l
6633
cat clinvar_20170104_class_5.out | grep -v "^#" | wc -l
23410

# SwissVarSelect variants
cat positive.out | grep -v "^#" | wc -l
4432
cat negative.out | grep -v "^#" | wc -l
~~~~

Conveniently, dbNSFP has created a normalised rank score for 27 tools.

~~~~{.bash}
cat clinvar_20170104_class_2.out | head -1 | transpose | grep -i rankscore
SIFT_converted_rankscore
Polyphen2_HDIV_rankscore
Polyphen2_HVAR_rankscore
LRT_converted_rankscore
MutationTaster_converted_rankscore
MutationAssessor_score_rankscore
FATHMM_converted_rankscore
PROVEAN_converted_rankscore
VEST3_rankscore
MetaSVM_rankscore
MetaLR_rankscore
M-CAP_rankscore
CADD_raw_rankscore
DANN_rankscore
fathmm-MKL_coding_rankscore
Eigen-PC-raw_rankscore
GenoCanyon_score_rankscore
integrated_fitCons_score_rankscore
GM12878_fitCons_score_rankscore
H1-hESC_fitCons_score_rankscore
HUVEC_fitCons_score_rankscore
GERP++_RS_rankscore
phyloP100way_vertebrate_rankscore
phyloP20way_mammalian_rankscore
phastCons100way_vertebrate_rankscore
phastCons20way_mammalian_rankscore
SiPhy_29way_logOdds_rankscore

cat clinvar_20170104_class_2.out | head -1 | transpose | grep -i rankscore | wc -l
27
~~~~

We will use the rankscores as the features to train a Random Forest classifier in R.

~~~~{.r}
setwd("/Users/dtang/github/machine_learning/variant/random_forest")

benign <- read.table('clinvar_20170104_class_2.out', header=TRUE, stringsAsFactors=FALSE, quote='', sep="\t", comment='')
pathogenic <- read.table('clinvar_20170104_class_5.out', header=TRUE, stringsAsFactors=FALSE, quote='', sep="\t", comment='')

dim(benign)
[1] 6633  456
dim(pathogenic)
[1] 23410   456

negative <- benign[, grep('rankscore', names(benign))]
negative$class <- rep(-1, nrow(negative))
positive <- pathogenic[, grep('rankscore', names(pathogenic))]
positive$class <- rep(1, nrow(positive))

df <- rbind(positive, negative)
dim(df)
[1] 30043    28

df <- apply(df, 2, function(x) as.numeric(gsub(x = x, pattern = '^\\.$', replacement = NA, perl = TRUE)))
df <- as.data.frame(df)
df$class <- factor(df$class)

library(randomForest)
rf <- randomForest(class ~ ., data=df, importance=TRUE, do.trace=100, na.action=na.omit, ntree=1000)
ntree      OOB      1      2
  100:   6.15% 58.85%  1.62%
  200:   6.30% 60.06%  1.69%
  300:   6.28% 59.35%  1.72%
  400:   6.34% 60.06%  1.73%
  500:   6.30% 60.16%  1.68%
  600:   6.27% 60.16%  1.64%
  700:   6.30% 60.26%  1.66%
  800:   6.24% 60.16%  1.61%
  900:   6.24% 59.76%  1.64%
 1000:   6.29% 60.06%  1.67%

rf

Call:
 randomForest(formula = class ~ ., data = df, importance = TRUE,      do.trace = 100, ntree = 1000, na.action = na.omit) 
               Type of random forest: classification
                     Number of trees: 1000
No. of variables tried at each split: 5

        OOB estimate of  error rate: 6.29%
Confusion matrix:
    -1     1 class.error
-1 395   594  0.60060667
1  192 11320  0.01667825
~~~~

A large number of the ClinVar variants have missing data, especially the benign variants. Perform the same analysis in the SwissVarSelected variants.

~~~~{.r}
setwd("/Users/dtang/github/machine_learning/variant/random_forest")

benign <- read.table('negative.out', header=TRUE, stringsAsFactors=FALSE, quote='', sep="\t", comment='')
pathogenic <- read.table('positive.out', header=TRUE, stringsAsFactors=FALSE, quote='', sep="\t", comment='')

dim(benign)
[1] 7636  456
dim(pathogenic)
[1] 4432  456

negative <- benign[, grep('rankscore', names(benign))]
negative$class <- rep(-1, nrow(negative))
positive <- pathogenic[, grep('rankscore', names(pathogenic))]
positive$class <- rep(1, nrow(positive))

df <- rbind(positive, negative)
dim(df)
[1] 12068    28

df <- apply(df, 2, function(x) as.numeric(gsub(x = x, pattern = '^\\.$', replacement = NA, perl = TRUE)))
df <- as.data.frame(df)
df$class <- factor(df$class)

library(randomForest)
rf <- randomForest(class ~ ., data=df, importance=TRUE, do.trace=100, na.action=na.omit, ntree=1000)
ntree      OOB      1      2
  100:  29.50% 22.36% 37.61%
  200:  28.96% 21.79% 37.10%
  300:  28.73% 21.56% 36.89%
  400:  28.68% 21.25% 37.13%
  500:  28.58% 21.20% 36.97%
  600:  28.40% 21.11% 36.70%
  700:  28.51% 21.13% 36.89%
  800:  28.19% 20.83% 36.56%
  900:  28.32% 20.87% 36.78%
 1000:  28.35% 20.90% 36.83%

rf

Call:
 randomForest(formula = class ~ ., data = df, importance = TRUE,      do.trace = 100, ntree = 1000, na.action = na.omit) 
               Type of random forest: classification
                     Number of trees: 1000
No. of variables tried at each split: 5

        OOB estimate of  error rate: 28.35%
Confusion matrix:
     -1    1 class.error
-1 3350  885   0.2089728
1  1372 2353   0.3683221
~~~~

