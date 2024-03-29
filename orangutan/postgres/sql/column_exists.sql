SELECT
    EXISTS( SELECT
                column_name
            FROM
                information_schema.columns
            WHERE
                table_schema = {schema}
            AND table_name = {table}
            AND column_name = {column})