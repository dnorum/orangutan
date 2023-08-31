import pkgutil
import psycopg
from psycopg import sql

import sys
sys.path.append("../common")
from common import load_snippet
sys.path.append("../postgres")
import postgres

from .classes import SizeBin

def create_empty_bookstack(connection_settings, table):
    postgres.check_connection_database(connection_settings,
                                       table.schema.database)
    with psycopg.connect(**connection_settings) as connection:
        if postgres.table_exists(connection_settings, table):
            raise ValueError(f"{table.schema.name}.{table.name} "
                             "already exists.")
        query_string = load_snippet(module=__name__,
                                    resource="sql/create_empty_bookstack.sql")
        query = sql.SQL(query_string).format(
            schema=sql.Identifier(table.schema.name),
            table=sql.Identifier(table.name))
        with connection.cursor() as cursor:
            cursor.execute(query)

def import_bookstack(connection_settings, librarything_export, table):
    with psycopg.connect(**connection_settings) as connection:
        if not postgres.table_exists(connection_settings, table):
            raise ValueError(f"Table {table.name} does not exist.")
        with open(librarything_export, 'r') as librarything_export_file:
            with connection.cursor() as cursor:
                query_string = load_snippet(module=__name__,
                                            resource="sql/import_bookstack.sql")
                query = sql.SQL(query_string).format(
                    schema=sql.Identifier(table.schema.name),
                    table=sql.Identifier(table.name))
                with cursor.copy(query) as copy:
                    while books := librarything_export_file.read(100):
                        copy.write(books)

def convert_measure_fields(connection_settings, table, columns, unit, suffix):
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        if not postgres.table_exists(connection_settings, table):
            raise ValueError(f"Table {table.name} does not exist.")
        for column in columns:
            postgres.rename_column(connection_settings,
                                   postgres.Column(table, column),
                                   f"{column}{suffix}")
            postgres.add_column(connection_settings,
                                postgres.Column(table, column), "double")
            with connection.cursor() as cursor:
                query_string = load_snippet(
                    module=__name__,
                    resource=f"sql/convert_measure_fields_{unit}.sql")
                query = sql.SQL(query_string).format(
                    schema=sql.Identifier(table.schema.name),
                    table=sql.Identifier(table.name),
                    column=sql.Identifier(column),
                    source_column=sql.Identifier(f"{column}{suffix}"))
                with connection.cursor() as cursor:
                    cursor.execute(query)

def export_dimensional_data(connection_settings, table, continuity):
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        if not postgres.table_exists(connection_settings, table):
            raise ValueError(f"Table {table.name} does not exist.")
        # TODO: Add "continuous" setting, check for varieties...
        with connection.cursor() as cursor:
            query_string = load_snippet(
                module=__name__,
                resource=f"sql/export_dimensional_data_{continuity}.sql")
            query = sql.SQL(query_string).format(
                schema=sql.Identifier(table.schema.name),
                table=sql.Identifier(table.name))
            cursor.execute(query)
            data = cursor.fetchall()
    result = []
    for datum in data:
        bin = SizeBin(datum[0], datum[1], datum[2], datum[3])
        result.append(bin)
    return result

def export_to_data(export):
    data = []
    for record in export:
        data.append(record._to_row())
    return data
# 1
# 2
# 3
# 4
# 5
# Eclipse scrollbar...