#!/bin/bash

# Get ready to output first-pass summary plots.
# Clear out the /plots directory (if it exists).
[ -d ${DIR}/plots ] && { rm -rf ${DIR}/plots; echo "Existing /plots directory removed."; }

# Create the /plots directory.
mkdir ${DIR}/plots

# Status update.
echo "Created /plots directory."
echo
