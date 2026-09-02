#!/bin/sh
#
# Program Name  : claim44newck.sh
# Description   : Pharmacy Remittance Reprint - NEW CHECK CYCLE
#                 Command line arguments:
#                 -f Assign alternate CLAIM00MAS
#                 -c <filename> - run for chain reading a CLWRK file
#                 however this is not supported in the program at this
#                 time but for future use.
# Author        : John Kutchenriter      
# Date          : 12/02/09
# Modifications : 12/02/09 - None
#		: 02/25/2010 - Added "-f" option and changed "read REPLY"  (LSJ)
#             : 12/10/2013 - Changed options for PDF and fax
#		: 02/14/2018 - Update output report location
#		: 11/12/2019 - Change "a2ps" to "enscript"
#		: 03/01/2022 - changed enscript orientation from portrait (-R) to landscape (-r)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
CHAIN_FLAG=0
FILE_FLAG=0
USER=""
DATETM=`date +%Y%m%d%H%M%S`
FILE_DIR=/usr/lnk/misc
PDF_OUT=/usr/lnk/wt/pdm/EOBreports


#
# Usage routine
usage()
{  cat << ENDOFUSAGE
usage: claim44newck.sh [-f <filename>]
	-f <filename>  using alternative CLAIM00MAS input file
			

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
exit_reply()
{   
        echo -e "\nTo complete process press <enter>"
        read REPLY
        exit 0
}

#
#
#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE=$1
        FILE_FLAG=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

umask 000

if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

REPLY="0"
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"

runcobol ${OBJ_DIR}/claim44newck -s 0

date

echo -e "\nEnter selection : 1. PDF Report"
echo -e "                  2. Fax report"
echo -e "                  3. Exit"
while test $REPLY -ne 3
 do
   read REPLY
   case $REPLY in
     "1")  enscript -rBj -a2- -o - ${FILE_DIR}/CL44_NEWCK | ps2pdf - ${PDF_OUT}/EOB-${DATETM}.pdf
           echo -e "\nName of PDF EOB is:  EOB-${DATETM}"
           exit_reply
           ;;
     "2")  echo "This option will create PDF of EOB, then you will use the proper fax procedure."
           enscript -rBj -a2- -o - ${FILE_DIR}/CL44_NEWCK | ps2pdf - ${PDF_OUT}/EOB-${DATETM}.pdf
           echo -e "\nName of PDF EOB is:  EOB-${DATETM}"
           exit_reply
           ;;
     "3") exit 0
          ;;
     "*") echo -e "Invalid choice\n"
          ;;
   esac
 done


exit 0
