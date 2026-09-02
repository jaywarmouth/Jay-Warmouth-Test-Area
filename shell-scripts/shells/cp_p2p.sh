# Copy P2P files to share drive

SHR_DIR=/usr/lnk/shares/ftp-tmp/p2p
FILE_DIR=/usr/lnk/p2p/out/temp

cd ${FILE_DIR}
for file in `ls -1 *.csv`
do
    cp $file ${SHR_DIR}/P2P_$file
done

exit 0

