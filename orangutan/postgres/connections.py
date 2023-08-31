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





# Eclipse scrollbar...