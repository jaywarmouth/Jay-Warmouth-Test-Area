#!/bin/sh
# to run: 
#         cfgcmsedit.sh -t "CRK  " -y 0170 -p 00001412 -g 0000000000000000 -r 004 -m 01
#
# Program cfgcmsedit edits the CMS Precluded Provider File and create a Config Master transaction file
# 
# Program Name	: cfgcmsedit.sh
# Description   : Edit CMS Precluded Provider File
#                 Command line arguments:
#                 Linkage parameters:
#                    -t TLINK       X(05)
#                    -y SYSTEM      9(04)
#                    -p SPONSOR     9(08)
#                    -g GROUP       9(16)
#                    -r RECORD TYPE X(03) VALUE OF 004 FOR PRECLUDED PROVIDER
#                    -m FILE MONTH  9(02)
# Author	: Peggy Voytilla
# Date		: 07/09/2019
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_IN="null"
DATETM=`date +%Y%m%d-%H%M%S`
TLINK_IN="null"
SYSTEM_IN="null"
SPONSOR_IN="null"
GROUP_IN="null"
REC_TYPE_IN="null"
FILE_MONTH="null"
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cfgcmsedit.sh [-t <tlink>] [-y <system>] [-p <sponsor>] [-g <group>] [-r <recordtype>] 

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
	  echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}


# Submit cfgcmsedit program
submit_cfgcmsedit()
{
     runcobol ${OBJ_DIR}/cfgcmsedit -a ${TLINK_IN}${SYSTEM_IN}${SPONSOR_IN}${GROUP_IN}${REC_TYPE_IN}  
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) shift
        if [ $# -le 0 ]
        then 
          usage
        fi
        TLINK_IN=$1
        ;;
    -y) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SYSTEM_IN=$1
        ;;
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SPONSOR_IN=$1
        ;;
    -g) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        GROUP_IN=$1
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        REC_TYPE_IN=$1
        ;;
    -m) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_MONTH=$1
        ;;

  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${TLINK_IN} = "null" -o ${SYSTEM_IN} = "null" -o ${SPONSOR_IN} = "null" -o ${REC_TYPE_IN} = "null" ]

then
  usage
else


#Input CMS comma delimited file
CFGCMS0TAP=/usr/lnk/wt/oper-wt/cms/CFGCMS0TAP_2019${FILE_MONTH}.csv
  export CFGCMS0TAP

#Input Config Master - for edit only, no updates
#CONFIG0MAS=/usr/devl/users/pvoytil/config/CONFIG0MAS
#  export CONFIG0MAS

#Outut Config Master transactions for input to config02.cbl
CONFIG02PRM=/usr/lnk/wt/oper-wt/cms/CONFIG02PRM-CMS-${FILE_MONTH}-${DATETM}.csv
  export CONFIG02PRM

#Output comma delimited transaction report
CONFIG0RPT=/usr/lnk/wt/oper-wt/cms/CONFIG0RPT-CMS-${FILE_MONTH}-${DATETM}.csv
  export CONFIG0RPT

fi


echo "Edit CMS Precluded Provider File and Create Config Master Trans"
date
echo "   CFGCMS0TAP=$CFGCMS0TAP"
echo "   CONFIG0MAS=$CONFIG0MAS"
echo "   CONFIG02PRM=$CONFIG02PRM"
echo "   CONFIG0RPT=$CONFIG0RPT"
echo " "
echo "   TLINK=$TLINK_IN"
echo "   SYSTEM=$SYSTEM_IN"
echo "   SPONSOR=$SPONSOR_IN"
echo "   GROUP=$GROUP_IN"
echo "   REC_TYPE=$REC_TYPE_IN"
echo "   FILE_MONTH=$FILE_MONTH"

submit_cfgcmsedit 
date

#chmod 777 /usr/lnk/shares/pvoytil/CONFIG0RPT-CMS-${FILE_MONTH}-${DATETM}.csv

exit 0
