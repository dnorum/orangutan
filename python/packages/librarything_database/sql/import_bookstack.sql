COPY
    {schema}.{table}
FROM
    STDIN
WITH
    (FORMAT CSV, HEADER)