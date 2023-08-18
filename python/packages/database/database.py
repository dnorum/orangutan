import psycopg
import re

def database_exists(connection, database_name):
    exists = False
    try:
        with connection.cursor() as cursor:
            query = "SELECT EXISTS(SELECT datname FROM pg_database WHERE datname = '" + database_name + "')"
            cursor.execute(query)
            exists = cursor.fetchone()[0]
    except psycopg.Error as error:
        print(error)
    return exists

def schema_exists(connection, database_name, schema_name):
    exists = False
    return exists

def table_exists(connection, database_name, schema_name, table_name):
    exists = False
    return exists

def validate_identifier(identifier):
    # Note: This is close to, but not exactly what's defined in the PostgreSQL standard -
    # since the goal is to belt-and-suspenders against injection (unintentional or otherwise),
    # it clamps down on allowable characters, but does _not_ check for reserved keywords.
    format_string = '[A-Za-z_][A-Za-z0-9_]{,62}'
    format = re.compile(format_string)
    if not re.fullmatch(format, identifier):
        raise ValueError('Identifier: "' + identifier + '" violates format requirement: /' + format_string + '/')
    return 0

def create_database(connection_settings, database_name):
    with psycopg.connect(**connection_settings) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            if not database_exists(connection, database_name):
                # PostgreSQL doesn't allow for parameterization of CREATE DATABASE, so check the database name
                # manually.
                validate_identifier(database_name)
                query = "CREATE DATABASE " + database_name + ";"
                # QUESTION: Additional check here, maybe?
                cursor.execute(query)
            else:
                print("Database {database_name} already exists.".format(**{'database_name': database_name}))