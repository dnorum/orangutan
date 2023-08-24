UPDATE
    {schema}.{table}
SET
    {column} =  CASE    WHEN    {source_column} ~ '^\d*\.?\d*( inch(es)?)?$'
                        THEN    cast(substring({source_column} from '^(\d*\.?\d*)(?: inch(?:es)?)?$') as double precision)
                        ELSE    NULL::DOUBLE PRECISION
                        END