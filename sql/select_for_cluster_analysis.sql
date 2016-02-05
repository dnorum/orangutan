-- Add a BOOLEAN field to hold the flag for including a book in the cluster
-- analysis.
ALTER TABLE library
ADD COLUMN include_cluster_analysis BOOLEAN;

-- Set the default to FALSE.
UPDATE library
SET include_cluster_analysis = FALSE;

-- Set the flag to TRUE for books meeting the desired criteria.
UPDATE library
SET include_cluster_analysis = TRUE
WHERE

	-- Standard conditions to make sure it has dimensions to use.
	height_scrubbed IS NOT NULL
AND	width_scrubbed IS NOT NULL

	-- Thickness is desired for planning shelf lengths.
AND	thickness_scrubbed IS NOT NULL

	-- Only consider books in the desired collection; here, a new house.
AND	collections ~ 'New House';

	-- Other conditions could also be included, such as tags, rating, date
	-- acquired, etc.
