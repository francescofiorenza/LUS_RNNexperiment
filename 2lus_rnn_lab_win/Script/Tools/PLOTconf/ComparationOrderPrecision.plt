set terminal pngcairo  font "arial,10" fontscale 1.0 size 600, 400 
set output '../output/PLOT/CONCEPT/ClusterOrderPlotPrecision_WORD.png'
set title "WORD as TOKEN precision\n NLSPARQL classification with the different order"  font "sans, 13" 
set xlabel "Language Model order"
set ylabel "Precision %" 
set yrange [40:*] noreverse nowriteback
set auto x
set grid

set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9
set xtic rotate by -45
#set bmargin 10 

plot [:13] [:]'../output/PLOT/CONCEPT/TrasposePrecision.dat' \
     using 2:xtic(1) ti col,\
      '' u 3 ti col, \
      '' u 4 ti col, \
      '' u 5 ti col, \
      '' u 6 ti col, \
      '' u 7 ti col