import pkgutil
import psycopg
import sys

sys.path.append("../database")
import database as db


def create_empty_bookstack(connection_settings, schema):
    with psycopg.connect(**connection_settings) as connection:
        if not db.schema_exists(connection_settings, schema):
            raise ValueError(f'Schema {schema.name} does not exist.')
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