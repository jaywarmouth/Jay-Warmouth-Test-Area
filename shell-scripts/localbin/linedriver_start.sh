#!/bin/sh


#       Name: kill_lines.sh
#       By  : Steven Randlett
#       Date: 03/03/99
#       Purpose: Kill off all envoy/ndc lines
#
#	Combination/Modification of killenv.sh and killndc.sh scripts.
#
#


usage()
{
echo "USAGE: $0 line"
echo "where line is sw16 or sw40"
}

#
# MAIN
#

LINETYPE="$1"


PDM_PATH=/usr/local/bin
PDM_SHELL=/usr/lnk/shell
PDM_LOG=/usr/local/logs
PDM_CONFIG=/usr/local/etc
LHOST=`/bin/hostname -s`

if [ "$LINETYPE" = "" ]
then
	usage
	exit 1

elif [ "$LINETYPE" = "sw16" ]
then

echo "Starting Switch16 linedriver daemon"
su - pdmisvc -c "${PDM_PATH}/tcplinedrv -f ${PDM_CONFIG}/claimprocessing/switch16.cfg >/dev/null &"


elif [ "$LINETYPE" = "sw40" ]
then
echo "Starting Switch40 linedriver daemon"
su - pdmisvc -c "${PDM_PATH}/tcplinedrv -f ${PDM_CONFIG}/claimprocessing/switch40.cfg >/dev/null &"


elif [ "$LINETYPE" = "all" ]
then


echo "Starting Switch16 linedriver daemon"
su - pdmisvc -c "${PDM_PATH}/tcplinedrv -f ${PDM_CONFIG}/claimprocessing/switch16.cfg >/dev/null &"


echo "Starting Switch40 linedriver daemon"
su - pdmisvc -c "${PDM_PATH}/tcplinedrv -f ${PDM_CONFIG}/claimprocessing/switch40.cfg >/dev/null &"


else
	usage
	exit 1
fi


