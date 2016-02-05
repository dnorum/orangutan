#!/bin/bash

# Invoke the plotting scripts for each of the dimensions - height, width,
# thickness, and weight.
gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${max_height}" -e "min=${min_height}" ${DIR}/subscripts/gnuplot/height.gp
echo "Book heights plotted to $DIR/plots/book_heights.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${max_width}" -e "min=${min_width}" ${DIR}/subscripts/gnuplot/width.gp
echo "Book widths plotted to $DIR/plots/book_widths.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${max_thickness}" -e "min=${min_thickness}" ${DIR}/subscripts/gnuplot/thickness.gp
echo "Book thicknesses plotted to $DIR/plots/book_thicknesses.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${max_weight}" -e "min=${min_weight}" ${DIR}/subscripts/gnuplot/weight.gp
echo "Book weights plotted to $DIR/plots/book_weights.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "maxh=${max_height}" -e "minh=${min_height}" -e "maxl=${max_width}" -e "minl=${min_width}" ${DIR}/subscripts/gnuplot/height_width.gp
echo "Book heights and widths plotted to $DIR/plots/book_heights_widths.ps"
