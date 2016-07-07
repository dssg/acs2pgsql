# acs2postgres
This repository imports American Community Survey (ACS) data into PostgreSQL. The hard work has already been done by [Census Reporter](https://github.com/censusreporter/census-postgres). We add the following features:

- Make the state (e.g. Illinois, California) a variable
- Fix issues with the 2009 ACS 5-year data
- Run the workflow using [drake](https://github.com/factual/drake)

## Usage
1. Clone the repository and create the file `acs2postgres/default_profile` by specifying PostgreSQL credentials and the desired U.S. State in the following template:
 ```
 PGHOST=
 PGDATABASE=
 PGUSER=
 PGPASSWORD=
 
 STATE=Illinois
 STATE_ABBREV=il
 ```

2. Change to the `acs2postgres` directory and run `drake`. 

## TODO
 - Expand to Decennial and ACS 1yr and 3yr
 - Rename folders per state
