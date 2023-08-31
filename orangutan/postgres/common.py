import pkgutil

def _load_snippet(function_name):
    query_bytes = pkgutil.get_data(__name__, f'sql/{function_name}.sql')
    query_string = query_bytes.decode()
    return query_string





# Eclipse scrollbar...