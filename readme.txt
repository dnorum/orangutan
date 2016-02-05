	Create a /resources folder in the main project directory (not included in
the project repo because it just holds library-specific source files), then 
download the LibraryThing TSV export into that /resources/ folder as
"librarything.tsv".
	From here, the first script "cluster_shelving.sh" can be run. It will load
the records from the LibraryThing export file into the default
"cluster_analysis" database and then scrub the dimensions. Inches/feet/pounds
are used throughout because a) 'MURICA but mostly because b) I find it far
easier for everyday, non-scientific/engineering use.
	After it has standardized the dimensions of each book, the script runs a
query to create a flag to for including books in the cluster analysis. This can
be based off of a specific tag, collection, author, etc. It reports how many
books are marked for inclusion and how many of these have valid dimensions. (To
be included a book must have a valid height and width; thickness is optional but
useful for shelf-length planning.)
	The books that meet these criteria are then dumped out into a CSV file ready
to be run through the R cluster-analysis script.

QQQ MORE STUFF GOES HERE QQQ

Git - https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
PostgreSQL - https://help.ubuntu.com/community/PostgreSQL
R - www.r-bloggers.com/download-and-install-r-in-ubuntu
Cluster Analysis in R - http://www.mattpeeples.net/kmeans.html
LibraryThing export - www.librarything.com/export.php?export_type=tsv