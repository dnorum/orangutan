import psycopg
from psycopg import sql
import re

import sys
sys.path.append("../common")
from common import load_snippet

def drop_schema_if_exists(connection_settings, schema):
    check_connection_database(connection_settings, schema.database)
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            query_string = load_snippet(
                module=__name__,
                resource="sql/drop_schema_if_exists.sql")
            query = sql.SQL(query_string).format(schema=
                                                 sql.Identifier(schema.name))
            cursor.execute(query)
    return 0

def rename_column(connection_settings, column, name):
    check_connection_database(connection_settings, column.table.schema.database)
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            if not column_exists(connection_settings, column):
                raise ValueError(f"Column '{column.name}' doesn't exist.")
            else:
                query_string = load_snippet(module=__name__,
                                            resource="sql/rename_column.sql")
                query = sql.SQL(query_string).format(
                    schema=sql.Identifier(column.table.schema.name),
                    table=sql.Identifier(column.table.name),
                    column=sql.Identifier(column.name),
                    name=sql.Identifier(name))
                cursor.execute(query)
    return 0
# 1
# 2
# 3
# 4
# 5
# Eclipse scrollbar...