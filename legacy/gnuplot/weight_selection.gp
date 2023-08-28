# n = Number of intervals
# max = Maximum weight
# min = Minimum weight

reset
set title "Distribution of ".n_books." Book Weights Selected for Analysis"
set xlabel 'Weight [lb]'
set ylabel 'Number of Books'
set timestamp # turn on a date/time indicator
set datafile separator ","
set term postscript
set output DIR."/plots/book_weights_selection.ps"
width=(max-min)/n # Interval width
# Define the function used to map a value to an interval
hist(x,width)=width*floor(x/width)+width/2.0
set xrange [min:max]
set yrange [0:]
# To put an empty boundary around the data inside an autoscaled graph
set offset graph 0.05,0.05,0.0
set xtics min,(max-min)/5,max
set boxwidth width*0.9
set style fill solid 0.5 # Fillstyle
set tics out nomirror
plot DIR."/working/book_dimensions_selection.csv" every ::1 using (hist($5,width)):(1.0) smooth freq w boxes lc rgb"green" notitle
