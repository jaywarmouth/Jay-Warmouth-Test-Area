#!/bin/sh
#
# Program Name	: testelig_process.sh
# Description   : Eligibility processing
#		 
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ELIG_OUT=/usr/lnk/elig_out
CARDH_DIR="/usr/lnk/elig_in"
DATE="null"
CLIENT="null"
SHELL=/usr/lnk/shell
#SHELL=$(pwd)
CONFIG_FILE="/usr/lnk/elig_in/elig.cfg"
TMPFILE="/tmp/elig_conf_list"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

USAGE: 
testelig_process.sh <id>e<mmdd>

Config file is:  $CONFIG_FILE

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
# Parse config. record
parse_config()
{
	SYS=`echo $line | awk -F: '{ print $3 }'`
	ELIG_TYPE=`echo $line | awk -F: '{ print $4 }'`
	GRP_FLG=`echo $line | awk -F: '{ print $5 }'`
	RPT_NAME=`echo $line | awk -F: '{ print $6 }'`
	PROGRAM=`echo $line | awk -F: '{ print $7 }'`
	PROC_FLG=`echo $line | awk -F: '{ print $8 }'`
}		

# List config file
list_id()
{
	echo "elig_type     0 - Regular ??e input file"
	echo "              1 - Converted ??e.lin input file"
	echo "              2 - X12 file"
	echo "              3 - XLS file"
	echo "grp_flg       0 - No group file, 1 - Yes group file"
	echo "rpt_name      suffix name for PRINT-??- output filenames"
	echo "proc_flg      Additional processes flag: 0 - None, 1 - cardh02id"
	echo ""
	/bin/echo -e "ID\tSys#\tElig_Type\tGrp_flg\t\tRpt_name\tProc_flg"
	if [ "$CLIENT" = "all" ]
	then
		IFS="$CR"
        	for line in `cat $CONFIG_FILE | grep -v "^#"`
        	do
                	IFS="$OIFS"
			fid=`echo $line | awk -F: '{ print $1 }'`
			parse_config
			/bin/echo -e "${fid}\t${SYS}\t${ELIG_TYPE}\t\t${GRP_FLG}\t\t${RPT_NAME}\t\t${PROC_FLG}" >> $TMPFILE
		done
		cat $TMPFILE | /bin/sort 
		rm -f $TMPFILE
		exit 0
	else
		IFS="$CR"
                for line in `cat $CONFIG_FILE | grep -v "^#"`
                do
                        IFS="$OIFS"
                        fid=`echo $line | awk -F: '{ print $1 }'`
			if [ "$CLIENT" = "$fid" ]
			then
				FOUND=1
				parse_config
				/bin/echo -e "${fid}\t${SYS}\t${ELIG_TYPE}\t\t${GRP_FLG}\t\t${RPT_NAME}\t\t${PROC_FLG}" >> $TMPFILE
				cat $TMPFILE
				rm -f $TMPFILE
				exit 0
			fi
		done	
		echo "Client ID, $CLIENT, not found in database."
		exit 1
	fi
}

#
# Validate -c options
validate_client()
{  
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
}

#
# Set variables
#
set_variables()
{
case ${ELIG_TYPE} in
  "2" | "3" | "8")
	INPUT_FILE=${CARDH_DIR}/${CLIENT}e${DATE}
	;;
  "1")
	INPUT_FILE=${CARDH_DIR}/${CLIENT}e${DATE}.lin
	;;
esac
}

#
# Run eligibility program
run_elig()
{
  if [ ${DATE} = "null" ]
  then
    echo "DATE="${DATE}
    usage
  else
     case ${PROGRAM} in
     	"cardh29")
		PROGRAM=${PROGRAM}
		;;
     esac 
     if test -s ${INPUT_FILE}
     then
        case ${ELIG_TYPE} in
          "1")
             if test -s ${INPUT_FILE}
             then
               ${SHELL}/${PROGRAM}.sh -c ${CLIENT} -d ${DATE} -f ${INPUT_FILE} -s ${SYS}
             else
	       echo
               echo "###################### ERROR MESSAGE #####################"
               echo "${INPUT_FILE} is zero or doesn't exist"
               echo "Have this fixed, then restart elig_process.sh"
               echo "##########################################################"
               exit 1
             fi
             ;;
          "2" | "3" | "8")
	     cp ${INPUT_FILE} ${ELIG_OUT}
	     if test $? -eq 0
	     then
 	        ${SHELL}/${PROGRAM}.sh -c ${CLIENT} -d ${DATE} -f ${INPUT_FILE} -s ${SYS}
	     else
		echo "-*> Problem with copy of elig. file to archive system."
		echo "-*> Stopping the procedure. Please notify supervisor."
		exit 1
	     fi
             ;;
        esac
     else
        echo "### MESSAGE ###"
        echo "${INPUT_FILE} is zero or doesn't exist"
	echo "Process is aborting...!"
	exit 1
     fi
  fi
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 1 ]
then
   usage
   exit 1
fi

  file_name=$1
  CLIENT=${file_name:0:2}
  validate_client
  DATE=${file_name:3}

# Parse environment variables
parse_env

# Assign other variables
umask 002

# Set Internal Variables
set_variables

# Run eligibility program
run_elig 

# Cleanup
echo ""
echo "-> Doing Cleanup"
${SHELL}/testelig_cleanup.sh -c ${CLIENT} -d ${DATE} -f ${INPUT_FILE}


exit 0
