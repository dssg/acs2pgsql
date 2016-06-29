#!/bin/bash


##########################################################################
## ----------------- Input Desired State for ACS Data ----------------- ##
##########################################################################

#state = <spell out entire state, capital first letter>
#state_initial <state initial's, lowercase>

#example

state=Tennessee
state_initial=tn

##########################################################################



echo $state
echo $state_initial

#Write Python Script
echo "#! /usr/bin/python" >> config.py
echo "STATE = `echo $state`" >> config.py
echo "STATE_INITIAL = `echo $state_initial`" >> config.py

#Write Shell Script
echo "#!/bin/bash" >> config.sh
echo "STATE = `echo $state`" >> config.sh
echo "STATE_INITIAL = `echo $state_initial`" >> config.sh

#


#Make Scripts Executable
chmod +x config.py
chmod +x config.sh

chmod +x input/acs/import.py
chmod +x input/acs/download.py
chmod +x input/acs/census_postgres.sh




#Setup Initial File Structure
mkdir input && cd input && mkdir acs || :
#cd input
#mkdir acs || :
