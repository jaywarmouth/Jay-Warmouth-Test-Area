#!/bin/sh
#
# Program Name	: claim111rx.sh
# Description   : Claims to Tape Transfer for RXEOB
#                 Command line arguments:
#                 -s Skip sort flag
#                 -c Type of cycle (pay,mon,day,week,qrt,twice,tweek)
#                 -f <filename> (set different CLAIM00MAS)
# Author	:Mike Paulus       
# Date		: 11/28/2007
# Modifications : 11/2/2010 - Changes for tweek cycle  (LSJ) 
#		: 12/19/2018 - TT18987-70; CYCLERRS logic
#		: 06/04/2019 - Remove CYCLERR assignements
#	                                         
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
FILE_FLAG=0
CYCLE="null"
PAY=0
MON=0
DAY=0
WEEK=0
TWICE=0
QRT=0
TWEEK=0
DATETM=`date +%Y%m%d_%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim111rx.sh [-c pay,mon,week,day,qrt,twice,tweek] [-s] [-f <filename>] 
	-c pay|mon|day|week|twice|tweek|qrt   type of cycle run (required)
	-s		 skip sort flag (optional)
	-f filename	 to use optional input claims file (optional)

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
# Validate -c options
validate_cycle()
{  case ${CYCLE} in
     "pay")
	PAY=1
	;;
     "day")
	DAY=1
	;;
     "mon")
	MON=1
	;;
     "twice")
        TWICE=1
        ;;
     "qrt")
        QRT=1
        ;;
     "week")
        WEEK=1
        ;;
     "tweek")
        TWEEK=1
        ;;
     *)  usage
         ;;
   esac
}


# Submit claim111rx program
submit_claim111rx()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
        runcobol ${OBJ_DIR}/claim111rx -s ${SKIP_SORT}${PAY}${MON}${WEEK}${DAY}${QRT}${TWICE}${TWEEK} 
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
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CYCLE=$1
	validate_cycle
        ;;
    -s) SKIP_SORT=1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1 
        FILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if  [ $PAY = 1 ]
then
   CLAIM111RXKEY=${CLAIM111RXKEY}-P
fi
if  [ $DAY = 1 ]
then
   CLAIM111RXKEY=${CLAIM111RXKEY}-D
fi
if  [ $TWICE = 1 ]
then
   CLAIM111RXKEY=${CLAIM111RXKEY}-T
fi
if  [ $WEEK = 1 ]
then
   CLAIM111RXKEY=${CLAIM111RXKEY}-W
fi
if  [ $MON = 1 ]
then
   CLAIM111RXKEY=${CLAIM111RXKEY}-M
fi
if  [ $QRT = 1 ]
then
   CLAIM111RXKEY=${CLAIM111RXKEY}-Q
fi
if  [ $TWEEK = 1 ]
then
   CLAIM111RXKEY=${CLAIM111RXKEY}-X
fi

export CLAIM111RXKEY

if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS 
fi


echo "Claims Data File - CLAIM111"
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CLAIM111RXKEY=$CLAIM111RXKEY"
submit_claim111rx 
date


exit 0

