#!/bin/sh
#
# Program Name  : mul_cardh00mas_json.sh_
# Description   : shell to load data in GROUP00MAS using json
# Author        : SWAPNIL GUPTA
# Date          : 01/22/24
# Modifications : 01/22/24: INITIAL VERISON
# TASK T02641              
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
OBJ_DIR=/usr/lnk/obj        
INFILE_FLG=0
OUTFILE_FLG=0
INPUTFILE=/usr/lnk/audit/datafileupdates/tmp_$$_file
LOOPCOUNT=0
DEBUG=N
CR="
"
#
###############
# Usage routine
###############
#
usage()
{  cat << ENDOFUSAGE

usage: group00mas_json_load.sh -f <input file> -o <output file> 
        -f <file>       - required, input filename
        -o <file>       - required, output file                  

ENDOFUSAGE
  exit 1
}

#
##################################
# Parse environment variables file
##################################
#
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
#
###############################
# Submit GROUP00MASLOAD Program
###############################
#
submit_GROUP00MASLOAD()
{
     runcobol ${OBJ_DIR}/GROUP00MASLOAD  -K 
}
#
#INSERT HEADER
#
insert_record_auditrpt()
{
     record_to_insert="FileRecordId,GrpNumber,IOFunction,PrimaryReasonOfFailure,SecondaryReasonOfFailure"
     echo "$record_to_insert" >> "$AUDITRPT"
}
#
##############################
# Read and Reformat INPUT FILE
##############################
# 
read_json_file()
{
    echo
    echo "--> READING INPUT FILE...                                                 "

    IFS=${CR}
    while IFS= read -r record;
    do
       char_count=1   
       char_count=$(printf "%010d" "${#record}")

       GROUPJ=${char_count}${record}
       echo  "${GROUPJ//$'\r'/} "  >> ${INPUTFILE}
    done < "${PROCESSJSON}" 

    echo "-=> Finished."
}
#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INFILE_FLG=1
        INFILE=$1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        OUTFILE_FLG=1
        OUTFILE=$1
        ;;
  esac
  shift
done
#
#############################
# Parse environment variables
#############################
#
parse_env

#
####################################################
# check if shell is called with mandatory parameters
####################################################
#
if [ ${INFILE_FLG} = 1 ]
then
        PROCESSJSON=${INFILE}
else
        usage
fi

if [ $OUTFILE_FLG = 1 ]
then
        AUDITRPT=${OUTFILE}                                          
        export AUDITRPT
else
        usage
fi


#
##########################
#Insert Header in auditRPT
##########################
#
insert_record_auditrpt


#
##########################
#Export FG4AUD, CHGCTLFILE
##########################
#
FG4AUD=$GRPAUD
   export FG4AUD

export AUDITRPT
export CHGCTLFILE=/usr/local/etc/relativity/CHGCTLFILE
export GROUPJSON=${DEBUG}

echo "==================================="
echo "GROUP00MAS LOAD PROGRAM FROM JSON"
echo "PROCESSJSON :- ${PROCESSJSON}"
echo "GROUPJSON   :- ${GROUPJSON}"
echo "GROUP00MAS  :- ${GROUP00MAS}"
echo "AUDITRPT    :- ${AUDITRPT}"
echo "FG4AUD      :- ${FG4AUD}"
echo "INPUTFILE   :- ${INPUTFILE}"
date
echo ""

read_json_file
export INPUTFILE
submit_GROUP00MASLOAD

rm -f ${INPUTFILE}
date

exit 

