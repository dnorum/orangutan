-- Add a DOUBLE PRECISION field to hold the scrubbed width.
ALTER TABLE library
ADD COLUMN width_scrubbed DOUBLE PRECISION;

-- Scrub the width and convert it into a DOUBLE PRECISION value for the above
-- column. Centimeters are converted to inches, while numbers without units are
-- assumed to be Imperial (inches).
UPDATE library
SET width_scrubbed =
	CASE	WHEN	width ~ '^[0-9.]+ inch(es)?$'
		THEN	substring(width
			from '^([0-9.]+) inch(?:es)?$')::DOUBLE PRECISION
		WHEN	width ~ '^[0-9.]+ cm$'
		THEN	substring(width
			from '^([0-9.]+) cm$')::DOUBLE PRECISION / 2.54
		WHEN	width ~ '^[0-9.]+$'
		THEN	width::DOUBLE PRECISION
		ELSE	NULL::DOUBLE PRECISION
		END;

UPDATE library
SET width_scrubbed = NULL
WHERE width_scrubbed NOT BETWEEN ${width_min} AND ${width_max};
