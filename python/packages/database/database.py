import psycopg

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