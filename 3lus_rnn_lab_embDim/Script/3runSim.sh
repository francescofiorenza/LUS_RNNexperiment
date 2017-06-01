#!/bin/bash
trainFileName=DataNLSPARQL/NLSPARQL.train.data
#trainShufFileName=DataNLSPARQL/NLSPARQL.trainShuf.data
trainShufFileName=DataNLSPARQL/NLSPARQL.trainShuf.Reduced40of90.data
validShufFileName=DataNLSPARQL/NLSPARQL.validShuf.data
trainFeatFileName=DataNLSPARQL/NLSPARQL.train.feats.txt
testFileName=DataNLSPARQL/NLSPARQL.test.data
testFeatFileName=DataNLSPARQL/NLSPARQL.test.feats.txt

word_dictionary=DataNLSPARQL/word_dict.txt
label_dictionary=DataNLSPARQL/label_dict.txt
outputFolder=output
plotFolder=$outputFolder/PLOT
rnn_sluFolder=rnn_slu
dataFolder=$rnn_sluFolder/data
toolsFolder=Script/Tools

cd ..
export PYTHONPATH=$(pwd):$PYTHONPATH
lr=0.1
win=7
bs=10
nhidden=100
seed=$RANDOM
emb_dimension=100
nepochs=50

#1 Generazione delle frasi da trining set
#mkdir -p $outputFolder
#mkdir -p $plotFolder
start1=`date +%s`
echo "############### START TRAIN and TEST SIMULATION Elman RNN & Jordan RNN on window size 11 hl 100 ed 50 60 70 80 90 100 ##################"
echo " "
echo "####Start simulation date `date`"
#Best result model_jordan_0.1_11_10_137_60_10_100 with emb dim 100 percent for valida 10%  
#cat SimulTerm2017_05_27_2.48.txt |grep -B 4 -A 2 'Test '
#cat SimulTerm2017_05_27_15.55.txt |grep -B 4 -A 2 'Test '
#cat SimulTerm2017_05_27_2.48.txt |grep -B 4 -A 2 'Test '
#Next test using same valid and train, use differnt win
for lr_temp in 0.1
do
    for bs_temp in 10
    do
        for emb_dimension_temp in 50 
        do
            for win_temp in 11
            do
                for nhidden_temp in 100
                do
                    #Dependently on how you split the original train
                    percent_for_val=10
                    echo "lr: $lr_temp" > $rnn_sluFolder/config.cfg
                    echo "win: $win_temp" >> $rnn_sluFolder/config.cfg
                    echo "bs: $bs_temp" >> $rnn_sluFolder/config.cfg
                    echo "nhidden: $nhidden_temp" >> $rnn_sluFolder/config.cfg
                    echo "seed: $RANDOM" >> $rnn_sluFolder/config.cfg
                    echo "emb_dimension: $emb_dimension_temp" >> $rnn_sluFolder/config.cfg
                    echo "nepochs: $nepochs" >> $rnn_sluFolder/config.cfg
                    
                    echo "Created the configuration file with the following paramenter: "
                    echo "lr: $lr_temp"
                    echo "win: $win_temp"
                    echo "bs: $bs_temp"
                    echo "nhidden: $nhidden_temp"
                    echo "seed: $RANDOM" 
                    echo "emb_dimension: $emb_dimension_temp" 
                    echo "nepochs: $nepochs" 
                    start=`date +%s`
                    echo "Training Elman RNN on $trainShufFileName:"
                    echo "--------------------"
                    model_elman=$(echo  "model_elman_"$lr_temp"_"$win_temp"_"$bs_temp"_"$nhidden_temp"_"$emb_dimension_temp"_"$percent_for_val)
                    echo $model_elman
                    #python rnn_slu/lus/rnn_elman_train.py <training_data> <validation_data> <word_dictionary> <label_dictionary> <config_file> <model_directory>
                    python rnn_slu/lus/rnn_elman_train.py $dataFolder/$trainShufFileName $dataFolder/$validShufFileName $dataFolder/$word_dictionary $dataFolder/$label_dictionary  rnn_slu/config.cfg $model_elman
                    #python rnn_slu/lus/rnn_elman_test.py <model_directory> <test_file> <word_dictionary> <label_dictionary> <config_file> <output_file>
                    echo "-- FINISH TRAINING PHASE Elman RNN IN  $((`date +%s`-start)) sec ---"
                    start2=`date +%s`
                    echo "Testing Elman RNN:"
                    echo "-------------------"
                    model_elman_out_file=$(echo $model_elman"_test_out.txt")
                    python rnn_slu/lus/rnn_elman_test.py $model_elman $dataFolder/$testFileName $dataFolder/$word_dictionary $dataFolder/$label_dictionary rnn_slu/config.cfg $model_elman_out_file
                    echo "-- FINISH TESTING PHASE Elman RNN IN  $((`date +%s`-start2)) sec ---"
                    cp $dataFolder/$trainShufFileName $model_elman
                    cp $dataFolder/$validShufFileName $model_elman
                    echo "######FINISH TRAIN and TEST SIMULATION Elman RNN IN $((`date +%s`-start1)) sec ######"
                    start1=`date +%s`
                    start=`date +%s`
                    echo "Training Jordan RNN:"
                    echo "--------------------"
                    model_jordan=$(echo  "model_jordan_"$lr_temp"_"$win_temp"_"$bs_temp"_"$nhidden_temp"_"$emb_dimension_temp"_"$percent_for_val)
                    echo $model_jordan
                    mkdir -p $model_jordan
                    #python rnn_slu/lus/rnn_jordan_train.py <training_data> <validation_data> <word_dictionary> <label_dictionary> <config_file> <model_directory>
                    python rnn_slu/lus/rnn_jordan_train.py $dataFolder/$trainShufFileName $dataFolder/$validShufFileName $dataFolder/$word_dictionary $dataFolder/$label_dictionary  rnn_slu/config.cfg $model_jordan
                    echo "-- FINISH TRAINING PHASE Jordan RNN IN  $((`date +%s`-start2)) sec ---"
                    start2=`date +%s`
                    echo "Testing Jordan RNN:"
                    echo "-------------------"
                    model_jordan_out_file=$(echo $model_jordan"_test_out.txt")
                    python rnn_slu/lus/rnn_jordan_test.py $model_jordan $dataFolder/$testFileName $dataFolder/$word_dictionary $dataFolder/$label_dictionary rnn_slu/config.cfg $model_jordan_out_file
                    echo "-- FINISH TESTING PHASE Jordan RNN IN  $((`date +%s`-start2)) sec ---"
                    cp $dataFolder/$trainShufFileName $model_jordan
                    cp $dataFolder/$validShufFileName $model_jordan
                    echo "######FINISH TRAIN and TEST SIMULATION Jordan RNN IN $((`date +%s`-start1)) sec ######"
                    start=`date +%s`
                done
            done
        done
    done
done
echo "######FINISH simulation date `date`"