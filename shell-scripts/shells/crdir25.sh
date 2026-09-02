#! /usr/bin/ksh

read name < /usr/lnk/tmp/SCRIP02DIR

    if [ ! -d /usr/lnk/po/$name ]; then 
           mkdir -m 770 /usr/lnk/po/$name
           chgrp pdm /usr/lnk/po/$name
           echo /usr/lnk/po/$name
    fi

    if [ ! -d /usr/lnk/po/xp/$name ]; then
           mkdir -m 770 /usr/lnk/po/xp/$name
           chgrp pdm /usr/lnk/po/xp/$name
           echo /usr/lnk/po/xp/$name
    fi

#    if [ ! -d /usr/lnk/rptarch/$name ]; then
#           mkdir -m 770 /usr/lnk/rptarch/$name
#           chgrp pdm /usr/lnk/rptarch/$name
#           echo /usr/lnk/rptarch/$name
#    fi
