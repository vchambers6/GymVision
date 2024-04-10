
import pandas
import json



excel_data_frame = pandas.read_excel('uneven_bars_cop.xlsx', sheet_name='UB')

def parse_named_after(value):
    try:
        if pandas.notnull(value) and isinstance(value, str):
            return json.loads(value.replace("'", '"'))
        else:
            return None
    except json.JSONDecodeError:
        return None


excel_data_frame['named_after_wag'] = excel_data_frame['named_after_wag'].apply(parse_named_after)
excel_data_frame['named_after_mag'] = excel_data_frame['named_after_mag'].apply(parse_named_after)

json_content = excel_data_frame.to_json(orient='records', lines=True)


json_objects = json_content.strip().split('\n')
parsed_json_objects = []

for obj in json_objects:
    data = json.loads(obj)
    parsed_json_objects.append(data)


with open('uneven_bars_output.json', 'w') as file:
    json.dump(parsed_json_objects, file, indent=2)
