SELECT
    height
,   width
,   SUM(thickness) AS thickness
,   COUNT(*) AS n_books
FROM
    {schema}.{table}
WHERE
    height IS NOT NULL
AND width IS NOT NULL
AND thickness IS NOT NULL
GROUP BY
    height
,   width