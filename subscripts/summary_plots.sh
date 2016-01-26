#!/bin/bash

# Invoke the plotting scripts for each of the dimensions - height, length 
# (width), thickness, and weight.
gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${max_height}" -e "min=${min_height}" ${DIR}/subscripts/gnuplot/height.gp
echo "Book heights plotted to $DIR/plots/book_heights.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${max_length}" -e "min=${min_length}" ${DIR}/subscripts/gnuplot/length.gp
echo "Book lengths plotted to $DIR/plots/book_lengths.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${max_thickness}" -e "min=${min_thickness}" ${DIR}/subscripts/gnuplot/thickness.gp
echo "Book thicknesses plotted to $DIR/plots/book_thicknesses.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${max_weight}" -e "min=${min_weight}" ${DIR}/subscripts/gnuplot/weight.gp
echo "Book weights plotted to $DIR/plots/book_weights.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "maxh=${max_height}" -e "minh=${min_height}" -e "maxl=${max_length}" -e "minl=${min_length}" ${DIR}/subscripts/gnuplot/height_length.gp
echo "Book heights and lengths plotted to $DIR/plots/book_heights_lengths.ps"
