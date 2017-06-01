#!/bin/bash

dataFolder=rnn_slu/data/DataNLSPARQL
dataAnalysis=dataAnalysis
mkdir -p $dataAnalysis
#Number and the occurence of Label (N Train Label)
NTrL=$(cat $dataFolder/NLSPARQL.trainShuf.data |cut -f 2|sed /^$/d|wc -l)
cat $dataFolder/NLSPARQL.trainShuf.data |cut -f 2|sed /^$/d|sort -n|uniq -c|sort -nr> $dataAnalysis/NLSPARQL.trainShuf.label.hist
NVL=$(cat $dataFolder/NLSPARQL.validShuf.data |cut -f 2|sed /^$/d|wc -l)
cat $dataFolder/NLSPARQL.validShuf.data |cut -f 2|sed /^$/d|sort -n|uniq -c|sort -nr> $dataAnalysis/NLSPARQL.validShuf.label.hist
NTeL=$(cat $dataFolder/NLSPARQL.test.data |cut -f 2|sed /^$/d|wc -l)
cat $dataFolder/NLSPARQL.test.data |cut -f 2|sed /^$/d|sort -n|uniq -c|sort -nr> $dataAnalysis/NLSPARQL.test.label.hist

echo -e "-log(prob)\t\t\t$NTrL\_LABELofTrain\t" > $dataAnalysis/NLSPARQL.trainShuf.label.histnorm
while read count token           
do
    echo -e $(echo "-l($count/$NTrL)" |bc -l)"\t\t"$token"\t\t" >>$dataAnalysis/NLSPARQL.trainShuf.label.histnorm
    #echo -e $(echo "(scale=2;$count/$NTrL)"|bc -l)"\t"$token 
done < $dataAnalysis/NLSPARQL.trainShuf.label.hist

echo -e "-log(prob)\t\t$NVL\_LABELofValid\t" > $dataAnalysis/NLSPARQL.validShuf.label.histnorm
while read count token           
do
    echo -e $(echo "-l($count/$NVL)"|bc -l)"\t\t"$token"\t\t" >> $dataAnalysis/NLSPARQL.validShuf.label.histnorm
done < $dataAnalysis/NLSPARQL.validShuf.label.hist

echo -e "-log(prob)\t\t$NTeL\_LABELofTest\t" > $dataAnalysis/NLSPARQL.test.label.histnorm
while read count token           
do
    echo -e $(echo "-l($count/$NTeL)"|bc -l)"\t\t"$token"\t\t" >> $dataAnalysis/NLSPARQL.test.label.histnorm
done < $dataAnalysis/NLSPARQL.test.label.hist
rm $dataAnalysis/NLSPARQL.trainShuf.label.hist
rm $dataAnalysis/NLSPARQL.validShuf.label.hist
rm $dataAnalysis/NLSPARQL.test.label.hist
paste $dataAnalysis/NLSPARQL.trainShuf.label.histnorm $dataAnalysis/NLSPARQL.validShuf.label.histnorm $dataAnalysis/NLSPARQL.test.label.histnorm > $dataAnalysis/TrainValidTest.histnorm

#Number and the occurence of Word (N Train Label)
NTrT=$(cat $dataFolder/NLSPARQL.trainShuf.data |cut -f 1|sed /^$/d|wc -l)
cat $dataFolder/NLSPARQL.trainShuf.data |cut -f 1|sed /^$/d|sort -n|uniq -c|sort -nr> $dataAnalysis/NLSPARQL.trainShuf.token.hist
NVT=$(cat $dataFolder/NLSPARQL.validShuf.data |cut -f 1|sed /^$/d|wc -l)
cat $dataFolder/NLSPARQL.validShuf.data |cut -f 1|sed /^$/d|sort -n|uniq -c|sort -nr> $dataAnalysis/NLSPARQL.validShuf.token.hist
NTeT=$(cat $dataFolder/NLSPARQL.test.data |cut -f 1|sed /^$/d|wc -l)
cat $dataFolder/NLSPARQL.test.data |cut -f 1|sed /^$/d|sort -n|uniq -c|sort -nr> $dataAnalysis/NLSPARQL.test.token.hist
echo -e "-log(prob)\t\t\t$NTrT\_WORDSofTrain\t" > $dataAnalysis/NLSPARQL.trainShuf.token.histnorm
while read count token           
do
    echo -e $(echo "-l($count/$NTrT)" |bc -l)"\t\t"$token"\t\t" >>$dataAnalysis/NLSPARQL.trainShuf.token.histnorm
    #echo -e $(echo "(scale=2;$count/$NTrL)"|bc -l)"\t"$token 
done < $dataAnalysis/NLSPARQL.trainShuf.token.hist
echo -e "-log(prob)\t\t$NVT\_WORDSofValid\t" > $dataAnalysis/NLSPARQL.validShuf.token.histnorm
while read count token           
do
    echo -e $(echo "-l($count/$NVT)"|bc -l)"\t\t"$token"\t\t" >> $dataAnalysis/NLSPARQL.validShuf.token.histnorm
done < $dataAnalysis/NLSPARQL.validShuf.token.hist
echo -e "-log(prob)\t\t$NTeT\_WORDSofTest\t" > $dataAnalysis/NLSPARQL.test.token.histnorm
while read count token           
do
    echo -e $(echo "-l($count/$NTeT)"|bc -l)"\t\t"$token"\t\t" >> $dataAnalysis/NLSPARQL.test.token.histnorm
done < $dataAnalysis/NLSPARQL.test.token.hist
rm $dataAnalysis/NLSPARQL.trainShuf.token.hist
rm $dataAnalysis/NLSPARQL.validShuf.token.hist
rm $dataAnalysis/NLSPARQL.test.token.hist
paste $dataAnalysis/NLSPARQL.trainShuf.token.histnorm $dataAnalysis/NLSPARQL.validShuf.token.histnorm $dataAnalysis/NLSPARQL.test.token.histnorm > $dataAnalysis/TrainValidTest.token.histnorm

#########################Analysis of the problem in term of unseen word in the training ########################
cat $dataFolder/NLSPARQL.train.data|sed /^$/d|cut -f 1|sort>$dataAnalysis/word_dict_train.txt
cat $dataFolder/NLSPARQL.test.data|sed /^$/d|cut -f 1|sort>$dataAnalysis/word_dict_test.txt
cat $dataFolder/NLSPARQL.trainShuf.data|sed /^$/d|cut -f 1|sort>$dataAnalysis/word_dict_sub_train.txt
cat $dataFolder/NLSPARQL.validShuf.data|sed /^$/d|cut -f 1|sort>$dataAnalysis/word_dict_valid.txt

NunkVToSubTr=$(comm -2 --check-order $dataAnalysis/word_dict_valid.txt $dataAnalysis/word_dict_sub_train.txt|cut -f 1|sed /^$/d|wc -l)
NunkTeToTr=$(comm -2 --check-order $dataAnalysis/word_dict_test.txt $dataAnalysis/word_dict_train.txt|cut -f 1|sed /^$/d|wc -l)
NunkTeToSubTr=$(comm -2 --check-order $dataAnalysis/word_dict_test.txt $dataAnalysis/word_dict_sub_train.txt|cut -f 1|sed /^$/d|wc -l)
#NuTrToTe=$(comm -2 --check-order $dataAnalysis/word_dict_train.txt $dataAnalysis/word_dict_test.txt|cut -f 1|sed /^$/d|wc -l)

cat $dataFolder/NLSPARQL.train.data|sed /^$/d|cut -f 1|sort|uniq>$dataAnalysis/word_dict_train.txt
cat $dataFolder/NLSPARQL.test.data|sed /^$/d|cut -f 1|sort|uniq>$dataAnalysis/word_dict_test.txt
cat $dataFolder/NLSPARQL.trainShuf.data|sed /^$/d|cut -f 1|sort|uniq>$dataAnalysis/word_dict_sub_train.txt
cat $dataFolder/NLSPARQL.validShuf.data|sed /^$/d|cut -f 1|sort|uniq>$dataAnalysis/word_dict_valid.txt

NunqVToSubTr=$(comm -2 --check-order $dataAnalysis/word_dict_valid.txt $dataAnalysis/word_dict_sub_train.txt|cut -f 1|sed /^$/d|wc -l)
NunqTeToTr=$(comm -2 --check-order $dataAnalysis/word_dict_test.txt $dataAnalysis/word_dict_train.txt|cut -f 1|sed /^$/d|wc -l)
NunqTeToSubTr=$(comm -2 --check-order $dataAnalysis/word_dict_test.txt $dataAnalysis/word_dict_sub_train.txt|cut -f 1|sed /^$/d|wc -l)


echo "\\begin{table}[H]">$dataAnalysis/Unk.tex
echo "\\begin{center}">>$dataAnalysis/Unk.tex
echo "\\begin{tabular}{|l|l|l|l|}">>$dataAnalysis/Unk.tex
echo "\\hline \$<\$unk\$>\$ & SubTrain& Valid& Test\\\\ \\hline">>$dataAnalysis/Unk.tex
echo "Unique words & 0 & "$NunqVToSubTr "&" $NunqTeToSubTr "\\\\ ">>$dataAnalysis/Unk.tex
echo "Occurrence & 0 & "$NunkVToSubTr "&" $NunkTeToSubTr "\\\\ \\hline">>$dataAnalysis/Unk.tex
echo "\\end{tabular}">>$dataAnalysis/Unk.tex
echo "\\end{center}">>$dataAnalysis/Unk.tex
echo "\\caption{\\label{UnkSubtrainValidTestCorpus} Number of word that appeared only in the test and in the validation set.}">>$dataAnalysis/Unk.tex
echo "\\end{table}">>$dataAnalysis/Unk.tex

