# Welcome to the ACS2POSTGRES Repository

### * This Project is Under Development *

This repository is designed to build and compile data from the American Community Survey and output the results in a PostgreSQL database.


## Configuration

### PostgreSQL Access

To run this module, you will need access to a PostgreSQL database. You must specify the secure connection parameters in the ACS_Profile file. Once you clone this repositiory, enter your PostgreSQL credentials in this file.

### State Specification

To download and build the tables for a specific state, you must modify the state specified in the acs_setup.sh file. Please enter both the full name and state abbreviation for your state.

## Dependencies

Python 3.4
Drake

## ACS Tables

Note that this script automatically inputs all of the ACS data for a specified state in the PostgreSQL database. It also creates a smaller PostgreSQL table with select variables found in the download.py file. Additional variables can be customized following the data key from ACS:

(http://www2.census.gov/programs-surveys/acs/summary_file/2014/documentation/user_tools/ACS_5yr_Seq_Table_Number_Lookup.txt)
