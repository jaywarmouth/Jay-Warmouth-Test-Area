#!/bin/sh


#       Name: kill_process.sh
#       By  : Linda Jefferis
#       Date: 08/03/2011
#       Purpose: kill selected tcp process
#
#	Version 2.0 - changed to case process for PROCTYPE and added do_kill


usage()
{
echo "USAGE: $0 process-name"
echo "where process-name is tcpclaim, tcpclaim_vmac or tcpfileclaim"
echo "Purpose: Kill selected tcp process"

}

get_pid()
{
grep_line="$1"

echo `ps -ef | grep "${grep_line}" | grep -v "grep ${grep_line}" | awk '{ print $2 }'`


}

do_kill()
{
LINEID=`get_pid "${LINE1}"`
if [ "${LINEID}" != "" ]
then
	if [ ${LINEID} = 1 ]
        then
                echo "Abort... LINEID is 1"
                exit 1
        fi
        echo Killing... ${LINEID}
        kill -9 ${LINEID}

fi
}

#
# MAIN
#

OIFS="$IFS"
CR="
"
PROCTYPE="$1"

case $PROCTYPE in
  "tcpclaim")
        LINE1="/usr/local/bin/tcpclaim -f /usr/local/etc/claimprocessing/webclaim.cfg"
        do_kill
        LINE1="/usr/local/bin/tcpclaim -f /usr/local/etc/claimprocessing/webclaim_mcet.cfg"
        do_kill
        LINE1="/usr/local/bin/tcpclaim -f /usr/local/etc/claimprocessing/webclaim_general.cfg"
        do_kill
        LINE1="/usr/local/bin/tcpclaim -f /usr/local/etc/claimprocessing/webclaim_restack.cfg"
        do_kill
        LINE1="/usr/local/bin/tcpclaim -f /usr/local/etc/claimprocessing/webclaim_medsub.cfg"
        do_kill
        LINE1="/usr/local/bin/tcpclaim -f /usr/local/etc/claimprocessing/webclaim_pricingtool.cfg"
        do_kill
        ;;
   "tcpfileclaim")
        LINE1="/usr/local/bin/tcpfileclaim -f /usr/local/etc/rte/realtime_tcpfileclaim2.cfg"
	do_kill
	;;
     *) usage
	exit 1
esac


