import pkgutil
import psycopg
from psycopg import sql
import sys

sys.path.append("../squirrel")
import squirrel

def _load_snippet(function_name):
    query_bytes = pkgutil.get_data(__name__, f'sql/{function_name}.sql')
    query_string = query_bytes.decode()
    return query_string

def create_empty_bookstack(connection_settings, table):
    squirrel.check_connection_database(connection_settings, table.schema.database)
    with psycopg.connect(**connection_settings) as connection:
        if squirrel.table_exists(connection_settings, table):
            raise ValueError(f'{table.schema.name}.{table.name} already exists.')
        query_string = _load_snippet("create_empty_bookstack")
        query = sql.SQL(query_string).format(schema=sql.Identifier(table.schema.name),
                                             table=sql.Identifier(table.name))
        with connection.cursor() as cursor:
            cursor.execute(query)

def import_bookstack(connection_settings, librarything_export, table):
    with psycopg.connect(**connection_settings) as connection:
        if not squirrel.table_exists(connection_settings, table):
            raise ValueError(f'Table {table.name} does not exist.')
        with open(librarything_export, 'r') as librarything_export_file:
            with connection.cursor() as cursor:
                query_string = _load_snippet("import_bookstack")
                query = sql.SQL(query_string).format(schema=sql.Identifier(table.schema.name),
                                                     table=sql.Identifier(table.name))
                with cursor.copy(query) as copy:
                    while books := librarything_export_file.read(100):
                        copy.write(books)

def convert_measure_fields(connection_settings, table, columns, unit, suffix):
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        if not squirrel.table_exists(connection_settings, table):
            raise ValueError(f'Table {table.name} does not exist.')
        for column in columns:
            squirrel.rename_column(connection_settings, squirrel.Column(table, column), f"{column}{suffix}")
            squirrel.add_column(connection_settings, squirrel.Column(table, column), "double")
            with connection.cursor() as cursor:
                query_string = _load_snippet(f"convert_measure_fields_{unit}")
                query = sql.SQL(query_string).format(schema=sql.Identifier(table.schema.name),
                                                     table=sql.Identifier(table.name),
                                                     column=sql.Identifier(column),
                                                     source_column=sql.Identifier(f"{column}{suffix}"))
                with connection.cursor() as cursor:
                    cursor.execute(query)





# Eclipse scrollbar...