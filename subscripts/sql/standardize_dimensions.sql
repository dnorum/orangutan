-- If we only have some of the physical dimensions, NULL them out to remove any
-- possible ambiguity, so that the final set of scrubbed dimensions either has
-- all three of height, length (width), and thickness; or none of them.
UPDATE library
SET height_scrubbed = NULL
WHERE		length_scrubbed IS NULL
	OR	thickness_scrubbed IS NULL;

UPDATE library
SET length_scrubbed = NULL
WHERE		height_scrubbed IS NULL
	OR	thickness_scrubbed IS NULL;

UPDATE library
SET thickness_scrubbed = NULL
WHERE		height_scrubbed IS NULL
	OR	length_scrubbed IS NULL;
