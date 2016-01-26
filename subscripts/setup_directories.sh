#!/bin/bash

###########################################################
# DIR/plots, for storing the plots created by the scripts #
###########################################################

# Clear out the /plots directory (if it exists).
[ -d ${DIR}/plots ] && { rm -rf ${DIR}/plots; echo "Existing /plots directory removed."; }

# Create the /plots directory.
mkdir ${DIR}/plots
echo "Created /plots directory."


########################################################
# DIR/r, used by the K-means cluster analysis R script #
########################################################

# Clear out the /r directory (if it exists).
[ -d ${DIR}/r ] && { rm -rf ${DIR}/r; echo "Existing /r directory removed."; }

# Create the /r directory.
mkdir ${DIR}/r
echo "Created /r directory."
