-- Load the LibraryThing TSV dump into the table created above.
COPY library FROM '${DIR}/resources/librarything.csv' 
	DELIMITER ','
	NULL ''
	CSV
	HEADER
	ENCODING 'latin1';
