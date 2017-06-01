#!/bin/bash
echo "" > header.dat
echo "" > accuracyValid.dat
echo "" > precisionValid.dat
echo "" > recallValid.dat
echo "" > FB1Valid.dat
echo "" > header.dat
echo "" > accuracy.dat
echo "" > precision.dat
echo "" > recall.dat
echo "" > FB1.dat
for file in $(ls |grep ^model|grep -v test|sort -n -t _ -k 4) 
do 
    cat $file/best.valid.txt|sed '/BOS/d'|sed '/EOS/d'|awk '$1 {print $1}' > $file/token_valid
    cat $file/best.valid.txt|sed '/BOS/d'|sed '/EOS/d'|awk '$1 {print "\t"}' > $file/pos_empty_valid
    cat $file/best.valid.txt|sed '/BOS/d'|sed '/EOS/d'|awk '$1 {print $2}' > $file/CONCEPTtag_valid
    cat $file/best.valid.txt|sed '/BOS/d'|sed '/EOS/d'|awk '$1 {print $3}' > $file/predictedCONCEPTtag_valid
    paste $file/token_valid $file/pos_empty_valid $file/CONCEPTtag_valid $file/predictedCONCEPTtag_valid > $file/OUTforConllevalvalid.txt
    rm $file/token_valid
    rm $file/pos_empty_valid
    rm $file/CONCEPTtag_valid
    rm $file/predictedCONCEPTtag_valid
    perl conlleval.pl -d '\t' < $file/OUTforConllevalvalid.txt > $file/EvaluationValid.txt
    rm $file/OUTforConllevalvalid.txt
    echo "$(cat $file/EvaluationValid.txt|grep 'accuracy: '|awk '{print $2}'|tr -d ['%;'])" >> accuracyValid.dat
    echo "$(cat $file/EvaluationValid.txt|grep 'accuracy: '|awk '{print $4}'|tr -d ['%;'])" >> precisionValid.dat
    echo "$(cat $file/EvaluationValid.txt|grep 'accuracy: '|awk '{print $6}'|tr -d ['%;'])" >> recallValid.dat
    echo "$(cat $file/EvaluationValid.txt|grep 'accuracy: '|awk '{print $8}'|tr -d ['%;'])" >> FB1Valid.dat
    
    cat outTest/$file\_test_out.txt|awk '$1 {print $1}' > $file/token_test
    cat outTest/$file\_test_out.txt|awk '$1 {print "\t"}' > $file/pos_empty_test
    cat outTest/$file\_test_out.txt|awk '$1 {print $2}' > $file/CONCEPTtag
    cat outTest/$file\_test_out.txt|awk '$1 {print $3}' > $file/predictedCONCEPTtag
    paste $file/token_test $file/pos_empty_test $file/CONCEPTtag $file/predictedCONCEPTtag > $file/OUTforConlleval.txt
    rm $file/token_test
    rm $file/pos_empty_test
    rm $file/CONCEPTtag
    rm $file/predictedCONCEPTtag
    perl conlleval.pl -d '\t' < $file/OUTforConlleval.txt > $file/EvaluationTest.txt
    rm $file/OUTforConlleval.txt
    echo  $file >> header.dat
    echo "$(cat $file/EvaluationTest.txt|grep 'accuracy: '|awk '{print $2}'|tr -d ['%;'])" >> accuracy.dat
    echo "$(cat $file/EvaluationTest.txt|grep 'accuracy: '|awk '{print $4}'|tr -d ['%;'])" >> precision.dat
    echo "$(cat $file/EvaluationTest.txt|grep 'accuracy: '|awk '{print $6}'|tr -d ['%;'])" >> recall.dat
    echo "$(cat $file/EvaluationTest.txt|grep 'accuracy: '|awk '{print $8}'|tr -d ['%;'])" >> FB1.dat
    
done
paste header.dat accuracyValid.dat precisionValid.dat recallValid.dat recall.dat FB1Valid.dat >globalEvaluationValidAC_PR_RE_F1.dat
paste header.dat accuracy.dat precision.dat recall.dat FB1.dat >globalEvaluationTestAC_PR_RE_F1.dat
