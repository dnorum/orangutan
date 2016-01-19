COPY
	(	SELECT
			((${max_height}-${min_height})/${n_intervals}) * floor(height_scrubbed/((${max_height}-${min_height})/${n_intervals})) + ((${max_height}-${min_height})/${n_intervals})/2.0  AS "Height Bin"
		,	((${max_length}-${min_length})/${n_intervals}) * floor(length_scrubbed/((${max_length}-${min_length})/${n_intervals})) + ((${max_length}-${min_length})/${n_intervals})/2.0  AS "Length (Width) Bin"
		,	COUNT(*) AS "Number of Books"
		FROM
			library
		WHERE
			height_scrubbed IS NOT NULL
		AND	length_scrubbed IS NOT NULL
		AND	thickness_scrubbed IS NOT NULL
		GROUP BY
			1, 2
		ORDER BY
			1 ASC, 2 ASC)
TO
	'${DIR}/working/book_heights_lengths.csv'
(	FORMAT csv
,	DELIMITER ','
,	HEADER
,	NULL ''	);

COPY
	(	SELECT
			book_id AS "Book ID"
		,	height_scrubbed AS "Height (in)"
		,	length_scrubbed AS "Width (in)"
		FROM
			library
		WHERE
			height_scrubbed IS NOT NULL
		AND	length_scrubbed IS NOT NULL	)
TO
	'${DIR}/r/book_dimensions.csv'
(	FORMAT csv
,	DELIMITER ','
,	HEADER
,	NULL ''	);

COPY
	(	SELECT
			book_id AS "Book ID"
		,	height_scrubbed AS "Height (in)"
		,	length_scrubbed AS "Width (in)"
		,	thickness_scrubbed AS "Thickness (in)"
		,	weight_scrubbed AS "Weight (lb)"
		FROM
			library
		WHERE
			height_scrubbed IS NOT NULL
		AND	length_scrubbed IS NOT NULL
		AND	thickness_scrubbed IS NOT NULL	)
TO
	'${DIR}/working/book_dimensions.csv'
(	FORMAT csv
,	DELIMITER ','
,	HEADER
,	NULL ''	);
