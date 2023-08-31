import pkgutil

def load_snippet(resource, module):
    snippet_bytes = pkgutil.get_data(module, f'{resource}')
    snippet = snippet_bytes.decode()
    return snippet
# 1
# 2
# 3
# 4
# 5
# Eclipse scrollbar...