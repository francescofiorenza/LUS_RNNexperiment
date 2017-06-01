#!/bin/bash
trainFileName=/DataNLSPARQL/NLSPARQL.train.data
trainFeatFileName=/DataNLSPARQL/NLSPARQL.train.feats.txt
testFileName=/DataNLSPARQL/NLSPARQL.test.data
testFeatFileName=/DataNLSPARQL/NLSPARQL.test.feats.txt
outputFolder=../output
plotFolder=$outputFolder/PLOT
dataFolder=rnn_slu/data


cat $dataFolder/$trainFileName | cut -f 2 |
sed '/^ *$/d' |sort| uniq |
sed 's/^ *//g' |awk '{print (NR-1),$0}'|
awk '{OFS="\t";  print $2,$1}'
