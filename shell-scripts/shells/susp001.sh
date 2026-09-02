#!/bin/ksh
#
# Program Name	: susp001.sh
# Description   : Outstanding Suspended claims listing
#                 Command line arguments:
#                 -i Type of grouping (spo,grp,alt,mas)              
#		  -p print flag - Set to create print file
#                 -r To be released listing
#		  -s <####> - System number
#                 -c User class <A,B,C,D>
#                 -u Username
# Author	: Debbie Wilson            
# Date		: 01/20/00
# Modifications : 02/08/2000 - Changed submit_susp001 section  (LSJ)
#		: 03/22/2000 - Added logic for Master group print option  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FORMAT="null"
RELEASE=0      
SYS="0000"
USER="null"
USERCLASS="null"
PRT=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: susp001.sh [-i spo|grp|alt|mas] [-p] [-r] [-s <####>] [-c <userclass>] [-u <username>]

ENDOFUSAGE
  exit 1
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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#
# Validate -i options
validate_format()
{  case ${FORMAT} in
     "spo" | "grp" | "alt" | "mas")
			  ;;
     *)  usage
	 ;;
   esac
}

#
# Validate -c options
validate_userclass()
{  case ${USERCLASS} in
     "A" | "B" | "C" | "D" )
                          ;;
     *)  usage
         ;;
   esac
}


# Submit susp001 program
submit_susp001()
{
   if [ ${FORMAT} = "null" ]
   then
     usage
   else
     case ${FORMAT} in
       "spo")
            runcobol ${OBJ_DIR}/susp001 -s ${RELEASE}1000${PRT} -a ${SYS}${USERCLASS}${USER}'           '
          ;;
       "grp")
            runcobol ${OBJ_DIR}/susp001 -s ${RELEASE}0100${PRT} -a ${SYS}${USERCLASS}${USER}'           '
          ;;
       "alt")
            runcobol ${OBJ_DIR}/susp001 -s ${RELEASE}0010${PRT} -a ${SYS}${USERCLASS}${USER}'           '
          ;;
       "mas")
            runcobol ${OBJ_DIR}/susp001 -s ${RELEASE}0001${PRT} -a ${SYS}${USERCLASS}${USER}'           '
     esac
   fi
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FORMAT=$1
        validate_format
        ;;
    -p) PRT=1
	;;
    -r) RELEASE=1
        ;;
    -s) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	SYS=$1
	;;
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        USERCLASS=$1
        validate_userclass
        ;;
    -u) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        USER=$1
        ;;

  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Outstanding Suspended Claims"
date
echo

# Submit the program
submit_susp001 

date

exit 0
