SELECT
	COUNT(*)
FROM
	library
WHERE
	height_scrubbed IS NOT NULL
AND	width_scrubbed IS NOT NULL
AND	thickness_scrubbed IS NOT NULL
AND	weight_scrubbed IS NOT NULL
