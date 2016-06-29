#!/bin/bash


##########################################################################
## ----------------- Input Desired State for ACS Data ----------------- ##
##########################################################################

#state = <spell out entire state, capital first letter>
#state_initial <state initial's, lowercase>

#example

state=Tennessee
state_initial=tn
city_geoid=US47037


##########################################################################
## --------------------- USER DO NOT MODIFY BELOW --------------------- ##
##########################################################################

echo "Selected State and Location:"
echo $state, $state_initial, $city_geoid

#Write Python Script
rm config.py || :
#touch config.py || rm config.py
echo "#! /usr/bin/python" >> config.py
echo "STATE = '`echo $state`'" >> config.py
echo "STATE_INITIAL = '`echo $state_initial`'" >> config.py
echo "CITY_ID = '`echo $city_geoid`'" >> config.py

#Write Shell Script
rm config.sh || :
#touch config.sh || rm config.sh
echo "#!/bin/bash" >> config.sh
echo "STATE=`echo $state`" >> config.sh
echo "STATE_INITIAL=`echo $state_initial`" >> config.sh


#Make Scripts Executable
echo "Making Scripts Executable..."
chmod +x config.py
chmod +x config.sh
chmod +x input/acs/util.py
chmod +x input/acs/import.py
chmod +x input/acs/download.py
chmod +x input/acs/census_postgres.sh


#Setup Initial File Structure
#mkdir input && cd input && mkdir acs || :


echo "Setup complete...you are now clear to Drake."
