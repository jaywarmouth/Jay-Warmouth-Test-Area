#!/bin/sh

HOST=`/bin/hostname -s`
read name < /usr/lnk/tmp/SCRIP02DIR

    if [ ! -d /usr/lnk/elig_in/$name ]
    then 
	mkdir -m 770 /usr/lnk/elig_in/$name
	chgrp pdm /usr/lnk/elig_in/$name
	case ${HOST} in
	  "prod10")
		chown pdmisvc /usr/lnk/elig_in/$name
		;;
	   *)
		chown c04 /usr/lnk/elig_in/$name
		;;
	esac
	echo /usr/lnk/elig_in/$name
    fi

    if [ ! -d /usr/lnk/elig_out/$name ]
      then mkdir -m 770 /usr/lnk/elig_out/$name
           chgrp pdm /usr/lnk/elig_out/$name
	   chown operator /usr/lnk/elig_out/$name
           echo /usr/lnk/elig_out/$name
    fi


