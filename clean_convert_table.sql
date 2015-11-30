-- Change to type DOUBLE PRECISION
ALTER TABLE library
ADD COLUMN height_scrubbed TEXT;



-- Condense into one UPDATE and CASE statement
UPDATE library SET height_scrubbed = height;

UPDATE library SET
	height_scrubbed = substring(height_scrubbed from
	'^([0-9.]+) inch(:?es)?')
WHERE
	height_scrubbed ~ 'inch(es)?';

UPDATE library SET
	height_scrubbed = (substring(height_scrubbed from '^([0-9.]+) cm$')::DOUBLE PRECISION / 2.54)::TEXT
WHERE
	height_scrubbed ~ 'cm$';
