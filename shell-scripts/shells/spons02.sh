#!/bin/ksh
#
# Program Name	: spons02.sh
# Description   : CHANGE THE EF SWITCH TO EITHER Y OR N FOR THE PARAMATER
#                 FILE - SPONSORS        
#                 Command line arguments:
#		  -s Y|N - EF switch
#			(N - SHUTS EF OFF,  Y TURNS ON EF)
#                 -i <SPONS02PRM input file>
#                 -o <EFSPONSCSV output file>
#  N - SHUTS EF OFF,  Y TURNS ON EF
#                 
#                 
# Author	: Debbe Adgate 
# Date		: 09/13/2016
# Modifications : 09/23/2016 - updates for production version of script.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
DATETM=`date +%Y%m%d-%H%M%S`
LINK_SWITCH="null" 
RETVAL=0
INFILE_FLAG=0
OUTFILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: spons02.sh [-s ${LINK_SWITCH}]
	-s Y|N	(N - SHUTS EF OFF,  Y TURNS ON EF)  REQUIRED
	-i <input filename>			    OPTIONAL
        -o <output filename>			    OPTIONAL

ENDOFUSAGE
   exit 99  
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    IFS=${OLDIFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
        eval ${VAR} 2> /dev/null
        IFS=${EQUAL}
        set $VAR
        NVAR=$1
        export ${NVAR}
        if [ $? -ne 0 ]
        then
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

# Validate input switch
validate_link()
{  case ${LINK_SWITCH} in
     "Y" | "N")
	;;
     *) usage
	;;
   esac
}
	
	
# Submit spons02 program
submit_spons02()
{
      runcobol ${OBJ_DIR}/spons02 -a ${LINK_SWITCH}
	RETVAL=$?
}      


#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) shift     
        if [ $# -le 0 ]
        then
          usage
        fi 
	LINK_SWITCH=$1
	validate_link
        ;;
    -i) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	INFILE_FLAG=1
        INFILE=$1
	;;
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	OUTFILE_FLAG=1
        OUTFILE=$1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $INFILE_FLAG = 1 ]
then
	SPONS02PRM=$INFILE
else
	SPONS02PRM=/usr/lnk/wt/oper-wt/misc/EF-SPONSOR02PRM.txt             
fi
export SPONS02PRM

if [ $OUTFILE_FLAG = 1 ]
then
        EFSPONSCSV=$OUTFILE
else
       EFSPONSCSV=/usr/lnk/wt/oper-wt/misc/EFSPONSCSV-${DATETM}.txt
fi
export EFSPONSCSV

FG4AUD=$FG4AUD
  export FG4AUD


echo UPDATE SPONS00MAS TO TURN ON OR OFF EF SWITCH
date
echo "EXPORT PATHS:"
echo "   SPONS00MAS=$SPONS00MAS "
echo "   SPONS02PRM=$SPONS02PRM "
echo "   EFSPONSCSV=$EFSPONSCSV "
echo "   FG4AUD=$FG4AUD "
submit_spons02
date


exit $RETVAL
