# acs2pgsql
This repository imports American Community Survey (ACS) data into PostgreSQL. The hard work has already been done by [Census Reporter](https://github.com/censusreporter/census-postgres). We add the following features:

- Make the state (e.g. Illinois, California) a variable
- Fix [issues](https://github.com/censusreporter/census-postgres/issues?q=is%3Aissue%20is%3Aopen%202009) with the 2009 ACS 5-year data
- Run the workflow using [drake](https://github.com/factual/drake)

## Usage
1. Clone the repository and create the file `acs2pgsql/default_profile` by specifying PostgreSQL credentials and the desired U.S. State in the following template:
 ```
 PGHOST=
 PGDATABASE=
 PGUSER=
 PGPASSWORD=

 STATE=Illinois
 STATE_ABBREV=il
 ```

 If the state name has multiple words, remove the space: e.g. for North Carolina use `STATE=NorthCarolina`.

2. Change to the `acs2pgsql` directory and run `drake`.

 ```
 drake -w Drakefile
 ```

3. Consult the  [census-postgres](https://github.com/censusreporter/census-postgres) documentation for full technical details. See also the census documentation for each dataset, especially the:
 - Appendix (e.g. [2015](http://www2.census.gov/programs-surveys/acs/summary_file/2015/documentation/tech_docs/ACS_2015_SF_5YR_Appendices.xls)) for information about census tables, and the
 - Sequence Number and Table Number Lookup (e.g. [2015](http://www2.census.gov/programs-surveys/acs/summary_file/2015/documentation/user_tools/ACS_5yr_Seq_Table_Number_Lookup.txt)) for information about variables.

## TODO
 - Expand to Decennial and ACS 1yr and 3yr
 - Rename folders per state
