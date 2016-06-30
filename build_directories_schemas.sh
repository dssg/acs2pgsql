#!/usr/bin/env bash

# input is department name
DEPT=$1

# load database credentials (stored in $DEPT_profile)
eval $(cat "$DEPT"_profile | sed 's/^/export /')

# create directories on analytics server
cat input/Drakefile_"$DEPT" | grep -E "(^data/|^psql/)" | cut -d ' ' -f1 |
parallel 'dirname {} | xargs mkdir -p'

# create schema on postgres server
cat input/Drakefile_"$DEPT" | grep -E "^psql/" | cut -d '/' -f4 |
tr [:upper:] [:lower:] | sort | uniq |
parallel 'echo "create schema if not exists {};" | psql -f-'
