# Move/Archive P2P files 

YEAR=`date +%Y`
P2PTEMP=/usr/lnk/p2p/out/temp
P2POUT_DIR=/usr/lnk/p2p/out/${YEAR}
P2PIN_DIR=/usr/lnk/p2p/in

if ! test -d ${P2POUT_DIR}
then
        mkdir -m 770 ${P2POUT_DIR}
fi

cd ${P2PTEMP}
for file in `ls -1 *.csv`
do
    mv $file ${P2POUT_DIR}/P2P_$file
done

rm ${P2PIN_DIR}/RPT.DDPS_P2P* 
mv /usr/lnk/p2p/*.zip ${P2PIN_DIR}/${YEAR}

exit 0
