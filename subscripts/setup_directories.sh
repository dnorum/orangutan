#!/bin/bash

###########################################################
# DIR/plots, for storing the plots created by the scripts #
# DIR/r, used by the K-means cluster analysis R script    #
# DIR/working, used to hold files created by the script   s#
###########################################################

for subdir in plots r working
do
	# Clear out DIR/subdir (if it exists)
	[ -d ${DIR}/$subdir ] && { rm -rf ${DIR}/$subdir; echo "Existing /$subdir directory removed."; }

	# Create DIR/subdir
	mkdir ${DIR}/$subdir
	echo "Created /$subdir subdirectory."
done

# Allow _all_ users write access for the working and r directories. Note that
# this is not optimal, but I've not taken the time to find the postgres-specific
# setting.
chmod a+w ${DIR}/r
chmod a+w ${DIR}/working
