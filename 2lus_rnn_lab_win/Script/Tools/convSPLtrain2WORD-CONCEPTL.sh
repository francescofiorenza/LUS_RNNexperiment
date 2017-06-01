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
#orderMin=$(cat classification.conf|grep ^orderMin|awk '{print $2}'|tr -sc [0-9] ' ') 
#orderMax=$(cat classification.conf|grep ^orderMax|awk '{print $2}'|tr -sc [0-9] ' ') 
#methodType=($(cat classification.conf|grep ^smoothing|awk '{print $2}'))
#cutoffFreq=$(cat classification.conf|grep ^cutoffFreq|awk '{print $2}'|tr -sc [0-9] ' ') 
echo $file
#Estraiamo solo la classe sintattica per poi andare a calcola la probabilità che una appaia prima di un`altra dato che prima ne è apparsa un`altra ancora
cat $file |sed "s/$/#/g"| tr ' ' '\n'| tr ':' '\t' |tr '#' '\n'

