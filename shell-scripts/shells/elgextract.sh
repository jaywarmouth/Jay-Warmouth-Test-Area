#!/bin/sh
# To run: elgextract.da       
#
# Program Name	:elgextract.da
# Description   : Extract ELIGIBILY RECORDS BY SYSTEM, SPONSOR AND GROUP.   
#                 Command line arguments:
#		  -t <F|C|B> - output file type
#			F - ELGEXTFILE (Fixed File)
#			C - ELGEXTCSV ("|" separated file)
#			B - Both files created.
#		  -i <ELGEXTPRM file name>
#		  -o <ELGEXTCSV file name>
#		  -f <ELGEXTFILE file name>
# Note:  The ELGEXTERR file is only created if
#                                  
# Author	: Debbe Adgate
# Date		: 10/12/2017
# Modifications :  
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="

OBJ_DIR="/usr/lnk/obj"
RETVAL=0
IN_FILEFLG=0
CSV_FILEFLG=0
FIXED_FILEFLG=0
FTYPE="F"
DATETM=`date +%Y%m%d%H%M%S`
DEFAULT_DIR=/usr/lnk/wt/oper-wt

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: elgextract.sh
                 -t <F|C|B> - output file type
                       F - ELGEXTFILE (Fixed File)
                       C - ELGEXTCSV ("|" separated file)
                       B - Both files created.
                 -i <ELGEXTPRM file name>
                 -o <ELGEXTCSV file name>
                 -f <ELGEXTFILE file name>

ENDOFUSAGE
  exit 99
}


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

	
# To run shell in debug mode add D to end of runcobol statement below 
# To run program in TEST mode:
#	change "N" in linkage below to "Y" 
#	assign an output location for the ELGEXTERR file.
submit_elgextract()
{
       runcobol ${OBJ_DIR}/elgextract -a ${FTYPE}N
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
    -t) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	FTYPE=$1
	;;
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        IN_FILEFLG=1
        INFILE=$1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CSV_FILEFLG=1
        CSVFILE=$1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FIXED_FILEFLG=1
        FIXEDFILE=$1
        ;;
    -e) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        ERR_FILEFLG=1
        ERRFILE=$1
        ;;

  esac
  shift
done


# Parse environment variables
parse_env

if [ ${IN_FILEFLG} = 1 ]
then
	ELGEXTPRM=$INFILE
else
	ELGEXTPRM=${DEFAULT_DIR}/ELGEXTPRM.txt
fi
if [ ${FIXED_FILEFLG} = 1 ]
then
        ELGEXTFILE=$FIXEDFILE
else
        ELGEXTFILE=${DEFAULT_DIR}/ELGEXTFILE-${DATETM}.txt
fi
if [ ${CSV_FILEFLG} = 1 ]
then
        ELGEXTCSV=$CSVFILE
else
        ELGEXTCSV=${DEFAULT_DIR}/ELGEXTCSV-${DATETM}.txt
fi
export ELGEXTPRM ELGEXTFILE ELGEXTCSV

   echo "COBOL EXTRACT ELIGIBILITY"                   
   date
   echo "EXPORT PATHS:"
   echo "   CARDH00MAS=$CARDH00MAS"
   echo "   ELGEXTPRM=$ELGEXTPRM"
   echo "   ELGEXTFILE=$ELGEXTFILE"
   echo "   GROUP00MAS=$GROUP00MAS"
   echo "   CATAB00MAS=$CATAB00MAS"
   echo "   SYSTE00MAS=$SYSTE00MAS"
   echo "   ELGEXTCSV=$ELGEXTCSV"
   echo "   ELGEXTERR=$ELGEXTERR"
   echo "   FILE_TYPE=$FTYPE"

   submit_elgextract  
   echo  "   RET_CODE=$RETVAL"
   date

exit ${RETVAL}
