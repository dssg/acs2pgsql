#! /usr/bin/python
import pandas as pd
import util
import sys

acs = pd.read_csv(sys.argv[1], dtype= {'census_tract_id':float})
engine = util.create_engine()
acs.to_sql(name='acs', con=engine, if_exists='replace', index=False)
