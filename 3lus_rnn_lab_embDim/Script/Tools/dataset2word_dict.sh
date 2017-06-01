#!/bin/bash
trainFileName=/DataNLSPARQL/NLSPARQL.train.data
trainFeatFileName=/DataNLSPARQL/NLSPARQL.train.feats.txt
testFileName=/DataNLSPARQL/NLSPARQL.test.data
testFeatFileName=/DataNLSPARQL/NLSPARQL.test.feats.txt
outputFolder=../output
plotFolder=$outputFolder/PLOT
dataFolder=rnn_slu/data

cat $dataFolder/$trainFileName | cut -f 1 |
sed '/^ *$/d' |sort| uniq |
sed 's/^ *//g' |nl --number-format=ln|sed '1 i 0\t<UNK>'|
awk '{OFS="\t";  print $2,$1}'