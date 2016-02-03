	I started off by installing Git (unnecessary for running this), PostgreSQL, and R as described in the links for those packages.

$ sudo apt-get update
$ sudo apt-get install git-all
$ sudo apt-get install postgresql postgresql-contrib
$ sudo apt-get install pgadmin3
$ sudo apt-get install r-base

	Next, I set up postgres with default usernames and passwords. This isn't completely necessary, but it's what I did and so what the later scripts assume. It should be relatively easy to change the scripts so that they don't assume this, if you want. If you don't, then:

$ sudo -u postgres createuser --superuser $USER
$ sudo -u postgres psql
postgres=# \password [your username here]

	It will prompt you for your passwords. Enter them, then exit postgres. (I'm assuming that if you have already installed and are using postgres then you probably know how to modify these scripts as needed.)

	Download the LibraryThing CSV dump into your ${project_dir}/resources/ folder. Convert it from tab-delimited into CSV, quoting empty strings. (I loaded it into OpenOffice Calc, then edited the filter settings when saving it as a CSV.) Note that the file path in the create_table.sql file is absolute at the moment.
	From here, the script cluster_shelving.sh can be run. What follows is a description of its functioning - detailed runtime options will be summarized at the end.
	Now to clean up the records - the primary focus here is on the fields containing the physical dimensions. Depending on your collection, it may be interesting to break it out further based on tags or other cataloguing information, but I'm shooting for the minimum working example which, in my case, dovetails nicely with the need to get bookshelves designed and built before I start moving books to my new house.
	(Note that all of the following is assuming the column names as specified in create_and_load_table.sql. Furthermore, the following bit is an explanation of the reasoning behind the various scrubs / conversions I settled on - depending on the data sources / data entry of another collection, some/all/none of this may be needed.)
	(Also note that inches/feet/pounds are used throughout because a) 'MURICA and b) I find it far easier for everyday, non-scientific/engineering use.)





7) Script to clean up library records - weight
9) Script to dump out library records with dimensional information (height, length, thickness, weight, primary ID)
8) Summary scripts to generate stats and visuals
	averages, standard deviations of all. N_null, n_non_null.
	Histograms of each individually
	Scatterplot/heat map of height-length
	Histogram of linear density

10) R script for cluster analysis
11) Automatic / parametrized R script version (in full stack)
12) Load R results back into database
13) Join R results back onto main library table
14) Generate final stats and calculations, output CSV data for graphs
15) Gnuplot graphs
16) Package everything up

Git - https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
PostgreSQL - https://help.ubuntu.com/community/PostgreSQL
R - www.r-bloggers.com/download-and-install-r-in-ubuntu
Cluster Analysis in R - http://www.mattpeeples.net/kmeans.html
LibraryThing export - www.librarything.com/export.php?export_type=tsv