import psycopg
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

def extract_connection_settings(postgres):
    connection_settings = postgres
    # Rename database_name to dbname for psycopg compatibility.
    connection_settings["dbname"] = connection_settings["database_name"]
    # Remove unused entries. Note that this list isn't exhaustive, and this
    # function should be updated to be more simpatico with psycopg's API.
    keys = []
    for key in connection_settings:
        keys.append(key)
    for key in keys:
        if key not in ("host", "dbname", "user", "password"):
            del connection_settings[key]
    return connection_settings    

def database_exists(connection_settings, database):
    exists = False
    with psycopg.connect(**connection_settings) as connection:
        with connection.cursor() as cursor:
            query = ("SELECT EXISTS(SELECT datname FROM pg_database "
                     f"WHERE datname = '{database.name}')")
            cursor.execute(query)
            exists = cursor.fetchone()[0]
    return exists

def schema_exists(connection_settings, schema):
    exists = False
    with psycopg.connect(**connection_settings) as connection:
        if not connection_settings["dbname"] == schema.database.name:
            raise ValueError(f'Connected to database '
                             f'{connection_settings.dbname} but looking for '
                             f'schema {schema.name} in database '
                             f'{schema.database.name}.')
        # QUESTION: Given above, do I need this? Is this issue even possible?
        if not database_exists(connection_settings, schema.database):
            raise ValueError(f'Database {schema.database.name} does not exist.')
        with connection.cursor() as cursor:
            query = ("SELECT EXISTS(SELECT schema_name "
                     "FROM information_schema.schemata "
                     f"WHERE schema_name = '{schema.name}');")
            cursor.execute(query)
            exists = cursor.fetchone()[0]
    return exists

def table_exists(connection_settings, table):
    exists = False
    with psycopg.connect(**connection_settings) as connection:
        if not schema_exists(connection_settings, table.schema):
            raise ValueError(f'Schema {table.schema.name} does not exist.')
        with connection.cursor() as cursor:
            query = ("SELECT EXISTS(SELECT table_name "
                     "FROM information_schema.tables "
                     f"WHERE table_schema = '{table.schema.name}'"
                     f"AND table_name = '{table.name}');")
            cursor.execute(query)
            exists = cursor.fetchone()[0]
    return exists

def validate_identifier(identifier):
    # Note that this is close to, but not identical to the PostgreSQL standard.
    # Since the goal is to provide a belt-and-suspenders guard against injection
    # (unintentional or otherwise), this function is stricter about allowable
    # characters, but does _not_ check against reserved keywords.
    format_string = '[A-Za-z_][A-Za-z0-9_]{,62}'
    format = re.compile(format_string)
    if not re.fullmatch(format, identifier):
        raise ValueError(f"Identifier: '{identifier}' violates format "
                         f"requirement: /{format_string}/")
    return 0

def create_database(connection_settings, database):
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            if database_exists(connection_settings, database):
                raise ValueError(f"Database '{database.name}' already exists.")
            else:
                # PostgreSQL doesn't allow parameterizing CREATE DATABASE, so
                # we check the database name manually.
                validate_identifier(database.name)
                query = f"CREATE DATABASE {database.name};"
                # QUESTION: Additional check here, maybe?
                cursor.execute(query)
    return 0

def create_schema(connection_settings, schema):
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            if schema_exists(connection_settings, schema):
                raise ValueError(f"Schema '{schema.name}' already exists.")
            else:
                # PostgreSQL doesn't allow parameterizing CREATE SCHEMA, so
                # we check the schema name manually.
                validate_identifier(schema.name)
                query = f"CREATE SCHEMA {schema.name};"
                # QUESTION: Additional check here, maybe?
                cursor.execute(query)
    return 0