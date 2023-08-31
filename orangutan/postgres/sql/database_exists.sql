SELECT
    EXISTS( SELECT
                datname
            FROM
                pg_database
            WHERE
                datname = {database})