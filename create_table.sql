DROP TABLE IF EXISTS
	library;

CREATE TABLE library (
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
,	physical_description TEXT
,	weight TEXT
,	height TEXT
,	thickness TEXT
,	"length" TEXT
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
,	oclc TEXT
,	work_id TEXT	);

COPY library FROM '/home/don/projects/git/cluster_shelving/resources/librarything_dnorum.csv' 
	DELIMITER ','
	NULL ''
	CSV
	HEADER;
