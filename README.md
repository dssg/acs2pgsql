# Welcome to the acs2postgres repository.

### * This Project is Under Development *

This repository is designed to build and compile data from the American Community Survey and output the results in a PostgreSQL database.


## Configuration

### PostgreSQL Access

To run this module, you will need access to a PostgreSQL database. You must specify the secure connection parameters in the ACS_Profile file. Once you clone this repositiory, enter your PostgreSQL credentials in this file.

### State Specification

To download and build the tables for a specific state, you must modify the state specified in the acs_setup.sh file. Please enter both the full name and state abbreviation for your state.

*Examples*

```
#Nashville, Tennessee
state=Tennessee
state_initial=tn
city_geoid=US47037
```

```
# Austin, Texas
state=Texas
state_initial=tx
city_geoid=US48453
```

Note, that in both of these examples, the city geoid, begins with the letters 'US' and has five digits, the first two corresponding to the State FIPS code 47 or 48, and the last three, corresponding to the FIPS county code. You can alternatively specify the geoid for an entire Metropolitan Statistical Area (MSA) which often traverses multiple counties using the CBSA code. For Nashville, this would take the form:

```
#Nashville, Tennessee
state=Tennessee
state_initial=tn
city_geoid=34980
```

FIPS and CBSA Codes are available [here] (https://www.census.gov/population/metro/files/lists/2015/List1.xls).


## Dependencies

Python 3.4
Drake

## ACS Tables

Note that this script automatically inputs all of the ACS data for a specified state in the PostgreSQL database. It also creates a smaller PostgreSQL table with select variables found in the download.py file. Additional variables can be customized following the data key from [ACS] (http://www2.census.gov/programs-surveys/acs/summary_file/2014/documentation/user_tools/ACS_5yr_Seq_Table_Number_Lookup.txt). 
