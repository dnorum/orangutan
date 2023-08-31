import psycopg
from psycopg import sql

import sys
sys.path.append("../common")
from common import load_snippet

from .connections import check_connection_database

def database_exists(connection_settings, database):
    exists = False
    with psycopg.connect(**connection_settings) as connection:
        with connection.cursor() as cursor:
            query_string = load_snippet(module=__name__,
                                        resource="sql/database_exists.sql")
            query = sql.SQL(query_string).format(database=
                                                 sql.Literal(database.name))
            cursor.execute(query)
            exists = cursor.fetchone()[0]
    return exists

def schema_exists(connection_settings, schema):
    # Removes need for checking if database exists.
    check_connection_database(connection_settings, schema.database)
    exists = False
    with psycopg.connect(**connection_settings) as connection:
        with connection.cursor() as cursor:
            query_string = load_snippet(module=__name__,
                                        resource="sql/schema_exists.sql")
            query = sql.SQL(query_string).format(schema=
                                                 sql.Literal(schema.name))
            cursor.execute(query)
            exists = cursor.fetchone()[0]
    return exists

def table_exists(connection_settings, table):
    check_connection_database(connection_settings, table.schema.database)
    exists = False
    with psycopg.connect(**connection_settings) as connection:
        if not schema_exists(connection_settings, table.schema):
            raise ValueError(f'Schema {table.schema.name} does not exist.')
        else:
            with connection.cursor() as cursor:
                query_string = load_snippet(module=__name__,
                                            resource="sql/table_exists.sql")
                query = sql.SQL(query_string).format(
                    schema=sql.Literal(table.schema.name),
                    table=sql.Literal(table.name))
                cursor.execute(query)
                exists = cursor.fetchone()[0]
    return exists

def column_exists(connection_settings, column):
    check_connection_database(connection_settings, column.table.schema.database)
    exists = False
    with psycopg.connect(**connection_settings) as connection:
        if not table_exists(connection_settings, column.table):
            raise ValueError(f'Table {column.table.name} does not exist.')
        else:
            with connection.cursor() as cursor:
                query_string = load_snippet(module=__name__,
                                            resource="sql/column_exists.sql")
                query = sql.SQL(query_string).format(
                    schema=sql.Literal(column.table.schema.name),
                    table=sql.Literal(column.table.name),
                    column=sql.Literal(column.name))
                cursor.execute(query)
                exists = cursor.fetchone()[0]
    return exists
# 1
# 2
# 3
# 4
# 5
# Eclipse scrollbar...