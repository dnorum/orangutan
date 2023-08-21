import pkgutil
import psycopg
from psycopg import sql
import sys

sys.path.append("../database")
import database as db

def _load_snippet(function_name):
    query_bytes = pkgutil.get_data(__name__, f'sql/{function_name}.sql')
    query_string = query_bytes.decode()
    return query_string

def create_empty_bookstack(connection_settings, table):
    db.check_connection_database(connection_settings, table.schema.database)
    with psycopg.connect(**connection_settings) as connection:
        if db.table_exists(connection_settings, table):
            raise ValueError(f'{table.schema.name}.{table.name} already exists.')
        query_string = _load_snippet("create_empty_bookstack")
        query = sql.SQL(query_string).format(schema=sql.Identifier(table.schema.name),
                                             table=sql.Identifier(table.name))
        with connection.cursor() as cursor:
            cursor.execute(query)

def import_bookstack(connection_settings, librarything_export, table):
    with psycopg.connect(**connection_settings) as connection:
        if not db.table_exists(connection_settings, table):
            raise ValueError(f'Table {table.name} does not exist.')
        with open(librarything_export, 'r') as librarything_export_file:
            with connection.cursor() as cursor:
                query_string = _load_snippet("import_bookstack")
                query = sql.SQL(query_string).format(schema=sql.Identifier(table.schema.name),
                                                     table=sql.Identifier(table.name))
                with cursor.copy(query) as copy:
                    while books := librarything_export_file.read(100):
                        copy.write(books)