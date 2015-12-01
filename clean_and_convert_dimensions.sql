-- Add a DOUBLE PRECISION field to hold the scrubbed height.
ALTER TABLE library
ADD COLUMN height_scrubbed DOUBLE PRECISION;

-- Scrub the height and convert it into a DOUBLE PRECISION value for the above
-- column. Centimeters are converted to inches, while numbers without units are
-- assumed to be Imperial (inches).
UPDATE library
SET height_scrubbed =
	CASE	WHEN	height ~ '^[0-9.]+ inch(es)?$'
		THEN	substring(height
			from '^([0-9.]+) inch(?:es)?$')::DOUBLE PRECISION
		WHEN	height ~ '^[0-9.]+ cm$'
		THEN	substring(height
			from '^([0-9.]+) cm$')::DOUBLE PRECISION / 2.54
		WHEN	height ~ '^[0-9.]+$'
		THEN	height::DOUBLE PRECISION
		ELSE	NULL::DOUBLE PRECISION
		END;

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
		WHEN	"length" ~ '^[0-9.]+ cm$'
		THEN	substring(thickness
			from '^([0-9.]+) cm$')::DOUBLE PRECISION / 2.54
		WHEN	thickness ~ '^[0-9.]+$'
		THEN	thickness::DOUBLE PRECISION
		ELSE	NULL::DOUBLE PRECISION
		END;
