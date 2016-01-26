#!/bin/bash

###########################################################
# DIR/plots, for storing the plots created by the scripts #
# DIR/r, used by the K-means cluster analysis R script    #
###########################################################

for subdir in plots r
do
	# Clear out DIR/subdir (if it exists)
	[ -d ${DIR}/$subdir ] && { rm -rf ${DIR}/$subdir; echo "Existing /$subdir directory removed."; }

	# Create DIR/subdir
	mkdir ${DIR}/$subdir
	echo "Created /$subdir subdirectory."
done
