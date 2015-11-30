#!/bin/sh
database="cluster_analysis"
create_table="create_table.sql"
sudo -u $USER dropdb --if-exists $database
sudo -u $USER createdb $database
psql $database -f $create_table
