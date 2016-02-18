#!/bin/bash

# Invoke the plotting scripts for each of the dimensions - height, width,
# thickness, and weight, for both the selection and the summary data.
gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${max_height}" -e "min=${min_height}" -e "n_books=${n_records_dumped}" ${DIR}/gnuplot/height_selection.gp
echo "Book heights plotted to $DIR/plots/book_heights_selection.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${max_width}" -e "min=${min_width}" -e "n_books=${n_records_dumped}" ${DIR}/gnuplot/width_selection.gp
echo "Book widths plotted to $DIR/plots/book_widths_selection.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${max_thickness}" -e "min=${min_thickness}" -e "n_books=${n_records_dumped}" ${DIR}/gnuplot/thickness_selection.gp
echo "Book thicknesses plotted to $DIR/plots/book_thicknesses_selection.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${max_weight}" -e "min=${min_weight}" -e "n_books=${n_records_dumped}" ${DIR}/gnuplot/weight_selection.gp
echo "Book weights plotted to $DIR/plots/book_weights_selection.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "maxh=${max_height}" -e "minh=${min_height}" -e "maxl=${max_width}" -e "minl=${min_width}" -e "n_books=${n_records_dumped}" ${DIR}/gnuplot/height_width_selection.gp
echo "Book heights and widths plotted to $DIR/plots/book_heights_widths_selection.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "maxh=${max_height}" -e "minh=${min_height}" -e "maxl=${max_width}" -e "minl=${min_width}" -e "n_books=${n_records_dumped}" ${DIR}/gnuplot/height_width_weighted_selection.gp
echo "Book heights and widths, weighted by thickness, plotted to $DIR/plots/book_heights_widths_weighted_selection.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${summary_max_height}" -e "min=${summary_min_height}" -e "n_books=${n_records_dumped_summary}" ${DIR}/gnuplot/height_summary.gp
echo "Book heights plotted to $DIR/plots/book_heights_summary.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${summary_max_width}" -e "min=${summary_min_width}" -e "n_books=${n_records_dumped_summary}" ${DIR}/gnuplot/width_summary.gp
echo "Book widths plotted to $DIR/plots/book_widths_summary.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${summary_max_thickness}" -e "min=${summary_min_thickness}" -e "n_books=${n_records_dumped_summary}" ${DIR}/gnuplot/thickness_summary.gp
echo "Book thicknesses plotted to $DIR/plots/book_thicknesses_summary.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "max=${summary_max_weight}" -e "min=${summary_min_weight}" -e "n_books=${n_records_dumped_summary}" ${DIR}/gnuplot/weight_summary.gp
echo "Book weights plotted to $DIR/plots/book_weights_summary.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "maxh=${summary_max_height}" -e "minh=${summary_min_height}" -e "maxl=${summary_max_width}" -e "minl=${summary_min_width}" -e "n_books=${n_records_dumped_summary}" ${DIR}/gnuplot/height_width_summary.gp
echo "Book heights and widths plotted to $DIR/plots/book_heights_widths_summary.ps"

gnuplot -e "DIR='${DIR}'" -e "n=${n_intervals}" -e "maxh=${summary_max_height}" -e "minh=${summary_min_height}" -e "maxl=${summary_max_width}" -e "minl=${summary_min_width}" -e "n_books=${n_records_dumped_summary}" ${DIR}/gnuplot/height_width_weighted_summary.gp
echo "Book heights and widths, weighted by thickness, plotted to $DIR/plots/book_heights_widths_weighted_summary.ps"
