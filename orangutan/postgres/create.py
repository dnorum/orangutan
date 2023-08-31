import psycopg
from psycopg import sql

import sys
sys.path.append("../common")
from common import load_snippet

from .connections import check_connection_database

def create_database(connection_settings, database):
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            if database_exists(connection_settings, database):
                raise ValueError(f"Database '{database.name}' already exists.")
            else:
                query_string = load_snippet(module=__name__,
                                            resource="sql/create_database.sql")
                query = sql.SQL(query_string).format(
                    database=sql.Identifier(database.name))
                cursor.execute(query)
    return 0

def create_schema(connection_settings, schema):
    check_connection_database(connection_settings, schema.database)
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            if schema_exists(connection_settings, schema):
                raise ValueError(f"Schema '{schema.name}' already exists.")
            else:
                query_string = load_snippet(module=__name__,
                                            resource="sql/create_schema.sql")
                query = sql.SQL(query_string).format(
                    schema=sql.Identifier(schema.name))
                cursor.execute(query)
    return 0

def add_column(connection_settings, column, type):
    check_connection_database(connection_settings, column.table.schema.database)
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            if column_exists(connection_settings, column):
                raise ValueError(f"Column '{column.name}' already exists.")
            else:
                query_string = load_snippet(
                    module=__name__,
                    resource=f"sql/add_{type}_column.sql")
                query = sql.SQL(query_string).format(
                    schema=sql.Identifier(column.table.schema.name),
                    table=sql.Identifier(column.table.name),
                    column=sql.Identifier(column.name))
                cursor.execute(query)
    return 0
# 1
# 2
# 3
# 4
# 5
# Eclipse scrollbar...