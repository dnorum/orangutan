-- Add the cluster field to the library table.
ALTER TABLE
	library
ADD COLUMN "cluster" TEXT;

-- Add the cluster values from the library_clusters table.
UPDATE
	library
SET
	"cluster" = library_clusters."cluster"
FROM
	library_clusters
WHERE
	library.book_id = library_clusters.book_id;
