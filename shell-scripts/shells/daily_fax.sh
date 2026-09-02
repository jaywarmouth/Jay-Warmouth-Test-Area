#!/bin/ksh
#
# Program Name	: daily_fax.sh
# Description	: Daily Fax Routine
#                 Command Line Arguments:
#                 -s Skip sort flag
#                 -r Rerun (<ccyymmdd> date of rerun as argument)
# Author	: Linda S. Jefferis
# Date		: 10/30/96
# Modifications : 05/14/97 - LSJ - Added env_var & OBJ_DIR logic
#                 05/14/97 - LSJ - Removed proc_audit
#                 05/21/97 - LSJ - Changed fax for Liz Colburn to Paul McDermott
#                 10/15/97 - LSJ - Changes for vsifax path change
#                 01/15/98 - LSJ - Commented out sys26 as per Carol Kresl
#                 05/14/98 - LSJ - changed run of fax001 to a shell
#                 06/09/98 - LSJ - Changed name for sys31
#		  09/16/98 - LSJ - Changed name for sys10
#		  01/11/99 - LSJ - Added sys48
#		  02/01/99 - LSJ - Removed sys16 and sys19 faxing
#		  03/10/99 - LSJ - Changed who gets sys49
#		  05/28/99 - LSJ - Added century to input date
#		  08/26/99 - LSJ - Added Cassandra Thomas for Aultman
#		  12/08/99 - LSJ - Added sys50
#		  12/09/99 - LSJ - Added print of sys50 for Chrisy
#		  01/07/00 - LSJ - Removed sys50 to Chrisy
#		  01/07/00 - LSJ - Added sys52
#		  02/07/00 - LSJ - Added sys51
#		  03/31/00 - LSJ - Removed fax to "Jennifer Nichols"
#		  01/03/01 - LSJ - Added sys53
#		  02/19/01 - LSJ - Removed sys43 and sys49 faxing as per email request from Gabriella Maloon and Nick Page.
#		  02/21/01 - LSJ - Added sys56
#		  03/01/01 - LSJ - Commented out sys56 for now (fax# always busy)
#		  03/01/01 - LSJ - Added sys55
#		  03/20/01 - LSJ - Added sys54
#		  12/21/01 - LSJ - Added sys58
#		  04/16/02 - LSJ - Added sys62
#		  06/11/02 - LSJ - Commented out sys62 as per email from them
#		  09/03/02 - LSJ - Added sys61
#		  12/09/02 - LSJ - Changed fax# for sys48 and sys53 as per Kelly Wood at Aultman.
#		  03/25/03 - LSJ - Removed sys60
#		  06/09/03 - LSJ - Added sys64
#		  06/18/03 - LSJ - Removed sys52 as per email from Barbara Pedroza
#		  12/26/03 - LSJ - Addition of sys68
#		  07/01/04 - LSJ - Addition of sys71 and sys73
#		  01/21/05 - LSJ - Addition of email to Kevin Pete
#		  02/14/05 - LSJ - Addition of email for Tracy Dankoff and Tim Colligan for SummaCare
#		  04/06/05 - LSJ - Changed sys48, sys53, sys64 to email
#		  05/09/2005 - LSJ - Removed SummaCare
#		  10/06/2005 - LSJ - Removed send to Kevin Pete (as per phone call regarding other CLAS004.003 email his is receiving)
#		  10/06/2005 - LSJ - Commented fax for Tron Emptage
#		  10/10/2005 - LSJ - Removed sys73 fax as per email from Mike Nault
#		  10/12/2005 - LSJ - Removed emails to Julie Norris as per her email
#		  06/28/2006 - LSJ - Added logic to test if file exists
#		  08/22/2006 - LSJ - Changes for 4-digit system numbers  (LSJ)
#		  10/10/2006 - LSJ - Changed the 132 to land  (LSJ)
#		  10/13/2006 - LSJ - Commented out sys68  (LSJ)
#		  07/02/2007 - LSJ - Commented out sys0061; moved to Reporting Services
#		  07/02/2007 - LSJ - Commented out sys0055
#		  02/07/2008 - LSJ - URX requested not to receive this anymore.
#		  02/07/2008 - LSJ - sys58 was last system getting this so now this procedure has been removed from crontab and will no longer run daily.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SHELL_DIR=/usr/lnk/shell
FAX_DIR=/usr/lnk/fax
FXMAILTO="ljefferi"; export FXMAILTO
FAXFROM="PDM Data Center"
export FAXFROM
FAX_PROG="/usr/local/bin/fax"
SKIP_SORT=0
ARGUMENT="00000000"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_fax.sh [-s] [-r <ccyymmdd>] 

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

# Submit fax001 program
submit_fax001()
{
   if [ ${SKIP_SORT} = 1 ]
     then
         ${SHELL_DIR}/fax001.sh -s -r ${ARGUMENT}
     else
         ${SHELL_DIR}/fax001.sh -r ${ARGUMENT}
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
  esac
  shift
done

# Parse environment variables
parse_env

submit_fax001


### SYS55 ###
#if test -s ${FAX_DIR}/sys0055/???FX00.FAX
#then
#   ${FAX_PROG} "Pam Waskavitz" ${FAX_DIR}/sys0055/???FX00.FAX 13304714784 land
#else
#   echo "No file created for sys55"
#fi

### SYS58 ###
#${FAX_PROG} "Jan Sessor" ${FAX_DIR}/sys0058/???FX00.FAX 15407777184 land


### SYS61 ###
#if test -s ${FAX_DIR}/sys0061/???FX00.FAX
#then
#   ${FAX_PROG} "Sandi Castaneda" ${FAX_DIR}/sys0061/???FX00.FAX 18666266070 land
#else
#   echo "No file created for sys61"
#fi

### SYS68 ###
#${FAX_PROG} "James King" ${FAX_DIR}/sys0068/???FX00.FAX 14195368558 land


exit 0
