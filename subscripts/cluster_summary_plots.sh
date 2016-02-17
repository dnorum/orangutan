#!/bin/bash

# Invoke the plotting scripts for each of the dimensions - height, width,
# thickness, and weight, for the cluster data.
gnuplot -e "DIR='${DIR}'" -e "cluster=${cluster}" -e "n=${n_intervals}" -e "max=${max_height}" -e "min=${min_height}" ${DIR}/gnuplot/cluster_height_summary.gp
echo "Book heights plotted to $DIR/working/cluster_${cluster}/book_heights_summary.ps"

gnuplot -e "DIR='${DIR}'" -e "cluster=${cluster}" -e "n=${n_intervals}" -e "max=${max_width}" -e "min=${min_width}" ${DIR}/gnuplot/cluster_width_summary.gp
echo "Book widths plotted to $DIR/working/cluster_${cluster}/book_widths_summary.ps"

gnuplot -e "DIR='${DIR}'" -e "cluster=${cluster}" -e "n=${n_intervals}" -e "max=${max_thickness}" -e "min=${min_thickness}" ${DIR}/gnuplot/cluster_thickness_summary.gp
echo "Book thicknesses plotted to $DIR/working/cluster_${cluster}/book_thicknesses_summary.ps"

gnuplot -e "DIR='${DIR}'" -e "cluster=${cluster}" -e "n=${n_intervals}" -e "max=${max_weight}" -e "min=${min_weight}" ${DIR}/gnuplot/cluster_weight_summary.gp
echo "Book weights plotted to $DIR/working/cluster_${cluster}/book_weights_summary.ps"

gnuplot -e "DIR='${DIR}'" -e "cluster=${cluster}" -e "n=${n_intervals}" -e "maxh=${max_height}" -e "minh=${min_height}" -e "maxl=${max_width}" -e "minl=${min_width}" ${DIR}/gnuplot/cluster_height_width_summary.gp
echo "Book heights and widths plotted to $DIR/working/cluster_${cluster}/book_heights_widths_summary.ps"
