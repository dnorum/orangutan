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
# 1
# 2
# 3
# 4
# 5
# Eclipse scrollbar...