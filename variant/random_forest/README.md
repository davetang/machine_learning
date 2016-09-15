Random Forest classifier
========================

See my [Random Forest repository](https://github.com/davetang/learning_random_forest) for introductory information. See [analysis.R](https://github.com/davetang/machine_learning/blob/master/variant/random_forest/analysis.R) for the analysis.

# False positives

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

# False negatives

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

* [rs1052030 is listed as benign](http://www.ncbi.nlm.nih.gov/clinvar/variation/43258/)
* [rs73885319 is listed only as a risk factor](http://www.ncbi.nlm.nih.gov/clinvar/variation/6080/)
* [rs7014851 is listed as uncertain significance](http://www.ncbi.nlm.nih.gov/clinvar/variation/7330/)
* [rs2070074 has conflicting information](http://www.ncbi.nlm.nih.gov/clinvar/variation/3613/)
* [rs1800279 has conflicting information](http://www.ncbi.nlm.nih.gov/clinvar/variation/11269/)

It is not certain whether the above variants are really false negatives, as none of them are listed as only pathogenic in ClinVar.

# Positive and negative training set

Annotate with dbNSFP.

~~~~{.bash}
cat ../DataS1/ToolScores/*.csv |
grep -v "^True" |
grep -v "PATCH" |
grep -v "chrMT" |
perl -anl -F/,/ -e '$F[2] =~ s/^chr//;
next unless $F[0] == 1;
print join("\t", "chr$F[2]", $F[3]-1, $F[3], $F[4], $F[5])' > positive.tsv

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

cat positive.tsv | sort -k1,1V -k2,2n > blah
mv -f blah positive.tsv 
cat negative.tsv | sort -k1,1V -k2,2n > blah
mv -f blah negative.tsv 

~/github/learning_vcf_file/script/create_vcf.pl ~/genome/hg19/hg19.fa positive.tsv > positive.vcf
~/github/learning_vcf_file/script/create_vcf.pl ~/genome/hg19/hg19.fa negative.tsv > negative.vcf

java search_dbNSFP32a -i positive.vcf -o positive_dbnsfp.out -v hg19
# 36579 SNP(s) are found. Written to positive_dbnsfp.out
# 40 SNP(s) are not found. Written to positive_dbnsfp.out.err

java search_dbNSFP32a -i negative.vcf -o negative_dbnsft.out -v hg19
# 41833 SNP(s) are found. Written to negative_dbnsft.out
# 517 SNP(s) are not found. Written to negative_dbnsft.out.err
~~~~

