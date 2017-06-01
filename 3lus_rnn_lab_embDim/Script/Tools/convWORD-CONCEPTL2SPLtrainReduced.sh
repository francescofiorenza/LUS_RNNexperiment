#!/bin/bash
#Prendiamo in input il nostro file di training con tutte le parole classificate nella loro classe sintattica
trainFileName=/DataNLSPARQL/NLSPARQL.trainShuf.data
validFileName=/DataNLSPARQL/NLSPARQL.validShuf.data
trainFeatFileName=/DataNLSPARQL/NLSPARQL.train.feats.txt
testFileName=/DataNLSPARQL/NLSPARQL.test.data
testFeatFileName=/DataNLSPARQL/NLSPARQL.test.feats.txt
outputFolder=../output
plotFolder=$outputFolder/PLOT
rnn_sluFolder=rnn_slu
dataFolder=$rnn_sluFolder/data
toolsFolder=Script/Tools
#orderMin=$(cat classification.conf|grep ^orderMin|awk '{print $2}'|tr -sc [0-9] ' ') 
#orderMax=$(cat classification.conf|grep ^orderMax|awk '{print $2}'|tr -sc [0-9] ' ') 
#methodType=($(cat classification.conf|grep ^smoothing|awk '{print $2}'))
#cutoffFreq=$(cat classification.conf|grep ^cutoffFreq|awk '{print $2}'|tr -sc [0-9] ' ') 

#Estraiamo solo la classe sintattica per poi andare a calcola la probabilità che una appaia prima di un`altra dato che prima ne è apparsa un`altra ancora
cat $dataFolder/$trainFileName | awk '{OFS="@"; print $1,$2}' |
#sostituiamo le righe vuote con un carattere speciale che poi sostituiremo con un accapo
sed 's/^@ *$/#/g' |
#sostituiamo gli acapo con uno spazio
tr '\n' ' ' |
#ripristiniamo la righa vuota con un acapo per identificare che la frase è finita
tr '#' '\n' |
#eliminiamo tutte le possibili riche vuote causate da possibili doppi asterischi
sed 's/^ *//g;s/ *$//g'>$dataFolder/DataNLSPARQL/SPL_shuf_NLSPARQL.train.data
NS=$(cat $dataFolder/DataNLSPARQL/SPL_shuf_NLSPARQL.train.data|sed /^$/d|wc -l)
head -n $(echo "scale=0;$NS  * 40 /100" | bc -l) $dataFolder/DataNLSPARQL/SPL_shuf_NLSPARQL.train.data > $dataFolder/DataNLSPARQL/SPL_shuf_NLSPARQL.train.Reduced40of90.data
$toolsFolder/convSPL2WORD-CONCEPTLtrain.sh $dataFolder/DataNLSPARQL/SPL_shuf_NLSPARQL.train.Reduced40of90.data > $dataFolder/DataNLSPARQL/NLSPARQL.trainShuf.Reduced40of90.data
