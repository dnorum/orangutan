-- Add a DOUBLE PRECISION field to hold the scrubbed weight.
ALTER TABLE library
ADD COLUMN weight_scrubbed DOUBLE PRECISION;

-- Scrub the weight and convert it into a DOUBLE PRECISION value for the above
-- column. Units are assumed to be pounds.
UPDATE library
SET weight_scrubbed = 
	substring(weight from '^([.0-9]+) (?:pounds?)?$')::DOUBLE PRECISION;
