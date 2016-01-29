-- Load the R cluster analysis CSV dump into the table created above. Note that
-- it's currently given as an absolute path.
COPY library_clusters FROM '/home/don/projects/git/cluster_shelving/r/kmeans_out.csv' 
	DELIMITER ','
	NULL ''
	CSV
	HEADER;
