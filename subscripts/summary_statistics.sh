#!/bin/bash

# Record the statistics for the height (trimming whitespace).
min_height=$(psql $database -t -c "SELECT min(height_scrubbed) FROM library WHERE height_scrubbed IS NOT NULL")
min_height=${min_height// /}

max_height=$(psql $database -t -c "SELECT max(height_scrubbed) FROM library WHERE height_scrubbed IS NOT NULL")
max_height=${max_height// /}

average_height=$(psql $database -t -c "SELECT avg(height_scrubbed) FROM library WHERE height_scrubbed IS NOT NULL")
average_height=${average_height// /}

stddev_height=$(psql $database -t -c "SELECT stddev_samp(height_scrubbed) FROM library WHERE height_scrubbed IS NOT NULL")
stddev_height=${stddev_height// /}

# Record the statistics for the length/width (trimming whitespace).
min_length=$(psql $database -t -c "SELECT min(length_scrubbed) FROM library WHERE length_scrubbed IS NOT NULL")
min_length=${min_length// /}

max_length=$(psql $database -t -c "SELECT max(length_scrubbed) FROM library WHERE length_scrubbed IS NOT NULL")
max_length=${max_length// /}

average_length=$(psql $database -t -c "SELECT avg(length_scrubbed) FROM library WHERE length_scrubbed IS NOT NULL")
average_length=${average_length// /}

stddev_length=$(psql $database -t -c "SELECT stddev_samp(length_scrubbed) FROM library WHERE length_scrubbed IS NOT NULL")
stddev_length=${stddev_length// /}

# Record the statistics for the thickness (trimming whitespace).
min_thickness=$(psql $database -t -c "SELECT min(thickness_scrubbed) FROM library WHERE thickness_scrubbed IS NOT NULL")
min_thickness=${min_thickness// /}

max_thickness=$(psql $database -t -c "SELECT max(thickness_scrubbed) FROM library WHERE thickness_scrubbed IS NOT NULL")
max_thickness=${max_thickness// /}

average_thickness=$(psql $database -t -c "SELECT avg(thickness_scrubbed) FROM library WHERE thickness_scrubbed IS NOT NULL")
average_thickness=${average_thickness// /}

stddev_thickness=$(psql $database -t -c "SELECT stddev_samp(thickness_scrubbed) FROM library WHERE thickness_scrubbed IS NOT NULL")
stddev_thickness=${stddev_thickness// /}

# Summary output.
echo "Heights of Books, in Inches:"
printf "\tMinimum: ${min_height}\n" # Used for \t tabs.
printf "\tMaximum: ${max_height}\n"
printf "\tAverage: ${average_height}\n"
printf "\tStandard Deviation: ${stddev_height}\n"
echo
echo "Lengths (Widths) of Books, in Inches:"
printf "\tMinimum: ${min_length}\n"
printf "\tMaximum: ${max_length}\n"
printf "\tAverage: ${average_length}\n"
printf "\tStandard Deviation: ${stddev_length}\n"
echo
echo "Thicknesses of Books, in Inches:"
printf "\tMinimum: ${min_thickness}\n"
printf "\tMaximum: ${max_thickness}\n"
printf "\tAverage: ${average_thickness}\n"
printf "\tStandard Deviation: ${stddev_thickness}\n"
echo
