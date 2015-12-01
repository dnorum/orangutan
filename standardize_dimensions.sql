-- If we only have some of the physical dimensions, NULL them out to remove any
-- possible ambiguity, so that the final set of scrubbed dimensions either has
-- all three of height, length (width), and thickness; or none of them.
UPDATE library
SET height = NULL
WHERE		"length" IS NULL
	OR	thickness IS NULL;

UPDATE library
SET "length" = NULL
WHERE		height IS NULL
	OR	thickness IS NULL;

UPDATE library
SET thickness = NULL
WHERE		height IS NULL
	OR	"length" IS NULL;
