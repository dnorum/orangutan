import json
import jsonmerge

def load_json_configurations(files):
    configuration = json.loads("{}")
    for file in files:
        with open(file) as json_file:
            json_configuration = json.load(json_file)
        configuration = jsonmerge.merge(configuration, json_configuration)
    return configuration