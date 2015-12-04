#!/bin/bash

# Set up an empty database after dropping the existing database if it exists.
if psql $database -c '\q' 2>&1; then
	sudo -u $USER dropdb --if-exists $database
	sudo -u $USER createdb $database
	echo "$database dropped and recreated."
else
	sudo -u $USER createdb $database
	echo "$database created."
fi
echo
