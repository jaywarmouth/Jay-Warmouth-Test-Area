#!/bin/sh
#
RETVAL=0
DIR=/usr/lnk/wt/oper-wt/misc/EOY
SHELL_DIR="/usr/lnk/shell"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="aforgacs@pdmi.com, operations@pdmi.com"
RUNTYPE=Prod

#### Spectb01 Update
INFILE=SPECTBM01-TST100-v3-final-midnight-change.txt
ScriptName=spectb01
TASKID=6712
DATETM=`date +%Y%m%d%H%M%S`
${SHELL_DIR}/${ScriptName}.sh -i ${DIR}/${INFILE} -o ${DIR}/${RUNTYPE}-${TASKID}-${ScriptName}-${DATETM}.csv -r ${DIR}/${RUNTYPE}-${TASKID}-errorreport-${DATETM}.csv > ${DIR}/${RUNTYPE}-${TASKID}-${ScriptName}log-${DATETM}.txt 2>&1

echo "Year-end ${ScriptName} file update results" | ${MAIL_PROG} -s "EOY Spectb01 Update" ${MAIL_TO} -a ${DIR}/${RUNTYPE}-${TASKID}-${ScriptName}log-${DATETM}.txt -a ${DIR}/${RUNTYPE}-${TASKID}-${ScriptName}-${DATETM}.csv -a ${DIR}/${RUNTYPE}-${TASKID}-errorreport-${DATETM}.csv


#### Gentb07 Updates
INFILE=GENTB00MAS-FORM-GUARD-midnight-change.txt
ScriptName=gentb07
TASKID=6603
DATETM=`date +%Y%m%d%H%M%S`
${SHELL_DIR}/${ScriptName}.sh -i ${DIR}/${INFILE} -o ${DIR}/${RUNTYPE}-${TASKID}-${ScriptName}-${DATETM}.csv -r ${DIR}/${RUNTYPE}-${TASKID}-errorreport-${DATETM}.csv > ${DIR}/${RUNTYPE}-${TASKID}-${ScriptName}log-${DATETM}.txt 2>&1

echo "Year-end ${ScriptName} file update results" | ${MAIL_PROG} -s "EOY gentb07 Update" ${MAIL_TO} -a ${DIR}/${RUNTYPE}-${TASKID}-${ScriptName}log-${DATETM}.txt -a ${DIR}/${RUNTYPE}-${TASKID}-${ScriptName}-${DATETM}.csv -a ${DIR}/${RUNTYPE}-${TASKID}-errorreport-${DATETM}.csv


INFILE=GENTB00MAS-GLP1-PREV-midnight.txt
ScriptName=gentb07
TASKID=6598
DATETM=`date +%Y%m%d%H%M%S`
${SHELL_DIR}/${ScriptName}.sh -i ${DIR}/${INFILE} -o ${DIR}/${RUNTYPE}-${TASKID}-${ScriptName}-${DATETM}.csv -r ${DIR}/${RUNTYPE}-${TASKID}-errorreport-${DATETM}.csv > ${DIR}/${RUNTYPE}-${TASKID}-${ScriptName}log-${DATETM}.txt 2>&1

echo "Year-end ${ScriptName} file update results" | ${MAIL_PROG} -s "EOY gentb07 Update" ${MAIL_TO} -a ${DIR}/${RUNTYPE}-${TASKID}-${ScriptName}log-${DATETM}.txt -a ${DIR}/${RUNTYPE}-${TASKID}-${ScriptName}-${DATETM}.csv -a ${DIR}/${RUNTYPE}-${TASKID}-errorreport-${DATETM}.csv


exit
