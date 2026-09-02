#! /usr/bin/ksh

read name < /usr/lnk/tmp/SCRIP02DIR

#    if [ ! -d /usr/pdm/fax/$name ]
#      then mkdir -m 770 /usr/pdm/fax/$name
#           chgrp pdm /usr/pdm/fax/$name
#           echo /usr/pdm/fax/$name
#    fi
    if [ ! -d /usr/lnk/elig_in/$name ]
      then mkdir -m 770 /usr/lnk/elig_in/$name
           chgrp pdm /usr/lnk/elig_in/$name
           echo /usr/lnk/elig_in/$name
    fi
    if [ ! -d /usr/lnk/elig_out/$name ]
      then mkdir -m 770 /usr/lnk/elig_out/$name
           chgrp pdm /usr/lnk/elig_out/$name
           echo /usr/lnk/elig_out/$name
    fi


