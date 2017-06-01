#!/bin/bash
#Prendiamo in input il nostro file di training con tutte le parole classificate nella loro classe sintattica
trainFileName=/DataNLSPARQL/NLSPARQL.train.data
validFileName=/DataNLSPARQL/NLSPARQL.valid.data
trainFeatFileName=/DataNLSPARQL/NLSPARQL.train.feats.txt
testFileName=/DataNLSPARQL/NLSPARQL.test.data
testFeatFileName=/DataNLSPARQL/NLSPARQL.test.feats.txt
outputFolder=../output
plotFolder=$outputFolder/PLOT
rnn_sluFolder=rnn_slu
dataFolder=$rnn_sluFolder/data
#file=$dataFolder/DataNLSPARQL/NLSPARQL.valid.trainSPL_shuf.data
file=$1

cat $file |sed "s/$/#/g"| tr ' ' '\n'| tr '@' '\t' |tr '#' '\n'

