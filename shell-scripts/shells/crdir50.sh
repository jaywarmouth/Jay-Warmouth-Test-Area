#! /usr/bin/ksh

read name < /usr/pdm/tmp/SCRIP02DIR

    if [ ! -d /usr/lnk/po/$name ]
      then mkdir -m 770 /usr/pdm/po/$name
           chgrp pdm /usr/lnk/po/$name
           echo /usr/lnk/po/$name
    fi

    if [ ! -d /usr/lnk/po/xp/$name ]
      then mkdir -m 770 /usr/lnk/po/xp/$name
           chgrp pdm /usr/lnk/po/xp/$name
           echo /usr/lnk/po/xp/$name
    fi
