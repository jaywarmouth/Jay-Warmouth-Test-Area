#!/bin/ksh
#
# Program Name	: login_tr.sh
# Description	: Shell to allow dial-up access to system(s) and perform transfers
# Author	: Anthony DePinto
# Date		: 8-14-96
# Modifications :
#
# Variables Used:
USER_LOG=/usr/pdm/bin/user_log.out
TTY=`who am i | awk '{ print $2}'`
STOP=0
MAILTO=ljefferis@pdmi.com
TR_FILE=""
CR="
"

make_file_list()
{  OLDIFS=${IFS}
   IFS=${CR}
   for LINE in `ls -1`
   do
     TR_FILE=${TR_FILE}${LINE}" "
   done
   IFS=${OLDIFS}
}

get_file()
{  echo 
   echo "Please enter the file name to send to PDM:"
   read FILENAME
}

tr_finished()
{  echo
   echo "Transfer complete"
   echo 
   echo "Please logoff the system."
}

notify()
{  cd ${TRANSFER_DIR}
   ls -l | mail $MAILTO 
}

xmodem()
{  get_file 
   echo "Starting XModem transfer..."
   rz -1vb $FILENAME
   tr_finished
   notify
}

x_send()
{  
   echo sz -X -vb ./${TR_FILE}
   pwd
   sz -X -vb ${TR_FILE}
   tr_finished
   notify
}

ymodem()
{  
   echo "Starting YModem transfer..."
   rb -v 
   tr_finished
   notify
}

y_send()
{  echo "Go to receive on your system."
   sb -v ${TR_FILE}
   tr_finished
   notify
}

zmodem()
{  
   echo "Starting ZModem transfer..."
   rz -vb
   tr_finished
   notify
}

z_send()
{ 
   echo "Go to receive on your system."
   sz -vb ${TR_FILE}  
   tr_finished
   notify
}

send_files()
{  STOP=0 
   while test $STOP -eq 0
   do
     cat << ENDOFSEND 
  Please choose a transfer protocol...

  1.  XModem
  2.  YModem
  3.  ZModem
ENDOFSEND
  echo 'Your choice? '
  read SENDREPLY
  case $SENDREPLY in 
  "1")  xmodem 
	STOP=1
	;;
  "2")  ymodem
	STOP=1
	;;
  "3")	zmodem
	STOP=1
	;;
  "4")  exit 0
	;;
  *) echo 
     echo "-*> Invalid Choice <*-"
     echo
     ;;
  esac
  done
}

receive_files()
{  STOP=0 
   while test $STOP -eq 0
   do
     cat << ENDOFRECV 
  Please choose a transfer protocol...

  1.  XModem
  2.  YModem
  3.  ZModem
ENDOFRECV
  echo 'Your choice? '
  read RECREPLY 
  case $RECREPLY in 
  "1")  make_file_list 
	x_send  
	STOP=1
	;;
  "2")  make_file_list
	y_send
	STOP=1
	;;
  "3")	make_file_list
        z_send
	STOP=1
	;;
  "4")  exit 0
	;;
  *) echo 
     echo "-*> Invalid Choice <*-"
     echo
     ;;
   esac
   done
}

#
# Main
#

cd ${TRANSFER_DIR}
${USER_LOG} ${LOGNAME} ${TTY} T

while test $STOP -eq 0
do
  cat << ENDOFMENU

----

Do you wish to 

  1. Send file(s) to PDM
  2. Receive files(s) from PDM
  3. Logoff PDM
ENDOFMENU
  echo 'Your choice? '
  read REPLY
  case $REPLY in
  "1") send_files
       STOP=1
       ;;
  "2") receive_files
       STOP=1
       ;;
  *) exit 0
      ;;
  esac
done 
