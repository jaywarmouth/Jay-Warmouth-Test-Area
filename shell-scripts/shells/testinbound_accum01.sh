#!/bin/sh
#
# Program Name	: accum01.sh
# Description   : Batch Accumulator Update Process
#                 Command line arguments:
#                   -u Update LIMIT00MAS File
#                   -t Test Mode
#                   -c Client Abbrev. (2-characters)
#                   -d date of file (mmdd)
#		    -f Full output file flag (for special MedBen and IMG process)
#
# Modifications: 8/2/2021 - added accum01.cfg logic and removed clientID hardcoding logic.

ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
ACC_DIR="/usr/lnk/elig_in"
ACC_OUT=/usr/lnk/elig_in_1
FG4AUD_DIR="/usr/lnk/audit"
AUDNAME="LIMAUD"
DATE="null"
CLIENT="null"
UPDATE_FILE=0
TEST_MODE=0
FULL_TRANSFER=0
#DATETME=`date +%m%d%Y%H%M%S`
DATETM=`date +%Y%m%d-%H%M%S`
FULL_DATE=`date +%Y%m%d`
TR_FILE_FLG=0
#ACCUM_ERR="/usr/lnk/misc/ACCUM-01-"
#CONV_PDF="/usr/lnk/shell/conv_elig_rpts.sh"
WT_DIR=/usr/lnk/wt/oper-wt/EligReports-Test
CONFIG_FILE=/usr/lnk/elig_in/accum01.cfg

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: accum01.sh [-u] [-t] [-c <client abbrev.>] [-d <mmdd>]

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


# Submit test accum01
submit_test()
{
   FG4AUD=${FG4AUD_DIR}/${AUDNAME}
   export ACCUM01TAP FG4AUD
   runcobol ${OBJ_DIR}/${PROGRAM} -s ${UPDATE_FILE}${TEST_MODE} -a ${CLIENT}l${DATE}
}

#
# Parse config record
parse_config()
{
        SYS=`echo $line | awk -F: '{ print $3 }'`
        IN_FLG=`echo $line | awk -F: '{ print $4 }'`
        OUT_FLG=`echo $line | awk -F: '{ print $5 }'`
        RPT_REF=`echo $line | awk -F: '{ print $6 }'`
        CLIENT_NAME=`echo $line | awk -F: '{ print $7 }'`
        TR_FILE_FLG=`echo $line | awk -F: '{ print $8 }'`
}

#
# Set variables
#
set_variables()
{
   if [ ${CLIENT} = "null" ]
   then
     usage
   fi
   PROGRAM=accum01
   IFS="$CR"
   FOUND=0
   for line in `cat $CONFIG_FILE | grep -v "^#"`
   do
        IFS="$OIFS"
        fid=`echo $line | awk -F: '{ print $1 }'`

        if [ "$CLIENT" = "$fid" ]
        then
                FOUND="1"
                parse_config
        fi
   done
   if [ "$FOUND" -ne 1 ]
   then
        echo "Client ID $CLIENT not found in database."
        exit 1
   fi
   ACCUM01TAP=${ACC_DIR}/${CLIENT}l${DATE}.lin
   ACCUMERR_RPT=${ACC_OUT}/sys${SYS}/${DATETM}-ACCUM01-ERRSUM-${CLIENT}l${DATE}.txt
   REPORT0PCX=${ACC_OUT}/sys${SYS}/${DATETM}-ACC01-${CLIENT}l${DATE}.csv
   export REPORT0PCX ACCUM01TAP 
# Below variable is for providing required input to program
# Format is 1 field followed by a ";"
#    Path and name of the error/summary output report
ACCUM01V2_PARM="${ACCUMERR_RPT};"
export ACCUM01V2_PARM
}


#
# File checking and submitting accum01
error_check()
{
  if [ ${DATE} = "null" ]
  then
     echo "DATE="${DATE}
     usage
  else
     if test -s ${ACC_DIR}/${CLIENT}l${DATE}
     then
             if test -s ${ACCUM01TAP}
             then
		submit_accum01
             else
               echo "${ACCUM01TAP} is zero or doesn't exist"
               exit 99
             fi
     else
        echo "${ACC_DIR}/${CLIENT}l${DATE} is zero or doesn't exist"
        cleanup
        exit 99
     fi
  fi
}

# Runcobol procedure
submit_accum01()
{
     export ACCUM01TAP REPORT0PCX FG4AUD
#     if [ $UPDATE_FILE = 1 ]
#     then
#	rm -f ${ACCUM_ERR}${RPT_REF}
#     fi
     runcobol ${OBJ_DIR}/accum01 -s ${UPDATE_FILE}${TEST_MODE}${FULL_TRANSFER} -a ${CLIENT}l${DATE}
}

# Copy REPORT0PCX report file
copy_report_file()
{
        if test -s ${REPORT0PCX}
        then
                cp ${REPORT0PCX} ${WT_DIR}
        else
                echo "No report data for updated ${CLIENT}l${DATE} file" > ${REPORT0PCX}
                cp ${REPORT0PCX} ${WT_DIR}
        fi
}


#
# Print report
print_rpt()
{
	if [ $UPDATE_FILE = 1 ]
	then
		if test -s ${ACCUMERR_RPT}
		then
			/usr/bin/enscript -rlg -f Courier7 --non-printable-format=space -o - ${ACCUMERR_RPT} | ps2pdf - ${WT_DIR}/${DATETM}-${CLIENT}l${DATE}.pdf
		fi
	fi
}

#
# Cleanup
cleanup ()
{
   echo ""
   echo "-> Doing Cleanup"
#   rm -f ${ACC_DIR}/${CLIENT}l${DATE}
   mv ${ACC_DIR}/${CLIENT}l${DATE} ${ACC_OUT}/sys${SYS}
   mv ${ACCUM01TAP} ${ACC_OUT}/sys${SYS}
#   rm -f ${ACCUM01TAP}
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE=1
        ;;
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CLIENT=$1
        ;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
    -u) UPDATE_FILE=1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

FG4AUD=${FG4AUD_DIR}/${AUDNAME}

	set_variables
	error_check 
	copy_report_file
	print_rpt
	cleanup

exit 0
