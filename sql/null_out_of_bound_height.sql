UPDATE library
SET height_scrubbed = NULL
WHERE
	height_scrubbed NOT BETWEEN ${height_min} AND ${height_max};
