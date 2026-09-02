#!/bin/sh

read name < /usr/lnk/tmp/SCRIP02DIR

    if [ ! -d /usr/lnk/po/$name ]
      then mkdir -m 770 /usr/lnk/po/$name
           chgrp pdm /usr/lnk/po/$name
	   chown operator /usr/lnk/po/$name
           echo /usr/lnk/po/$name
    fi
