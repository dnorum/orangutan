import psycopg
import re

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

def database_exists(connection_settings, database_name):
    exists = False
    with psycopg.connect(**connection_settings) as connection:
        with connection.cursor() as cursor:
            query = ("SELECT EXISTS(SELECT datname FROM pg_database "
                     f"WHERE datname = '{database_name}')")
            cursor.execute(query)
            exists = cursor.fetchone()[0]
    return exists

def schema_exists(connection_settings, database_name, schema_name):
    exists = False
    with psycopg.connect(**connection_settings) as connection:
        if not database_exists(connection_settings, database_name):
            raise ValueError(f'Database {database_name} does not exist.')
        with connection.cursor() as cursor:
            query = ("SELECT EXISTS(SELECT schema_name "
                     "FROM information_schema.schemata "
                     f"WHERE schema_name = '{schema_name}');")
            cursor.execute(query)
            exists = cursor.fetchone()[0]
    return exists

def table_exists(connection_settings, database_name, schema_name, table_name):
    exists = False
    with psycopg.connect(**connection_settings) as connection:
        if not schema_exists(connection_settings, database_name, schema_name):
            raise ValueError(f'Schema {schema_name} does not exist.')
        with connection.cursor() as cursor:
            query = ("SELECT EXISTS(SELECT table_name "
                     "FROM information_schema.tables "
                     f"WHERE table_schema = '{schema_name}'"
                     f"AND table_name = '{table_name}');")
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

def create_database(connection_settings, database_name):
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            if database_exists(connection_settings, database_name):
                raise ValueError(f"Database '{database_name}' already exists.")
            else:
                # PostgreSQL doesn't allow parameterizing CREATE DATABASE, so
                # we check the database name manually.
                validate_identifier(database_name)
                query = f"CREATE DATABASE {database_name};"
                # QUESTION: Additional check here, maybe?
                cursor.execute(query)
    return 0

def create_schema(connection_settings, database_name, schema_name):
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            if schema_exists(connection_settings, database_name, schema_name):
                raise ValueError(f"Schema '{schema_name}' already exists.")
            else:
                # PostgreSQL doesn't allow parameterizing CREATE SCHEMA, so
                # we check the schema name manually.
                validate_identifier(schema_name)
                query = f"CREATE SCHEMA {schema_name};"
                # QUESTION: Additional check here, maybe?
                cursor.execute(query)
    return 0