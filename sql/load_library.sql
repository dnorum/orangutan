-- Load the LibraryThing TSV dump into the table created above.
COPY library FROM '${DIR}/resources/librarything.tsv' 
	DELIMITER E'\t'
	NULL ''
	CSV
	HEADER;
