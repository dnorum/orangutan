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
	Note that if you want to store the output as a text file, the tee command
can be used:
	$ ./cluster_shelving(_2)? | tee output.txt

1) Export your LibraryThing database as a tab-separated file vie
www.librarything.com/export.php?export_type=tsv. Save it in the ./resources
directory of the repository.
2) Run ./cluster_shelving.sh. It will load, scrub, normalize, flag, export,
summarize, and plot both the library as a whole and the books selected for
further analysis.
3) In RStudio, run the cluster analysis script via 
	> source('kmeans.R')
and follow the instructions from the script's source at
http://www.mattpeeples.net/kmeans.html.
	Note that depending on the number of books you have in your library (and if
you're using this then that number has probably winked coquettishly at five
digits) and the speed of your computer the R script may take... some time to
run, especially if the sizes of books in your library vary widely.
	The summary histograms can help with selecting a reasonable number of
clustering solutions to attempt.
4) Run ./cluster_shelving_2.sh. It will load the clusters into the database and
add them back to the original records loaded from LibraryThing, then output a
set of by-cluster summaries and plots.

Links:
Git - https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
PostgreSQL - https://help.ubuntu.com/community/PostgreSQL
R - www.r-bloggers.com/download-and-install-r-in-ubuntu
Cluster Analysis in R - http://www.mattpeeples.net/kmeans.html
LibraryThing Export - www.librarything.com/export.php?export_type=tsv