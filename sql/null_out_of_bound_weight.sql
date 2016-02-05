UPDATE library
SET weight_scrubbed = NULL
WHERE
	weight_scrubbed NOT BETWEEN ${weight_min} AND ${weight_max};
