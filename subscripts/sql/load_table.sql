-- Load the LibraryThing CSV dump into the table created above. Note that it's
-- currently given as an absolute path.
COPY library FROM '/home/don/projects/git/cluster_shelving/resources/librarything_dnorum.csv' 
	DELIMITER ','
	NULL ''
	CSV
	HEADER;
