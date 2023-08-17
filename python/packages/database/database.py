import psycopg
import re

def databaseExists(connection, dbName):
    exists = False
    try:
        with connection.cursor() as cursor:
            query = "SELECT EXISTS(SELECT datname FROM pg_database WHERE datname = '" + dbName + "')"
            cursor.execute(query)
            exists = cursor.fetchone()[0]
    except psycopg.Error as error:
        print(error)
    return exists

def validateIdentifier(identifier):
    # Note: This is close to, but not exactly what's defined in the PostgreSQL standard -
    # since the goal is to belt-and-suspenders against injection (unintentional or otherwise),
    # it clamps down on allowable characters, but does _not_ check for reserved keywords.
    formatString = '[A-Za-z_][A-Za-z0-9_]{,62}'
    format = re.compile(formatString)
    if not re.fullmatch(format, identifier):
        raise ValueError('Identifier: "' + identifier + '" violates format requirement: /' + formatString + '/')
    return 0

def createDatabase(connectionSettings, dbName):
    with psycopg.connect(**connectionSettings) as connection:
        connection.autocommit = True
        with connection.cursor() as cursor:
            if not databaseExists(connection, dbName):
                # PostgreSQL doesn't allow for parameterization of CREATE DATABASE, so check the database name
                # manually.
                validateIdentifier(dbName)
                query = "CREATE DATABASE " + dbName + ";"
                # QUESTION: Additional check here, maybe?
                cursor.execute(query)
            else:
                print("Database {dbName} already exists.".format(**{'dbName': dbName}))