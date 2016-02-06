UPDATE library
SET thickness_scrubbed = NULL
WHERE
	thickness_scrubbed NOT BETWEEN ${thickness_min} AND ${thickness_max};
