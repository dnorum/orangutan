-- Load the R cluster analysis CSV dump into the table created above. Note that
-- it's currently given as an absolute path.
COPY library_clusters FROM '${DIR}/r/kmeans_out.csv' 
	DELIMITER ','
	NULL ''
	CSV
	HEADER;
