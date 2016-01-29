-- Make sure that the table will be created with the desired format. Note that
-- no schema is specified, although one can be.
DROP TABLE IF EXISTS
	library_clusters;

-- The R cluster analysis file will be pulled in as straight text for now
CREATE TABLE library_clusters (
	book_id TEXT
,	"cluster" TEXT
,	weight TEXT
,	height TEXT	);
