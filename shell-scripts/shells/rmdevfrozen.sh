#!/bin/sh
#
#Program Name	: rmdevmenu.sh
#Description	: Script for Development source code from SCM compiler menu 
#Author		: Dawn M. Engler 
#Date		: 11/6/2013
#
#Modifications	: 03/31/2014 - Moved portions of coding into functions to be able to run without Menu choice and edited chk_src (dme)
#		: 03/31/2014 - Created following functions: src_read, rm_wrk_proj, proj_choice, chk_src_menu (dme) 
#		: 04/21/2014 - Change if statements to while loops for src_read and chk_src functions TT: 10653-1 (dme)
#		: 04/25/2014 - add a COMMAND LINE ARGUMENT for "sourcename". If the command line argument is not filled in. TT:10653-2 (dme)
#
# Variables :
#
COB_DIR=/usr/lnk/tst/$USER
NUM="1"
#
#called functions
#

#
#Used with menu choice settings
#Display menu choice
proj_menu()
{
clear

echo "Please choose the project with source to compile:"
cat ${COB_DIR}/wrk_proj_${USER}
echo "Enter Number Choice and press Enter:"

}

#
#Read source to be compiled
src_read ()
{
	clear
         echo "*********************************************"
         echo -n "Enter Source name:"
         read SRC_NAME
}

#
#Menu to check Sourcename
src_name()
{
         echo "*************************************************************"
         echo "You have entered ${SRC_NAME} for your source."
         echo "Is this Correct? (Y/N)"
         echo "*************************************************************"
        read ans
}

#
# Used with no menu choice for project
chk_src()
{
        proj_name=ProductionCodeVersion1
	
	while [ "${ans}" != "y" ] && [ "${ans}" != "Y" ]
        do
		src_read
 		src_name
       done
                echo "Running Compile on Source."
                rmcompiledev ${SRC_NAME} ${proj_name} Y

                exit 0
}

#
#Use when giving menu choices comes into play
#Check to see if input is correct for Source and Project
chk_src_menu()
{
         Project=$(cat ${COB_DIR}/wrk_proj_${USER} | awk '{print $3}')
         proj_name=$(echo ${Project} | cut -d " " -f $proj_num)
	 echo "*************************************************************"
	 echo "You have chose ${proj_num}) ---> ${proj_name} and have entered ${SRC_NAME} for your source."
         echo "Is this Correct? (Y/N)"
	 echo "*************************************************************"
	while [ "${ans}" != "y" ] && [ "${ans}" != "Y" ];
	do
		 proj_menu
	done
        
	echo "Running Compile on Source."
	rmcompiledev ${SRC_NAME} ${proj_name} Y


        	exit 0
}

#
# To remove wrk_proj_${USER} file when given project choice
rm_wrk_proj()
{
if [ -f ${COB_DIR}/wrk_proj_${USER} ];
then 
	rm -f ${COB_DIR}/wrk_proj_${USER}
fi

for WORK_PROJ in $(ls -1 /media/cobol/users/$WUSER/workspace);
do
	echo "${NUM})	----> 	${WORK_PROJ}" >> $COB_DIR/wrk_proj_${USER}
	NUM=$((NUM +1))
done
}

#
# Used to Display project choice
proj_choice()
{
proj_menu

while read proj_num
do
if [[ ${proj_num}>0 && ${proj_num}<=100 ]];
then
	chk_src_menu
else
	proj_menu
fi

done
}

#
# Main routine
#
# Calls used for project choices
#rm_wrk_proj
#proj_choice



#Check for commandline SRC_NAME
#Used for no project choice default ProductionCodeVersion1

SRC_NAME=$1

while [ $# != 1 ];
do
	src_read
	src_name
	chk_src
done
	src_name
	chk_src



