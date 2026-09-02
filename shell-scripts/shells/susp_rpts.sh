#!/bin/sh
#
# Program Name	: susp_rpts.sh
# Description	: Runs the appropriate susp001 scripts
#		  Command Line Arguments:
#		  -c User Class <A,B,C,D>
#		  -u Username (e.g. ljefferi)
# Author	: Linda S. Jefferis
# Date		: 05/18/2000
# Modifications : 07/25/2000 - Removed sys50 run of susp001  (LSJ)
#		: 10/16/2000 - Added group run for sys48  (LSJ)
#		: 01/04/2001 - Added group run for sys53  (LSJ)
#		: 06/25/2001 - Removed run for sys50  (LSJ)
#		: 03/29/2002 - Added sys58 to Master Group  (LSJ)
#		: 04/26/2002 - Added sys62 to Sponsor  (LSJ)
#		: 06/03/2002 - Changed sys58 from Master Group to Sponsor  (LSJ)
#		: 03/27/2003 - Added sys64  (LSJ)
#		: 06/09/2003 - Added sys66 (LSJ)
#		: 01/13/2004 - Removed run for sys04  (LSJ)
#		: 02/02/2004 - Addition of sys68 and sys66  (LSJ)
#		: 02/16/2004 - Addition of sys70  (LSJ)
#		: 07/26/2004 - Added sys71 and sys73  (LSJ)
#		: 07/26/2004 - Changed sys48 and sys53 to sponsor suspend report only  (LSJ)
#		: 01/27/2005 - Added sys76  (LSJ)
#		: 02/14/2005 - Added sys75 (sponsor level report)  (LSJ)
#		: 06/28/2005 - Added sys79  (LSJ)
#		: 09/18/2005 - Added sys81 and sys82  (LSJ)
#		: 10/31/2005 - Added master group run for sys75  (LSJ)
#		: 11/29/2005 - Added master group run for sys83  (LSJ)
#		: 02/13/2006 - Removed sys43 and sys83  (LSJ)
#		: 01/08/2007 - Added sys0002  (LSJ)
#		: 02/02/2007 - Removed sys0081  (LSJ)
#		: 02/15/2008 - Added sponsor run for sys0049 (spo0281)  (LSJ)
#		: 03/18/2008 - Removed sys0076  (LSJ)
#		: 01/12/2009 - Added sys0113  (LSJ)
#		: 05/04/2009 - Added sys0118 and removed sys0066  (LSJ)
#		: 08/10/2009 - Removed sys0118  (LSJ)
#		: 08/11/2009 - Changed sys0113 from sponsor to master group level  (LSJ)
#		: 11/28/2011 - Removed all processes except for those for sys0082
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
UCLASS="null"
USER="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: susp_rpts.sh [-c <userclass:A|B|C|D>] [-u <username>]

ENDOFUSAGE
  exit 1
}

#
# Validate user class
validate_uclass()
{
   case ${UCLASS} in
     "A" | "B" | "C" | "D")
	;;
      *) usage
	;;
   esac
}

#
# Master-Group Suspend Reports
mas_susp()
{
	${SHELL_DIR}/susp001.sh -i mas -p -s 0082 -c ${UCLASS} -u ${USER} >> ${RPT_DIR}/pay-susp001 2>&1
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
	UCLASS=$1
	validate_uclass
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


echo "MAS_SUSP"
mas_susp

date
exit 0
