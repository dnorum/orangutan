COPY
	(	SELECT
			((${max_height}-${min_height})/${n_intervals}) * floor(height_scrubbed/((${max_height}-${min_height})/${n_intervals})) + ((${max_height}-${min_height})/${n_intervals})/2.0  AS "Height Bin"
		,	((${max_width}-${min_width})/${n_intervals}) * floor(width_scrubbed/((${max_width}-${min_width})/${n_intervals})) + ((${max_width}-${min_width})/${n_intervals})/2.0  AS "width (Width) Bin"
		,	COUNT(*) AS "Number of Books"
		FROM
			library
		WHERE
			height_scrubbed IS NOT NULL
		AND	width_scrubbed IS NOT NULL
		GROUP BY
			1, 2
		ORDER BY
			1 ASC, 2 ASC	)
TO
	'${DIR}/working/book_heights_widths_summary.csv'
(	FORMAT csv
,	DELIMITER ','
,	HEADER
,	NULL ''	);

COPY
	(	SELECT
			((${max_height}-${min_height})/${n_intervals}) * floor(height_scrubbed/((${max_height}-${min_height})/${n_intervals})) + ((${max_height}-${min_height})/${n_intervals})/2.0  AS "Height Bin"
		,	((${max_width}-${min_width})/${n_intervals}) * floor(width_scrubbed/((${max_width}-${min_width})/${n_intervals})) + ((${max_width}-${min_width})/${n_intervals})/2.0  AS "width (Width) Bin"
		,	SUM(thickness_scrubbed) AS "Inches of Books"
		FROM
			library
		WHERE
			height_scrubbed IS NOT NULL
		AND	width_scrubbed IS NOT NULL
		AND	thickness_scrubbed IS NOT NULL
		GROUP BY
			1, 2
		ORDER BY
			1 ASC, 2 ASC	)
TO
	'${DIR}/working/book_heights_widths_weighted_summary.csv'
(	FORMAT csv
,	DELIMITER ','
,	HEADER
,	NULL ''	);

COPY
	(	SELECT
			book_id AS "Book ID"
		,	height_scrubbed AS "Height (in)"
		,	width_scrubbed AS "Width (in)"
		,	thickness_scrubbed AS "Thickness (in)"
		,	weight_scrubbed AS "Weight (lb)"
		FROM
			library	)
TO
	'${DIR}/working/book_dimensions_summary.csv'
(	FORMAT csv
,	DELIMITER ','
,	HEADER
,	NULL ''	);
