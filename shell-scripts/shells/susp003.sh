#!/bin/ksh
#
# Program Name	: susp003.sh
# Description   : Paid claims by Paid Date listing
#                 Command line arguments:
#                 -i Type of grouping (spo,grp,alt,mas)              
#		  -p print flag - Set to create print file
#		  -s <####> - System number
#                 -d Set paid date for printing done claims <mmddccyy>
#                 -c User class <A,B,C,D>
#                 -u Username
# Author	: Debbie Wilson            
# Date		: 09/12/00
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FORMAT="null"
SYS="0000"
DATE="00000000"
USER="null"
USERCLASS="null"
PRT=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: susp003.sh [-i spo|grp|alt|mas] [-p] [-s <####>] [-d <mmddccyy>] [-c <userclass>] [-u <username>]

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


# Submit susp003 program
submit_susp003()
{
   if [ ${FORMAT} = "null" ]
   then
     usage
   else
     case ${FORMAT} in
       "spo")
            runcobol ${OBJ_DIR}/susp003 -s 01000${PRT} -a ${SYS}${DATE}${USERCLASS}${USER}'           '
          ;;
       "grp")
            runcobol ${OBJ_DIR}/susp003 -s 00100${PRT} -a ${SYS}${DATE}${USERCLASS}${USER}'           '
          ;;
       "alt")
            runcobol ${OBJ_DIR}/susp003 -s 00010${PRT} -a ${SYS}${DATE}${USERCLASS}${USER}'           '
          ;;
       "mas")
            runcobol ${OBJ_DIR}/susp003 -s 00001${PRT} -a ${SYS}${DATE}${USERCLASS}${USER}'           '
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
    -s) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	SYS=$1
	;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
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

echo "Paid Claims by Paid Date"                    
date
echo

# Submit the program
submit_susp003 

date

exit 0
