import pkgutil
import psycopg
import sys

sys.path.append("../database")
import database as db


def create_empty_bookstack(connection_settings, schema):
    db.check_connection_database(connection_settings, schema.database)
    with psycopg.connect(**connection_settings) as connection:
        if db.table_exists(connection_settings, db.Table(schema, "bookstack")):
            raise ValueError(f'{schema.name}.bookstack already exists.')
        db.validate_identifier(schema.name)
        query_bytes = pkgutil.get_data(__name__,
                                       "sql/create_empty_bookstack.sql")
        query = query_bytes.decode()
        parameters = {"schema_name": schema.name}
        # Ugh... Can't parameterize schemata names...
        query = query.format(**parameters)
        with connection.cursor() as cursor:
            cursor.execute(query)

def import_bookstack(connection_settings, librarything_export, table):
    with psycopg.connect(**connection_settings) as connection:
        if not db.table_exists(connection_settings, table):
            raise ValueError(f'Table {table.name} does not exist.')
        db.validate_identifier(table.schema.name)
        db.validate_identifier(table.name)
        with open(librarything_export, 'r') as librarything_export_file:
            with connection.cursor() as cursor:
                # Assumes current default TSV format.
                with cursor.copy("COPY library.bookstack FROM STDIN WITH(FORMAT CSV, HEADER)") as copy:
                    while books := librarything_export_file.read(100):
                        copy.write(books)