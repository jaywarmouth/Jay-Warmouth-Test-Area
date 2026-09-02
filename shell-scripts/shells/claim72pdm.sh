#!/bin/sh
#
# Program Name	: claim72pdm.sh
# Description   : Claims to Tape Transfer 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -r Rerun (batchrange & filename(30-char.) as argument)
#                 -c Type of cycle (pay, twice, day, week, tweek, rst, chk, twkrst, medsub, cl137)
#                 -f <filename> Assign alternate CLAIM00MAS file
#		  -z Sample data Flag
# Author	: Linda S. Jefferis
# Date		: 05/03/96
# Modifications : 02/12/97 - Removed proc_audit logic - LSJ
#                 04/22/97 - Added env_var & OBJ_DIR logic - LSJ
#                 01/09/98 - Added Daily flag - CH
#                 01/23/98 - Added -f option  (LSJ)
#		: 05/02/2001 - Added -z flag  (LSJ)
#		: 05/04/2005 - Changes for new week-cycle  (LSJ)
#               : 07/10/2008 - Add twice-week run   (MJP)
#		: 02/21/2013 - Add logic for restack process
#		: 05/31/2013 - Add logic for chkrun process
#		: 10/24/2014 - Add "twkrst" and OUTDAT0MAS-CL72 logic  (LSJ)
#		: 02/26/2015 - Add RETVAL logic; TT #12593-2
#               : 12/19/2018 - TT18987-70; CYCLERRS logic
#		: 06/04/2019 - Remove CYCLERR assignements
#		: 08/14/2019 - Add "medsub" logic
#		: 11/02/2020 - "cl137" logic; uses SKIP_SORT switch
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
TMPIR=/usr/lnk/tmp
SKIP_SORT=0
CYCLE="null"
PAY=0
TWICE=0
RERUN=0
ARGUMENT=""
DAILY=0 
FILE_FLAG=0
SAMP_FLAG=0
WEEK=0
TWEEK=0
RST=0
CHK=0
TWKRST=0
MEDSUB=0
CL137=0
RETVAL=0
DATETM=`date +%Y%m%d_%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim72pdm.sh [-s] [-c <day|pay|twice|week|tweek|rst|chk|medsub|cl137>] [-r "batchrange&pathname"] [-f <filename>] [-z]

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
        DAILY=1
        ;;
     "twice")
        TWICE=1
        ;;
     "week")
        WEEK=1
        ;;
     "tweek")
        TWEEK=1
        ;;
     "rst")
	RST=1
	DAILY=1
	;;
     "medsub")
	MEDSUB=1
	DAILY=1
	;;
     "twkrst")
	TWKRST=1
	DAILY=1
	;;
     "chk")
	CHK=1
	DAILY=1
	;;
     "cl137")
	CL137=1
	SKIP_SORT=1
	;;
    *)  usage
         ;;
   esac
}


# Submit claim72pdm program
submit_claim72pdm()
{
   if [ ${RERUN} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim72pdm -s ${SKIP_SORT}${PAY}${TWICE}${DAILY}1${WEEK}${TWEEK} -a "${ARGUMENT}" 
	RETVAL="$?"
     else
        runcobol ${OBJ_DIR}/claim72pdm -s ${SKIP_SORT}${PAY}${TWICE}${DAILY}0${WEEK}${TWEEK} 
	RETVAL="$?"
   fi
   echo "RETVAL=$RETVAL"
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) SKIP_SORT=1
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RERUN=1
        ARGUMENT=$1
        ;;
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CYCLE=$1
        validate_cycle
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        FILE=$1
        ;;
    -z) SAMP_FLAG=1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign Alternate variables
if [ ${SAMP_FLAG} = 1 ]
then
        ENV_FILE="/usr/lnk/demo/env_var.demo"
        parse_env
fi
if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

if  [ $PAY = 1 ]
then
   CLAIM72KEY=${CLAIM72KEY}-P;export CLAIM72KEY
   CL72CCI=/usr/lnk/sqlimports/claims/CL72-COUNTS-P; export CL72CCI
fi
if  [ $DAILY = 1 ]
then
   CLAIM72KEY=${CLAIM72KEY}-D;export CLAIM72KEY
   CL72CCI=/usr/lnk/sqlimports/claims/CL72-COUNTS-D; export CL72CCI
fi
if  [ $TWICE = 1 ]
then
   CLAIM72KEY=${CLAIM72KEY}-T;export CLAIM72KEY
   CL72CCI=/usr/lnk/sqlimports/claims/CL72-COUNTS-T; export CL72CCI
fi
if  [ $WEEK = 1 ]
then
   CLAIM72KEY=${CLAIM72KEY}-W;export CLAIM72KEY
   CL72CCI=/usr/lnk/sqlimports/claims/CL72-COUNTS-W; export CL72CCI
fi
if  [ $TWEEK = 1 ]
then
   CLAIM72KEY=${CLAIM72KEY}-X;export CLAIM72KEY
   CL72CCI=/usr/lnk/sqlimports/claims/CL72-COUNTS-X; export CL72CCI
fi
if  [ $RST = 1 ]
then
   CLAIM72KEY=${CLAIM72KEY}-R;export CLAIM72KEY
   CL72CCI=/usr/lnk/sqlimports/claims/CL72-counts-R; export CL72CCI
   CLLOC00MAS=/usr/lnk/restack/CLLOC00RST; export CLLOC00MAS
fi
if  [ $MEDSUB = 1 ]
then
   CLAIM72KEY=${CLAIM72KEY}-M;export CLAIM72KEY
   CL72CCI=/usr/lnk/sqlimports/claims/CL72-COUNTS-M; export CL72CCI
fi
if  [ $CHK = 1 ]
then
   CLAIM72KEY=${CLAIM72KEY}-C;export CLAIM72KEY
   CL72CCI=/usr/lnk/sqlimports/claims/CL72-counts-C; export CL72CCI
   CLLOC00MAS=/usr/lnk/claims/CLLOC00CHK; export CLLOC00MAS
fi
if  [ $CL137 = 1 ]
then
   CLAIM72KEY=${CLAIM72KEY}-U;export CLAIM72KEY
   CL72CCI=/usr/lnk/sqlimports/claims/CL72-COUNTS-U; export CL72CCI
fi
if  [ $TWKRST = 1 ]
then
   CLAIM72KEY=${CLAIM72KEY}-TR;export CLAIM72KEY
   CL72CCI=/usr/lnk/sqlimports/claims/CL72-counts-TR; export CL72CCI
   CLLOC00MAS=/usr/lnk/restack/CLLOC00RST; export CLLOC00MAS
fi

OUTDAT0MAS=/usr/lnk/log/OUTDAT0MAS-CL72
export OUTDAT0MAS


echo "Claims to Tape Transfer - claim72pdm"
echo For Warehouses
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CLAIM72KEY=$CLAIM72KEY"
date
submit_claim72pdm 
date

exit ${RETVAL}
