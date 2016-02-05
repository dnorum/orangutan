-- Add a DOUBLE PRECISION field to hold the scrubbed thickness.
ALTER TABLE library
ADD COLUMN thickness_scrubbed DOUBLE PRECISION;

-- Scrub the thickness and convert it into a DOUBLE PRECISION value for the
-- above column. Centimeters are converted to inches, while numbers without
-- units are assumed to be Imperial (inches).
UPDATE library
SET thickness_scrubbed =
	CASE	WHEN	thickness ~ '^[0-9.]+ inch(es)?$'
		THEN	substring(thickness
			from '^([0-9.]+) inch(?:es)?$')::DOUBLE PRECISION
		WHEN	thickness ~ '^[0-9.]+ cm$'
		THEN	substring(thickness
			from '^([0-9.]+) cm$')::DOUBLE PRECISION / 2.54
		WHEN	thickness ~ '^[0-9.]+$'
		THEN	thickness::DOUBLE PRECISION
		ELSE	NULL::DOUBLE PRECISION
		END;
