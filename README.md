# LUS_RNNexperiment
Experiment using recurrent neural net based on elman and Jordan model for a LUS on a Movie Domain.
# Installation
## Requirement
* sed - The GNU sed stream editor
* perl - Larry Wall's Practical Extraction and Report Language
* conlleval.pl - A evaluation tools https://github.com/tpeng/npchunker/blob/master/conlleval.pl
* gnuplot - Command-line driven interactive plotting program
* Theano http://deeplearning.net/software/theano/install.html Follow the guide

## Tutorial
http://deeplearning.net/tutorial/rnnslu.html

## Data for train and test
cd rnn_slu\data\DataNLSPARQL

wget http://www.cnts.ua.ac.be/conll2000/chunking/train.txt.gz

wget http://www.cnts.ua.ac.be/conll2000/chunking/test.txt.gz

gunzip train.txt.gz

gunzip test.txt.gz

rm train.txt.gz

rm test.txt.gz

mv train.txt NLSPARQL.train.data

mv test.txt NLSPARQL.test.data

Take a look at the 3runSim.sh in the folder cd 2lus_rnn_lab_win/Script/

cd 1lus_rnn_lab_random/Script/

./1run1InitialStep.sh

It generate for each training and test a new subTrain a validation with a new dictionaries related to the subTrain.
I chose the one with the original training set are split in 10% for validation and 90% for subTrain set. The decision is made after I run the next script, and I verify that the statistic of validation and training is comparable.
By this script as said before (2runBaseAnalysis.sh) it is possible to generate the file hist and histnorm of the selected training set and validation set with some other information. The output directory is the same folder in which are the dataset (rnn_slu\data\DataNLSPARQL)

./2runBaseAnalysis.sh

Once the subTraining, the related label dictionary and word dictionary, and the validation set is ready you can take a look at the following script by which you can plan a big training and test simulation for both the RNN (E-RNN and J-RNN).

./3runSim.sh 

Now you must have a lot patience and wait. Each training took around 2 hours with a training of 19309 words.
If you are impatient, open a new terminal and lauch (5runPlot.sh) the script that generate all the graph. Probably different are incomplite but is possible to analyse the correctness of the hyperparamenter set for example the learning rate by the OptimizationSpeed(namemodel).png. The output folder of the graph is outPlot.

./5runPlot.sh

Once all the simulation is finished launch the script 4runConlleval.sh to evaluate and collect all the performance on the test set. The relaunch the previous script to complite all the last graph.

./4runConlleval.sh

Do not hesitate to write me if you encounter difficulties. 






