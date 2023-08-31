import json
import psycopg
from psycopg import sql
import re

def load_postgres_configuration(tranches):
    configuration = {}
    for tranche in tranches:
        with open(f"{tranche}/postgres.json") as json_file:
            json_data = json.load(json_file)
        for stage in json_data:
            if stage not in configuration:
                configuration[stage] = {}
            configuration[stage] = {**configuration[stage], **json_data[stage]}
    return configuration

def drop_schema_if_exists(connection_settings, schema):
    check_connection_database(connection_settings, schema.database)
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            query_string = _load_snippet("drop_schema_if_exists")
            query = sql.SQL(query_string).format(schema=sql.Identifier(schema.name))
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
                query_string = _load_snippet("rename_column")
                query = sql.SQL(query_string).format(schema=sql.Identifier(column.table.schema.name),
                                                     table=sql.Identifier(column.table.name),
                                                     column=sql.Identifier(column.name),
                                                     name=sql.Identifier(name))
                cursor.execute(query)
    return 0





# Eclipse scrollbar...