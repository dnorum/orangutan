UPDATE library
SET width_scrubbed = NULL
WHERE
	width_scrubbed NOT BETWEEN ${width_min} AND ${width_max};
