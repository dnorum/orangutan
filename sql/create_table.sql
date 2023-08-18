-- Make sure that the table will be created with the desired format. Note that
-- no schema is specified, although one can be.
DROP TABLE IF EXISTS
	library;

-- The LibraryThing dump will be pulled in as straight text for now, with the
-- dimensional fields scrubbed and converted as needed in a later step.
CREATE TABLE book_stack (
	book_id TEXT
,	title TEXT
,	sort_character TEXT
,	primary_author TEXT
,	primary_author_role TEXT
,	secondary_author TEXT
,	secondary_author_roles TEXT
,	publication TEXT
,	"date" TEXT
,	review TEXT
,	rating TEXT
,	"comment" TEXT
,	private_comment TEXT
,	summary TEXT
,	media TEXT
,	physical_description TEXT
,	weight TEXT
,	height TEXT
,	thickness TEXT
,	width TEXT
,	dimensions TEXT
,	page_count TEXT
,	lccn TEXT
,	acquired TEXT
,	date_started TEXT
,	date_read TEXT
,	barcode TEXT
,	bcid TEXT
,	tags TEXT
,	collections TEXT
,	languages TEXT
,	original_languages TEXT
,	lc_classification TEXT
,	isbn TEXT
,	isbns TEXT
,	subjects TEXT
,	dewey_decimal TEXT
,	dewey_wording TEXT
,	other_call_number TEXT
,	copies TEXT
,	source TEXT
,	entry_date TEXT
,	from_where TEXT
,	oclc TEXT
,	work_id TEXT
,	lending_patron TEXT
,	lending_status TEXT
,	lending_start TEXT
,	lending_end TEXT	);
