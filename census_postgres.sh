#!/bin/bash
src="$1"
datadir="$2"
out="$3"

schema=$(basename $out)

mkdir -p $out
cp -r $src/* $out

edir=$(echo $datadir/ | sed 's/\//\\\//g')
grep 'group1/[em][0-9]*5il' $out/import_sequences.sql | sed "s/'.*\/group1\//'"$edir"/g;s/COPY/\\\COPY/g" > $out/import_sequences_il.sql

grep 'g[0-9]*5il.txt' $out/import_geoheader.sql | head -n1 | sed "s/'.*\/\(g[0-9]*5il.txt\)/'"$edir\\1"/g;s/COPY/\\\COPY/g" > $out/import_geoheader_il.sql

echo "
drop schema if exists $schema cascade;
create schema $schema;
SET search_path = $schema, public;

\i $out/create_tmp_geoheader.sql
\i $out/create_import_tables.sql
\i $out/create_tmp_geoheader.sql

\i $out/import_sequences_il.sql
\i $out/import_geoheader_il.sql

\i $out/create_geoheader.sql
\i $out/parse_tmp_geoheader.sql
\i $out/store_by_tables.sql
\i $out/insert_into_tables.sql
\i $out/view_stored_by_tables.sql

\i $out/drop_import_tables.sql
" > $out/import.sql

if [[ "$schema" == 'acs2009_5yr' ]]; then

# insert geoids for all tables after first one
sed -i.bak '9,$ s/logrecno int,/logrecno int, geoid varchar(40),/g' $out/store_by_tables.sql 

# use alias s for tmp_seq tables
sed -i.bak "s/\(FROM acs2009_5yr.tmp_seq[0-9]*\(_moe\)\?\)/\\1 s/g" $out/insert_into_tables.sql 

# use those aliases
sed -i.bak "s/\(fileid\|filetype\|stusab\|chariter\|seq,\|logrecno\)/s.\\1/g" $out/insert_into_tables.sql
sed -i.bak "s/\(NULLIF(NULLIF(\)/\\1s./g" $out/insert_into_tables.sql
sed -i.bak "s/JOIN .*/JOIN acs2009_5yr.geoheader g ON (lower(s.stusab)=lower(g.stusab) AND s.logrecno=g.logrecno);/g" $out/insert_into_tables.sql

# use schema for tables
sed -i.bak 's/tmp_seq/acs2009_5yr.tmp_seq/g' $out/import_sequences.sql 

# missing character encoding
sed -i.bak 's/;/ WITH ENCODING '\'latin1\'';/g' $out/import_geoheader_il.sql

# join using geoid
sed -i.bak 's/USING (stusab, logrecno)/USING (geoid)/g' $out/view_stored_by_tables.sql

# add missing joins for tables that span multiple sequences
gen()
{
    old='FROM acs2009_5yr.'${seqs[0]}';'
    new="FROM "$(echo ${seqs[@]} | sed "s/\([a-z0-9_\.]*\)/ JOIN \1 USING (geoid) /2g")";"
    sed -i.bak "s/$old/$new/" $out/view_stored_by_tables.sql

    old='FROM acs2009_5yr.'${seqs[0]}' JOIN '${seqs[0]}'_moe USING (geoid);'
    new="FROM "$(echo ${seqs[@]} | sed "s/\([a-z0-9_\.]*\)/ JOIN \1 USING (geoid) /2g")
    new_moe=" "$(echo ${seqs[@]} | sed "s/\([a-z0-9_\.]*\)/ JOIN \1_moe USING (geoid) /g")";"
    sed -i.bak "s/$old/$new$new_moe/" $out/view_stored_by_tables.sql
}

seqs=('seq0080' 'seq0079' 'seq0078')
gen

seqs=('seq0083' 'seq0082' 'seq0081')
gen

seqs=('seq0086' 'seq0085' 'seq0084')
gen

seqs=('seq0089' 'seq0088' 'seq0087')
gen

seqs=('seq0092' 'seq0091' 'seq0090')
gen

seqs=('seq0095' 'seq0094' 'seq0093')
gen

# delete duplicate table views
sed -i.bak '46523,$d' $out/view_stored_by_tables.sql

fi
