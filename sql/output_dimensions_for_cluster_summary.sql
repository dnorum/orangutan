COPY
	(	SELECT
			((${max_height}-${min_height})/${n_intervals}) * floor(height_scrubbed/((${max_height}-${min_height})/${n_intervals})) + ((${max_height}-${min_height})/${n_intervals})/2.0  AS "Height Bin"
		,	((${max_width}-${min_width})/${n_intervals}) * floor(width_scrubbed/((${max_width}-${min_width})/${n_intervals})) + ((${max_width}-${min_width})/${n_intervals})/2.0  AS "width (Width) Bin"
		,	COUNT(*) AS "Number of Books"
		FROM
			library
		WHERE
			"cluster" = ${cluster}::TEXT
		GROUP BY
			1, 2
		ORDER BY
			1 ASC, 2 ASC)
TO
	'${DIR}/working/cluster_${cluster}/book_heights_widths_selection.csv'
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
			library
		WHERE
			"cluster" = ${cluster}::TEXT	)
TO
	'${DIR}/working/cluster_${cluster}/book_dimensions_selection.csv'
(	FORMAT csv
,	DELIMITER ','
,	HEADER
,	NULL ''	);
