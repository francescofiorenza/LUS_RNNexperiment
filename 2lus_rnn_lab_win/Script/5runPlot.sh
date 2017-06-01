#!/bin/bash
#set yr [GPVAL_DATA_Y_MIN:GPVAL_DATA_Y_MAX]
cd ..
mkdir -p outPlot
#for file in model_elman_0.1_7_10_100_100_10_100 model_jordan_0.1_7_10_100_100_10_100 model_elman_0.1_7_10_137_100_10_100 model_jordan_0.1_7_10_137_100_10_100 model_elman_0.1_9_10_100_100_10_100 model_jordan_0.1_9_10_100_100_10_100 model_elman_0.1_9_10_137_100_10_100
for file in $(ls |grep ^model|grep -v test)
do
root=$(pwd)
echo $file
cd $file
    templateFile=template.plt
    echo "set terminal pngcairo  font  \"arial,10\" fontscale 1.0 size 600, 400 " > $templateFile
    echo "set output \"../outPlot/F1onEpoch_$file.png\"" >> $templateFile
    echo "set title \"RNN accuracy FB1\n NLSPARQL classification\"  font \"sans, 13\" "  >> $templateFile
    echo "set xlabel \"Epoch n\"" >> $templateFile
    echo "set ylabel \"FB1 %\" " >> $templateFile
    echo "stats \"f1_t_lr_costOnEpoch.dat\" using 2 nooutput name 'file1'" >> $templateFile
    echo "stats \"f1_t_lr_costOnEpoch.dat\" using 1 every ::file1_index_max::file1_index_max nooutput name 'file1_x'" >> $templateFile 
    echo "set label center at first file1_x_max,first file1_max sprintf('o', file1_max) offset char 0" >> $templateFile 
    echo "set label center at first file1_x_max,first file1_max sprintf('%.2f', file1_max) offset char 0,1" >> $templateFile
    echo "plot [:] [:100]\"f1_t_lr_costOnEpoch.dat\" using 1:2 with lines title \"$file\"" >> $templateFile
    gnuplot $templateFile
    
    echo "set terminal pngcairo  font  \"arial,10\" fontscale 1.0 size 600, 400 " > $templateFile
    echo "set output \"../outPlot/OptimizationSpeed_$file.png\" ">>$templateFile
    echo "set title \"RNN cost function\n NLSPARQL classification\"  font \"sans, 13\" "  >> $templateFile
    echo "set xlabel \"Epoch n\"" >> $templateFile
    echo "set ylabel \"Cost function [log scale]\" " >> $templateFile
    echo "set logscale y" >> $templateFile
    echo "plot \"f1_t_lr_costOnEpoch.dat\" using 1:5 with lines title \"$file\"" >> $templateFile
    gnuplot $templateFile
    
    echo "set terminal pngcairo  font  \"arial,10\" fontscale 1.0 size 600, 400 " > $templateFile
    echo "set output \"../outPlot/Duration_$file.png\" ">>$templateFile
    echo "set title \"RNN duration\n NLSPARQL classification with the different parameters\"  font \"sans, 13\" "  >> $templateFile
    echo "set xlabel \"Epoch n\"" >> $templateFile
    echo "set ylabel \"Duration of each epoch [sec]\" " >> $templateFile
    echo "stats \"f1_t_lr_costOnEpoch.dat\" using 3 nooutput name 'file1'" >> $templateFile
    echo "set label center at first "$(echo "scale=0;("$(cat f1_t_lr_costOnEpoch.dat|awk '$1{print $1}'|tail -n 1)"*0.8/1.0)"|bc -l)",first 200 sprintf('Total time = %.0f [sec]', file1_sum) offset char 0" >> $templateFile
    echo "plot [:] [0:400]\"f1_t_lr_costOnEpoch.dat\" using 1:3 with lines title \"$file\"" >> $templateFile
    gnuplot $templateFile
    cd "$root"
done
###########################ELMAN###########################
templateFile=template.plt
echo "set terminal pngcairo  font  \"arial,10\" fontscale 1.0 size 1200, 800 " > $templateFile
echo "set output \"outPlot/F1onEpoch_all_Elman.png\"" >> $templateFile
echo "set title \"Elman RNN FB1\n NLSPARQL classification\"  font \"sans, 13\" "  >> $templateFile
echo "set xlabel \"Epoch n\"" >> $templateFile
echo "set ylabel \"F1 accuracy of different model [F1 %]\" " >> $templateFile
echo "set key samplen 2 spacing 1 font \",10\"" >> $templateFile
for file in $(ls |grep ^model|grep elman|grep -v test|sort -n -t _ -k 4) 
do 
echo "stats \"$file/f1_t_lr_costOnEpoch.dat\" using 2 nooutput name 'file1'" >> $templateFile
echo "stats \"$file/f1_t_lr_costOnEpoch.dat\" using 1 every ::file1_index_max::file1_index_max nooutput name 'file1_x'" >> $templateFile 
echo "set label center at first file1_x_max,first file1_max sprintf('X') offset char 0" >> $templateFile 
echo "set label center at first file1_x_max,first file1_max sprintf('%.2f', file1_max) offset char 0,1" >> $templateFile
done
echo -n "plot [:] [:80+$(ls |grep ^model|grep elman|grep -v test|sort -n -t _ -k 4|wc -l)*5] " >> $templateFile
#model_elman_0.1_7_10_100_100_10_100 model->1_elman->2_0.1lr->3_7cs->4_10bs->5_100hu->6_100de->7_10pv->8_100pt->9
for file in $(ls |grep ^model|grep elman|grep -v test|sort -n -t _ -k 4) 
do 
echo -n "\"$file/f1_t_lr_costOnEpoch.dat\" using 1:2 with lines title \"$file\", " >> $templateFile
done
gnuplot $templateFile
###########################JORDAN###########################
templateFile=template.plt
echo "set terminal pngcairo  font  \"arial,10\" fontscale 1.0 size 1200, 800 " > $templateFile
echo "set output \"outPlot/F1onEpoch_all_Jordan.png\"" >> $templateFile
echo "set title \"Jordan RNN FB1\n NLSPARQL classification\"  font \"sans, 13\" "  >> $templateFile
echo "set xlabel \"Epoch n\"" >> $templateFile
echo "set ylabel \"F1 accuracy of different model [F1 %]\" " >> $templateFile
echo "set key samplen 2 spacing 1 font \",10\"" >> $templateFile
for file in $(ls |grep ^model|grep jordan|grep -v test|sort -n -t _ -k 4) 
do 
echo "stats \"$file/f1_t_lr_costOnEpoch.dat\" using 2 nooutput name 'file1'" >> $templateFile
echo "stats \"$file/f1_t_lr_costOnEpoch.dat\" using 1 every ::file1_index_max::file1_index_max nooutput name 'file1_x'" >> $templateFile 
echo "set label center at first file1_x_max,first file1_max sprintf('X') offset char 0" >> $templateFile 
echo "set label center at first file1_x_max,first file1_max sprintf('%.2f', file1_max) offset char 0,1" >> $templateFile
done
echo -n "plot [:] [:80+$(ls |grep ^model|grep jordan|grep -v test|sort -n -t _ -k 4|wc -l)*5] " >> $templateFile
#model_elman_0.1_7_10_100_100_10_100 model->1_elman->2_0.1lr->3_7cs->4_10bs->5_100hu->6_100de->7_10pv->8_100pt->9
for file in $(ls |grep ^model|grep jordan|grep -v test|sort -n -t _ -k 4) 
do 
echo -n "\"$file/f1_t_lr_costOnEpoch.dat\" using 1:2 with lines title \"$file\", " >> $templateFile
done
gnuplot $templateFile
########################### COST ALL ###########################
templateFile=template.plt
echo "set terminal pngcairo  font  \"arial,10\" fontscale 1.0 size 600, 400 " > $templateFile
echo "set output \"outPlot/OptimizationSpeed_all.png\"" >> $templateFile
echo "set title \"RNN cost of all the trained model \n NLSPARQL classification\"  font \"sans, 13\" "  >> $templateFile
echo "set xlabel \"Epoch n\"" >> $templateFile
echo "set ylabel \"F1 accuracy of different model [F1 %]\" " >> $templateFile
echo "set key samplen 2 spacing 1 font \",10\"" >> $templateFile
echo "set logscale y" >> $templateFile
echo -n "plot [:][:] " >> $templateFile
#model_elman_0.1_7_10_100_100_10_100 model->1_elman->2_0.1lr->3_7cs->4_10bs->5_100hu->6_100de->7_10pv->8_100pt->9
for file in $(ls |grep ^model|grep -v test|sort -n -t _ -k 2) 
do 
echo -n "\"$file/f1_t_lr_costOnEpoch.dat\" using 1:5 with lines title \"$file\", " >> $templateFile
done
gnuplot $templateFile
########################### F1 vs COST ELMAN ###########################
templateFile=template.plt
echo "set terminal pngcairo  font  \"arial,10\" fontscale 1.0 size 1200, 800 " > $templateFile
echo "set output \"outPlot/F1vsCOSTonEpoch_all_Elman.png\"" >> $templateFile
echo "set title \"E-RNN cost vs F1  \n NLSPARQL classification\"  font \"sans, 13\" "  >> $templateFile
echo "set xlabel \"Epoch n\"" >> $templateFile
echo "set ylabel \"F1 accuracy of different model [F1 %]\" " >> $templateFile
echo "set y2label \"Cost function of different Elman models\" " >> $templateFile
echo "set logscale y2" >> $templateFile
echo "set y2tics" >> $templateFile
echo "set key samplen 2 spacing 1 font \",10\"" >> $templateFile
counter_color=1
for file in $(ls |grep ^model|grep elman|grep '137_100'|grep -v test|sort -n -t _ -k 4) 
do 
echo "stats \"$file/f1_t_lr_costOnEpoch.dat\" using 2 nooutput name 'file1'" >> $templateFile
echo "stats \"$file/f1_t_lr_costOnEpoch.dat\" using 1 every ::file1_index_max::file1_index_max nooutput name 'file1_x'" >> $templateFile 
echo "set label center at first file1_x_max,first file1_max sprintf('o') offset char 0 front " >> $templateFile 
echo "set label center at first file1_x_max,first file1_max sprintf('%.2f', file1_max) offset char 0,1 front  font \"sans,17\" tc lt $counter_color" >> $templateFile
counter_color=$(echo "scale=0;"$counter_color"+"1|bc -l)
done
echo -n "plot [:] [:120] " >> $templateFile
#model_elman_0.1_7_10_100_100_10_100 model->1_elman->2_0.1lr->3_7cs->4_10bs->5_100hu->6_100de->7_10pv->8_100pt->9
counter_color=1
for file in $(ls |grep ^model|grep elman|grep '137_100'|grep -v test|sort -n -t _ -k 4) 
do 
echo -n "\"$file/f1_t_lr_costOnEpoch.dat\" using 1:2 with linespoints lt $counter_color lw 3 linecolor $counter_color title \"$file\", " >> $templateFile
counter_color=$(echo "scale=0;"$counter_color"+"1|bc -l)
done
counter_color=1
for file in $(ls |grep ^model|grep elman|grep '137_100'|grep -v test|sort -n -t _ -k 4) 
do 
echo -n "\"$file/f1_t_lr_costOnEpoch.dat\" using 1:5 axes x1y2 with linespoints lt $counter_color lw 1 linecolor $counter_color notitle \"$file\", " >> $templateFile
counter_color=$(echo "scale=0;"$counter_color"+"1|bc -l)
done
gnuplot $templateFile
########################### F1 vs COST JORDAN ###########################
templateFile=template.plt
echo "set terminal pngcairo  font  \"arial,10\" fontscale 1.0 size 1200, 800 " > $templateFile
echo "set output \"outPlot/F1vsCOSTonEpoch_all_Jordan.png\"" >> $templateFile
echo "set title \"J-RNN cost vs F1 \n NLSPARQL classification\"  font \"sans, 13\" "  >> $templateFile
echo "set xlabel \"Epoch n\"" >> $templateFile
echo "set ylabel \"F1 accuracy of different model [F1 %]\" " >> $templateFile
echo "set y2label \"Cost function of different Jordan models\" " >> $templateFile
echo "set logscale y2" >> $templateFile
echo "set y2tics" >> $templateFile
echo "set key samplen 2 spacing 1 font \",10\"" >> $templateFile
for file in $(ls |grep ^model|grep jordan|grep '137_100'|grep -v test|sort -n -t _ -k 4) 
do 
echo "stats \"$file/f1_t_lr_costOnEpoch.dat\" using 2 nooutput name 'file1'" >> $templateFile
echo "stats \"$file/f1_t_lr_costOnEpoch.dat\" using 1 every ::file1_index_max::file1_index_max nooutput name 'file1_x'" >> $templateFile 
echo "set label center at first file1_x_max,first file1_max sprintf('o', file1_max) offset char 0 front " >> $templateFile 
echo "set label center at first file1_x_max,first file1_max sprintf('%.2f', file1_max) offset char 0,1 front font \"sans,17\" tc lt $counter_color" >> $templateFile
done
echo -n "plot [:] [:120] " >> $templateFile
#model_elman_0.1_7_10_100_100_10_100 model->1_elman->2_0.1lr->3_7cs->4_10bs->5_100hu->6_100de->7_10pv->8_100pt->9
counter_color=1
for file in $(ls |grep ^model|grep jordan|grep '137_100'|grep -v test|sort -n -t _ -k 4) 
do 
echo -n "\"$file/f1_t_lr_costOnEpoch.dat\" using 1:2 with linespoints lt $counter_color lw 3 linecolor $counter_color title \"$file\", " >> $templateFile
counter_color=$(echo "scale=0;"$counter_color"+"1|bc -l)
done
counter_color=1
for file in $(ls |grep ^model|grep jordan|grep '137_100'|grep -v test|sort -n -t _ -k 4) 
do 
echo -n "\"$file/f1_t_lr_costOnEpoch.dat\" using 1:5 axes x1y2 with linespoints lt $counter_color lw 1 linecolor $counter_color notitle \"$file\", " >> $templateFile
counter_color=$(echo "scale=0;"$counter_color"+"1|bc -l)
done
gnuplot $templateFile

########################### F1 vs COST JORDAN best 100 60 ###########################
templateFile=template.plt
echo "set terminal pngcairo  font  \"arial,10\" fontscale 1.0 size 1200, 800 " > $templateFile
echo "set output \"outPlot/F1vsCOSTonEpoch_Jordan_100_60.png\"" >> $templateFile
echo "set title \"J-RNN cost vs F1 NLSPARQL classification\"  font \"sans, 26\" "  >> $templateFile
echo "set xlabel \"Epoch n\" font \"sans, 18\"" >> $templateFile
echo "set ylabel \"F1 accuracy of different model [F1 %]\" font \"sans, 18\" " >> $templateFile
echo "set y2label \"Cost function of different Jordan models\" font \"sans, 18\" " >> $templateFile
echo "set xtics font \"sans, 13\"" >> $templateFile
echo "set ytics font \"sans, 13\"" >> $templateFile
echo "set logscale y2"  >> $templateFile
echo "set y2tics font \"sans, 13\"" >> $templateFile
echo "set key samplen 2 spacing 1.5 font \",16\"" >> $templateFile
counter_color=1
for file in $(ls |grep ^model|grep jordan|grep '100_60'|grep -v test|sort -n -t _ -k 4) 
do 
echo "stats \"$file/f1_t_lr_costOnEpoch.dat\" using 2 nooutput name 'file1'" >> $templateFile
echo "stats \"$file/f1_t_lr_costOnEpoch.dat\" using 1 every ::file1_index_max::file1_index_max nooutput name 'file1_x'" >> $templateFile 
echo "set label center at first file1_x_max,first file1_max sprintf('o', file1_max) offset char 0 front " >> $templateFile 
echo "set label center at first file1_x_max,first file1_max sprintf('%.2f', file1_max) offset char 0,2 front font \"sans,9\" tc lt $counter_color" >> $templateFile
counter_color=$(echo "scale=0;"$counter_color"+"1|bc -l)
done
echo -n "plot [:] [70:90] " >> $templateFile
#model_elman_0.1_7_10_100_100_10_100 model->1_elman->2_0.1lr->3_7cs->4_10bs->5_100hu->6_100de->7_10pv->8_100pt->9
counter_color=1
for file in $(ls |grep ^model|grep jordan|grep '100_60'|grep -v test|sort -n -t _ -k 4) 
do 
echo -n "\"$file/f1_t_lr_costOnEpoch.dat\" using 1:2 with linespoints lt $counter_color lw 3 linecolor $counter_color title \"$(echo $file |sed s/model_jordan/J-RNN/g|sed 's/\_0.1_/\\_/g'|sed 's/\_10\_100\_60\_10\_100//g')\", " >> $templateFile
counter_color=$(echo "scale=0;"$counter_color"+"1|bc -l)
done
counter_color=1
for file in $(ls |grep ^model|grep jordan|grep '100_60'|grep -v test|sort -n -t _ -k 4) 
do 
echo -n "\"$file/f1_t_lr_costOnEpoch.dat\" using 1:5 axes x1y2 with linespoints lt $counter_color lw 1 linecolor $counter_color notitle \"$file\", " >> $templateFile
counter_color=$(echo "scale=0;"$counter_color"+"1|bc -l)
done
gnuplot $templateFile


########################### F1 vs COST ELMAN best 100 60 ###########################
templateFile=template.plt
echo "set terminal pngcairo  font  \"arial,10\" fontscale 1.0 size 1200, 800 " > $templateFile
echo "set output \"../../Report2/report_template/latex/IMAGE/F1vsCOSTonEpoch_Elman_100_60.png\"" >> $templateFile
echo "set title \"E-RNN cost vs F1 NLSPARQL classification\"  font \"sans, 26\" "  >> $templateFile
echo "set xlabel \"Epoch n\" font \"sans, 18\"" >> $templateFile
echo "set ylabel \"F1 accuracy of different model [F1 %]\" font \"sans, 18\" " >> $templateFile
echo "set y2label \"Cost function of different Elman models\" font \"sans, 18\" " >> $templateFile
echo "set xtics font \"sans, 13\"" >> $templateFile
echo "set ytics font \"sans, 13\"" >> $templateFile
echo "set logscale y2"  >> $templateFile
echo "set y2tics font \"sans, 13\"" >> $templateFile
echo "set key samplen 2 spacing 1.5 font \",16\"" >> $templateFile
counter_color=1
for file in $(ls |grep ^model|grep elman|grep '100_60'|grep -v test|sort -n -t _ -k 4) 
do 
echo "stats \"$file/f1_t_lr_costOnEpoch.dat\" using 2 nooutput name 'file1'" >> $templateFile
echo "stats \"$file/f1_t_lr_costOnEpoch.dat\" using 1 every ::file1_index_max::file1_index_max nooutput name 'file1_x'" >> $templateFile 
echo "set label center at first file1_x_max,first file1_max sprintf('o', file1_max) offset char 0 front " >> $templateFile 
echo "set label center at first file1_x_max,first file1_max sprintf('%.2f', file1_max) offset char 0,2 front font \"sans,9\" tc lt $counter_color" >> $templateFile
counter_color=$(echo "scale=0;"$counter_color"+"1|bc -l)
done
echo -n "plot [:] [:100] " >> $templateFile
#model_elman_0.1_7_10_100_100_10_100 model->1_elman->2_0.1lr->3_7cs->4_10bs->5_100hu->6_100de->7_10pv->8_100pt->9
counter_color=1
for file in $(ls |grep ^model|grep elman|grep '100_60'|grep -v test|sort -n -t _ -k 4) 
do 
echo -n "\"$file/f1_t_lr_costOnEpoch.dat\" using 1:2 with linespoints lt $counter_color lw 3 linecolor $counter_color title \"$(echo $file |sed s/model_elman/E-RNN/g|sed 's/\_0.1_/\\_/g'|sed 's/\_10\_100\_60\_10\_100//g')\", " >> $templateFile
counter_color=$(echo "scale=0;"$counter_color"+"1|bc -l)
done
counter_color=1
for file in $(ls |grep ^model|grep elman|grep '100_60'|grep -v test|sort -n -t _ -k 4) 
do 
echo -n "\"$file/f1_t_lr_costOnEpoch.dat\" using 1:5 axes x1y2 with linespoints lt $counter_color lw 1 linecolor $counter_color notitle \"$file\", " >> $templateFile
counter_color=$(echo "scale=0;"$counter_color"+"1|bc -l)
done
gnuplot $templateFile

##############################Plot of the final result###############################
cd Script
#global results by bar graph
for file in $(ls |grep 'SimulTerm2017_05_27_15')
do
suf=$(echo $file|sed 's/SimulTerm//g'|sed 's/.txt//g')
echo $suf
cat $file |grep -B 4 -A 2 'Test '|grep F1|grep model|tr ' ' "\t"|cut -f 11 > trained_model_$suf.dat
cat $file |grep -B 4 -A 2 'Test '|grep F1|grep model|tr ' ' "\t"|cut -f 7 > train_F1accuracy_$suf.dat
cat $file |grep -B 4 -A 2 'Test '|grep F1|grep ^Test|tr ' ' "\t"|cut -f 7 > test_F1accuracy_$suf.dat
paste trained_model_$suf.dat train_F1accuracy_$suf.dat test_F1accuracy_$suf.dat |sort -n -t _ -k 2 > results_$suf.txt
rm trained_model_$suf.dat
rm train_F1accuracy_$suf.dat
rm test_F1accuracy_$suf.dat
done

##Elman & Jordan windows comparation hidden layer 137 word_emb 100
for file in $(ls |grep 'SimulTerm2017_05_27_15')
do
suf=$(echo $file|sed 's/SimulTerm//g'|sed 's/.txt//g')
cat results_$suf.txt|grep elman|grep '137_100'||sort -n -t _ -k 4 > results_Elman_$suf\_137_100.dat
cat results_$suf.txt|grep jordan|grep '137_100'|sort -n -t _ -k 4 > results_Jordan_$suf\_137_100.dat
done

##Elman & Jordan windows comparation hidden layer 137 word_emb 100
for file in $(ls |grep 'SimulTerm2017_05_27_15')
do
suf=$(echo $file|sed 's/SimulTerm//g'|sed 's/.txt//g')
echo "set terminal pngcairo  font  \"arial,10\" fontscale 1.0 size 600, 400 " > $templateFile
echo "set output \"outPlot/F1comparationJordan.png\"" >> $templateFile
done

##########################Global result on the Validation ################################
./runConlleval.sh
cd ..
echo "RNN_type accuracy F1"> globalEvaluationValidAC_F1.dat
paste header.dat accuracyValid.dat FB1Valid.dat |sort -n -k 1|sed s/model_jordan/J-RNN/g|sed s/model_elman/E-RNN/g|sed s/'\_10\_100\t'/'\t'/g|sed s/'\_0.1'//g|sort -n -k 3 >> globalEvaluationValidAC_F1.dat
echo "set terminal pngcairo  font \"arial,10\" fontscale 1.0 size 1200, 800 " > $templateFile
echo "set output \"outPlot/allValidMachineResultOrderedByF1.png\"" >> $templateFile
echo "set title \"Global result on validation set of all the trained machine\"  font \"sans, 26\" ">> $templateFile
echo "set xlabel \"Jordan or Elman_context window_mini batch size_number of hidden layers_word embedding dimention\" offset 0,-5 font \"sans, 13\"">> $templateFile
echo "set ylabel \"Accuracy and F1\" font \"sans, 13\"">> $templateFile
echo "set yrange [:] noreverse nowriteback">> $templateFile
echo "set auto x">> $templateFile
echo "set grid">> $templateFile
echo "set style data histogram">> $templateFile
echo "set style histogram cluster gap 1">> $templateFile
echo "set style fill solid border -1">> $templateFile
echo "set boxwidth 0.9">> $templateFile
echo "set xtic rotate by -60 font \"sans, 13\"">> $templateFile
#echo "set tmargin 15">> $templateFile
#echo "set lmargin 5">> $templateFile
echo "set rmargin 15">> $templateFile
echo "set bmargin 15">> $templateFile
echo "plot \"globalEvaluationValidAC_F1.dat\" using 2:xtic(1) ti col, '' u 3 ti col">> $templateFile
gnuplot $templateFile

##########################Global result on the test ################################
./runConlleval.sh
cd ..
echo "RNN_type accuracy F1"> globalEvaluationTestAC_F1.dat
paste header.dat accuracy.dat FB1.dat |sort -n -k 1|sed s/model_jordan/J-RNN/g|sed s/model_elman/E-RNN/g|sed s/'\_10\_100\t'/'\t'/g|sed s/'\_0.1'//g|sort -n -k 3 >> globalEvaluationTestAC_F1.dat
echo "set terminal pngcairo  font \"arial,10\" fontscale 1.0 size 1200, 800 " > $templateFile
echo "set output \"outPlot/allTestedMachineResultOrderedByF1.png\"" >> $templateFile
echo "set title \"Global result on test set of all the trained machine\"  font \"sans, 26\" ">> $templateFile
echo "set xlabel \"Jordan or Elman_context window_mini batch size_number of hidden layers_word embedding dimention\" offset 0,-5 font \"sans, 13\"">> $templateFile
echo "set ylabel \"Accuracy and F1\" font \"sans, 13\"">> $templateFile
echo "set yrange [:] noreverse nowriteback">> $templateFile
echo "set auto x">> $templateFile
echo "set grid">> $templateFile
echo "set style data histogram">> $templateFile
echo "set style histogram cluster gap 1">> $templateFile
echo "set style fill solid border -1">> $templateFile
echo "set boxwidth 0.9">> $templateFile
echo "set xtic rotate by -60 font \"sans, 13\"">> $templateFile
#echo "set tmargin 15">> $templateFile
#echo "set lmargin 5">> $templateFile
echo "set rmargin 15">> $templateFile
echo "set bmargin 15">> $templateFile
echo "plot \"globalEvaluationTestAC_F1.dat\" using 2:xtic(1) ti col, '' u 3 ti col">> $templateFile
gnuplot $templateFile
