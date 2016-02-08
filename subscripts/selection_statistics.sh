#!/bin/bash

# Record the statistics for the height (trimming whitespace).
selection_min_height=$(psql $database -t -c "SELECT min(height_scrubbed) FROM library WHERE height_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_min_height=${min_height// /}

selection_max_height=$(psql $database -t -c "SELECT max(height_scrubbed) FROM library WHERE height_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_max_height=${max_height// /}

selection_average_height=$(psql $database -t -c "SELECT avg(height_scrubbed) FROM library WHERE height_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_average_height=${average_height// /}

selection_stddev_height=$(psql $database -t -c "SELECT stddev_samp(height_scrubbed) FROM library WHERE height_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_stddev_height=${stddev_height// /}

# Record the statistics for the width (trimming whitespace).
selection_min_width=$(psql $database -t -c "SELECT min(width_scrubbed) FROM library WHERE width_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_min_width=${min_width// /}

selection_max_width=$(psql $database -t -c "SELECT max(width_scrubbed) FROM library WHERE width_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_max_width=${max_width// /}

selection_average_width=$(psql $database -t -c "SELECT avg(width_scrubbed) FROM library WHERE width_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_average_width=${average_width// /}

selection_stddev_width=$(psql $database -t -c "SELECT stddev_samp(width_scrubbed) FROM library WHERE width_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_stddev_width=${stddev_width// /}

# Record the statistics for the thickness (trimming whitespace).
selection_min_thickness=$(psql $database -t -c "SELECT min(thickness_scrubbed) FROM library WHERE thickness_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_min_thickness=${min_thickness// /}

selection_max_thickness=$(psql $database -t -c "SELECT max(thickness_scrubbed) FROM library WHERE thickness_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_max_thickness=${max_thickness// /}

selection_average_thickness=$(psql $database -t -c "SELECT avg(thickness_scrubbed) FROM library WHERE thickness_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_average_thickness=${average_thickness// /}

selection_stddev_thickness=$(psql $database -t -c "SELECT stddev_samp(thickness_scrubbed) FROM library WHERE thickness_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_stddev_thickness=${stddev_thickness// /}

# Record the statistics for the weight (trimming whitespace).
selection_min_weight=$(psql $database -t -c "SELECT min(weight_scrubbed) FROM library WHERE weight_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_min_weight=${min_weight// /}

selection_max_weight=$(psql $database -t -c "SELECT max(weight_scrubbed) FROM library WHERE weight_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_max_weight=${max_weight// /}

selection_average_weight=$(psql $database -t -c "SELECT avg(weight_scrubbed) FROM library WHERE weight_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_average_weight=${average_weight// /}

selection_stddev_weight=$(psql $database -t -c "SELECT stddev_samp(weight_scrubbed) FROM library WHERE weight_scrubbed IS NOT NULL AND include_cluster_analysis")
selection_stddev_weight=${stddev_weight// /}

# Selection output.
echo "Heights of Books Included in Analysis, in Inches:"
printf "\tMinimum: ${selection_min_height}\n" # Used for \t tabs.
printf "\tMaximum: ${selection_max_height}\n"
printf "\tAverage: ${selection_average_height}\n"
printf "\tStandard Deviation: ${selection_stddev_height}\n"
echo
echo "Widths of Books Included in Analysis, in Inches:"
printf "\tMinimum: ${selection_min_width}\n"
printf "\tMaximum: ${selection_max_width}\n"
printf "\tAverage: ${selection_average_width}\n"
printf "\tStandard Deviation: ${selection_stddev_width}\n"
echo
echo "Thicknesses of Books Included in Analysis, in Inches:"
printf "\tMinimum: ${selection_min_thickness}\n"
printf "\tMaximum: ${selection_max_thickness}\n"
printf "\tAverage: ${selection_average_thickness}\n"
printf "\tStandard Deviation: ${selection_stddev_thickness}\n"
echo
echo "Weights of Books Included in Analysis, in Pounds:"
printf "\tMinimum: ${selection_min_weight}\n"
printf "\tMaximum: ${selection_max_weight}\n"
printf "\tAverage: ${selection_average_weight}\n"
printf "\tStandard Deviation: ${selection_stddev_weight}\n"
echo
