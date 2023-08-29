import pkgutil
import psycopg
from psycopg import sql
import re

class Database:
    def __init__(self, name):
        self.name = name

class Schema:
    def __init__(self, database, name):
        self.database = database
        self.name = name

class Table:
    def __init__(self, schema, name):
        self.schema = schema
        self.name = name

class Column:
    def __init__(self, table, name):
        self.table = table
        self.name = name

def _load_snippet(function_name):
    query_bytes = pkgutil.get_data(__name__, f'sql/{function_name}.sql')
    query_string = query_bytes.decode()
    return query_string

def check_connection_database(connection_settings, database):
    if not connection_settings["dbname"] == database.name:
        raise ValueError(f'Database {database.name} specified, but connected '
                         f'to {connection_settings["dbname"]}.')

def extract_connection_settings(postgres):
    connection_settings = {}
    for key in postgres:
        if key in ("host", "database_name", "user", "password"):
            connection_settings[key] = postgres[key]
    # Rename database_name to dbname for psycopg compatibility.
    connection_settings["dbname"] = connection_settings["database_name"]
    del connection_settings["database_name"]
    return connection_settings    

def database_exists(connection_settings, database):
    exists = False
    with psycopg.connect(**connection_settings) as connection:
        with connection.cursor() as cursor:
            query_string = _load_snippet("database_exists")
            query = sql.SQL(query_string).format(database=sql.Literal(database.name))
            cursor.execute(query)
            exists = cursor.fetchone()[0]
    return exists

def schema_exists(connection_settings, schema):
    # Removes need for checking if database exists.
    check_connection_database(connection_settings, schema.database)
    exists = False
    with psycopg.connect(**connection_settings) as connection:
        with connection.cursor() as cursor:
            query_string = _load_snippet("schema_exists")
            query = sql.SQL(query_string).format(schema=sql.Literal(schema.name))
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
                query_string = _load_snippet("table_exists")
                query = sql.SQL(query_string).format(schema=sql.Literal(table.schema.name),
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
                query_string = _load_snippet("column_exists")
                query = sql.SQL(query_string).format(schema=sql.Literal(column.table.schema.name),
                                                     table=sql.Literal(column.table.name),
                                                     column=sql.Literal(column.name))
                cursor.execute(query)
                exists = cursor.fetchone()[0]
    return exists

def create_database(connection_settings, database):
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            if database_exists(connection_settings, database):
                raise ValueError(f"Database '{database.name}' already exists.")
            else:
                query_string = _load_snippet("create_database")
                query = sql.SQL(query_string).format(database=sql.Identifier(database.name))
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
                query_string = _load_snippet("create_schema")
                query = sql.SQL(query_string).format(schema=sql.Identifier(schema.name))
                cursor.execute(query)
    return 0

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

def add_column(connection_settings, column, type):
    check_connection_database(connection_settings, column.table.schema.database)
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            if column_exists(connection_settings, column):
                raise ValueError(f"Column '{column.name}' already exists.")
            else:
                query_string = _load_snippet(f"add_{type}_column")
                query = sql.SQL(query_string).format(schema=sql.Identifier(column.table.schema.name),
                                                     table=sql.Identifier(column.table.name),
                                                     column=sql.Identifier(column.name))
                cursor.execute(query)
    return 0





# Eclipse scrollbar...