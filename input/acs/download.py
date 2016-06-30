#! /usr/bin/python
import pandas as pd
import numpy as np
import util
import sys

#sys.path.append('../Python_Scripts/')
sys.path.append('../..')

from config import STATE
from config import STATE_INITIAL
from config import CITY_ID
print (STATE, STATE_INITIAL, CITY_ID)


#SQL Select Statement to Filter for Specified City
statement = """
        select geoid, {fields} from acs{year}_5yr.{table}
        where geoid ~ """+"'"+CITY_ID+"'"

print (statement)

def read_acs(table, columns, engine, offsets={0:{}}, years=range(2009, 2015)):
    try:
        select=statement
    except:
        print "Error: Statement"
        select = """
            select geoid, {fields} from acs{year}_5yr.{table}
            where geoid ~ 'US47037'
        """

    column_names = ['geoid']
    column_names.extend(columns.keys())

    dfs = []
    for year in years:
        for i, attrs in offsets.iteritems():
            offset = [c + i for c in columns.values()]
            cols = map( (lambda x: "{0}{1:03d}".format(table, x)), offset)
            s = select.format(fields=str.join(',', cols), year=year, table=table)
            df = pd.read_sql(s, engine)
            df.columns = column_names
            for attr in attrs:
                df[attr] = attrs[attr]
            df['year'] = year
            dfs.append(df)
    df = pd.concat(dfs)

    return df

# simple sum-aggregation of columns starting with prefix over index
def aggregate(df, prefix, index):
    return df.groupby(index).agg({c: 'sum' for c in df.columns if c.startswith(prefix)})

engine = util.create_engine()
index = ['geoid','year']

race_table='C02003'
race_columns = {
    'race_count_total': 1,
    'race_count_white': 3,
    'race_count_black': 4,
    'race_count_asian': 6
}
race_agg = read_acs(race_table, race_columns, engine)
race_agg.set_index(index, inplace=True)

hispanic_table = 'B03003'
hispanic_columns = {
    'race_count_hispanic': 3
}
hispanic_agg = read_acs(hispanic_table, hispanic_columns, engine)
hispanic_agg.set_index(index, inplace=True)

poverty_table = 'B17010'
poverty_columns = {
    'family_count_total': 1,
    'family_count_poverty': 2
}
poverty_agg = read_acs(poverty_table, poverty_columns, engine)
poverty_agg.set_index(index, inplace=True)

edu_table = 'B15001'
edu_columns = {
    'edu_count_total':3,
    'edu_count_9th': 4,
    'edu_count_12th': 5,
    'edu_count_hs': 6,
    'edu_count_some_college': 7,
    'edu_count_associates': 8,
    'edu_count_ba': 9,
    'edu_count_advanced': 10,
}
edu_offsets = {
    0: {'sex':'male', 'age':'18-24'},
    8: {'sex':'male', 'age':'25-34'},
    16: {'sex':'male', 'age':'34-44'},
    24: {'sex':'male', 'age':'45-64'},
    32: {'sex':'male', 'age':'65+'},

    41: {'sex':'female', 'age':'18-24'},
    49: {'sex':'female', 'age':'25-34'},
    57: {'sex':'female', 'age':'34-44'},
    65: {'sex':'female', 'age':'45-64'},
    73: {'sex':'female', 'age':'65+'},
}

edu = read_acs(edu_table, edu_columns, engine, edu_offsets)
edu_agg = aggregate(edu, prefix='edu', index=index)

# HEALTH INSURANCE
years=[2012,2013,2014]

health_table='B27001'
health_columns={
    'health_count_total': 0,
    'health_count_insured':1,
    'health_count_uninsured':2
}
health_offsets = {
    3: {'sex':'male', 'age': '<6'},
    6: {'sex':'male', 'age': '6-17'},
    9: {'sex':'male', 'age': '18-24'},
    12: {'sex':'male', 'age': '25-34'},
    15: {'sex':'male', 'age': '35-44'},
    18: {'sex':'male', 'age': '45-54'},
    21: {'sex':'male', 'age': '55-64'},
    24: {'sex':'male', 'age': '65-74'},
    27: {'sex':'male', 'age': '74+'},
    31: {'sex':'female', 'age': '<6'},
    34: {'sex':'female', 'age': '6-17'},
    37: {'sex':'female', 'age': '18-24'},
    40: {'sex':'female', 'age': '25-34'},
    43: {'sex':'female', 'age': '35-44'},
    46: {'sex':'female', 'age': '45-54'},
    49: {'sex':'female', 'age': '55-64'},
    52: {'sex':'female', 'age': '65-74'},
    55: {'sex':'female', 'age': '74+'},
}
health = read_acs(health_table, health_columns, engine, health_offsets, years)
health_agg = aggregate(health, prefix='health', index=index)

insurance_offsets = {
    3: {'sex':'male', 'age':'<18'},
    6: {'sex':'male', 'age':'18-64'},
    9: {'sex':'male', 'age':'65+'},
    13: {'sex':'female', 'age':'<18'},
    16: {'sex':'female', 'age':'18-64'},
    19: {'sex':'female', 'age':'65+'},
}
insurances = ['employer', 'purchase', 'medicare', 'medicaid', 'military', 'veteran']
insurance = pd.DataFrame(columns=['geoid', 'year', 'sex', 'age'])
for i in range(len(insurances)):
    health_insurance_table = 'C2700' + str(4+i)
    health_insurance_columns={
        'health_count_insured_' + insurances[i]: 1,
    }

    df = read_acs(health_insurance_table, health_insurance_columns, engine, insurance_offsets, years)
    insurance = insurance.merge(df, on=['geoid', 'year', 'sex', 'age'], how='outer')

insurance_agg = aggregate(insurance, prefix='health', index=index)

# TENURE
tenure_table='B11012'
tenure_columns={
    'tenure_count_total': 0,
    'tenure_count_owner': 1,
    'tenure_count_renter': 2
}
tenure_offsets = {
    3: {'family_type': 'married'},
    7: {'family_type': 'male'},
    10: {'family_type': 'female'}
}

tenure = read_acs(tenure_table, tenure_columns, engine, tenure_offsets)
tenure_agg = aggregate(tenure, prefix='tenure', index=index)



acs = tenure_agg.join((insurance_agg, health_agg, edu_agg, poverty_agg, race_agg, hispanic_agg), how='outer')
acs.reset_index(inplace=True)
acs['census_tract_id']=acs['geoid'].apply(lambda g: float(g[7:]))
acs.drop('geoid', axis=1, inplace=True)
acs.to_csv(sys.argv[1], index=False)
