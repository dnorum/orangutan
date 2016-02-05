-- Add a DOUBLE PRECISION field to hold the scrubbed length.
ALTER TABLE library
ADD COLUMN length_scrubbed DOUBLE PRECISION;

-- Scrub the length and convert it into a DOUBLE PRECISION value for the above
-- column. Centimeters are converted to inches, while numbers without units are
-- assumed to be Imperial (inches).
UPDATE library
SET length_scrubbed =
	CASE	WHEN	"length" ~ '^[0-9.]+ inch(es)?$'
		THEN	substring("length"
			from '^([0-9.]+) inch(?:es)?$')::DOUBLE PRECISION
		WHEN	"length" ~ '^[0-9.]+ cm$'
		THEN	substring("length"
			from '^([0-9.]+) cm$')::DOUBLE PRECISION / 2.54
		WHEN	"length" ~ '^[0-9.]+$'
		THEN	"length"::DOUBLE PRECISION
		ELSE	NULL::DOUBLE PRECISION
		END;

UPDATE library
SET length_scrubbed = NULL
WHERE length_scrubbed NOT BETWEEN ${length_min} AND ${length_max};
