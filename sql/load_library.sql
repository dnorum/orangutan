-- Load the LibraryThing CSV dump into the table created above.
COPY library FROM '${DIR}/resources/librarything.csv' 
	DELIMITER ','
	NULL ''
	CSV
	HEADER
	ENCODING 'utf-8';
