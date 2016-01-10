#!/bin/bash

# Get ready to output first-pass summary plots.
# Clear out the /plots directory (if it exists).
[ -d ${DIR}/plots ] && { rm -rf ${DIR}/plots; echo "Existing /plots directory removed."; }

# Create the /plots directory.
mkdir ${DIR}/plots

# Status update.
echo "Created /plots directory."
echo

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
