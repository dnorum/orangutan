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
