#!/bin/bash

n_books=$(echo 'SELECT COUNT(1) FROM library WHERE "cluster" = ' $cluster '::TEXT' | psql $database -t)
n_books=${n_books// /}

# Record the statistics for the height (trimming whitespace).
min_height=$(echo 'SELECT min(height_scrubbed)::NUMERIC(16,4) FROM library WHERE height_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
min_height=${min_height// /}

max_height=$(echo 'SELECT max(height_scrubbed)::NUMERIC(16,4) FROM library WHERE height_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
max_height=${max_height// /}

average_height=$(echo 'SELECT avg(height_scrubbed)::NUMERIC(16,4) FROM library WHERE height_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
average_height=${average_height// /}

stddev_height=$(echo 'SELECT stddev_samp(height_scrubbed)::NUMERIC(16,4) FROM library WHERE height_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
stddev_height=${stddev_height// /}

# Record the statistics for the width (trimming whitespace).
min_width=$(echo 'SELECT min(width_scrubbed)::NUMERIC(16,4) FROM library WHERE width_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
min_width=${min_width// /}

max_width=$(echo 'SELECT max(width_scrubbed)::NUMERIC(16,4) FROM library WHERE width_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
max_width=${max_width// /}

average_width=$(echo 'SELECT avg(width_scrubbed)::NUMERIC(16,4) FROM library WHERE width_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
average_width=${average_width// /}

stddev_width=$(echo 'SELECT stddev_samp(width_scrubbed)::NUMERIC(16,4) FROM library WHERE width_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
stddev_width=${stddev_width// /}

# Record the statistics for the thickness (trimming whitespace).
min_thickness=$(echo 'SELECT min(thickness_scrubbed)::NUMERIC(16,4) FROM library WHERE thickness_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
min_thickness=${min_thickness// /}

max_thickness=$(echo 'SELECT max(thickness_scrubbed)::NUMERIC(16,4) FROM library WHERE thickness_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
max_thickness=${max_thickness// /}

average_thickness=$(echo 'SELECT avg(thickness_scrubbed)::NUMERIC(16,4) FROM library WHERE thickness_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
average_thickness=${average_thickness// /}

total_thickness=$(echo 'SELECT sum(thickness_scrubbed)::NUMERIC(16,4) FROM library WHERE thickness_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
total_thickness=${total_thickness// /}

stddev_thickness=$(echo 'SELECT stddev_samp(thickness_scrubbed)::NUMERIC(16,4) FROM library WHERE thickness_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
stddev_thickness=${stddev_thickness// /}

# Record the statistics for the weight (trimming whitespace).
min_weight=$(echo 'SELECT min(weight_scrubbed)::NUMERIC(16,4) FROM library WHERE weight_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
min_weight=${min_weight// /}

max_weight=$(echo 'SELECT max(weight_scrubbed)::NUMERIC(16,4) FROM library WHERE weight_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
max_weight=${max_weight// /}

average_weight=$(echo 'SELECT avg(weight_scrubbed)::NUMERIC(16,4) FROM library WHERE weight_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
average_weight=${average_weight// /}

total_weight=$(echo 'SELECT sum(weight_scrubbed)::NUMERIC(16,4) FROM library WHERE weight_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
total_weight=${total_weight// /}

stddev_weight=$(echo 'SELECT stddev_samp(weight_scrubbed)::NUMERIC(16,4) FROM library WHERE weight_scrubbed IS NOT NULL AND "cluster" = ' $cluster '::TEXT' | psql $database -t)
stddev_weight=${stddev_weight// /}

# Summary output.
echo "${n_books} in cluster ${cluster}."
echo "Heights of Books, in Inches:"
printf "\tMinimum: ${min_height}\n" # Used for \t tabs.
printf "\tMaximum: ${max_height}\n"
printf "\tAverage: ${average_height}\n"
printf "\tStandard Deviation: ${stddev_height}\n"
echo
echo "Widths of Books, in Inches:"
printf "\tMinimum: ${min_width}\n"
printf "\tMaximum: ${max_width}\n"
printf "\tAverage: ${average_width}\n"
printf "\tStandard Deviation: ${stddev_width}\n"
echo
echo "Thicknesses of Books, in Inches:"
printf "\tMinimum: ${min_thickness}\n"
printf "\tMaximum: ${max_thickness}\n"
printf "\tAverage: ${average_thickness}\n"
printf "\tTotal: ${total_thickness}\n"
printf "\tStandard Deviation: ${stddev_thickness}\n"
echo
echo "Weights of Books, in Pounds:"
printf "\tMinimum: ${min_weight}\n"
printf "\tMaximum: ${max_weight}\n"
printf "\tAverage: ${average_weight}\n"
printf "\tTotal: ${total_weight}\n"
printf "\tStandard Deviation: ${stddev_weight}\n"
echo
