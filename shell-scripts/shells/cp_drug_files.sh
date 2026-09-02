#!/bin/ksh
#
# Program Name	: cp_drug_files.sh
# Description	: 
# Author	: Linda S. Jefferis
# Date		: 05/20/2002
# Modifications : 
#
# Variables Used:
DRUG_DIR="/usr/lnk/drug"
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cp_drug_files.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

# Check command line validity

echo ""
echo "--> Start of DRUG000MAS copy"
date
cp ${DRUG_DIR}/DRUG000MAS ${DRUG_DIR}/DRUG000MAS.v1
if test $? -eq 0
then
   date
   echo "--> Copy of DRUG000MAS is complete"
   echo ""
else
   date
   echo "-*> Error during copy of DRUG000MAS"
   echo ""
fi

echo "--> Start of GEAP000MAS copy"
date
cp ${DRUG_DIR}/GEAP000MAS ${DRUG_DIR}/GEAP000MAS.v1
if test $? -eq 0
then
   date
   echo "--> Copy of GEAP000MAS is complete"
   echo ""
else
   date
   echo "-*> Error during copy of GEAP000MAS"
   echo ""
fi

echo "--> Start of MODIF00MAS copy"
date
cp ${DRUG_DIR}/MODIF00MAS ${DRUG_DIR}/MODIF00MAS.v1
if test $? -eq 0
then
   date
   echo "--> Copy of MODIF00MAS is complete"
   echo ""
else
   date
   echo "-*> Error during copy of MODIF00MAS"
   echo ""
fi

echo "--> Start of NDCMO00MAS copy"
date
cp ${DRUG_DIR}/NDCMO00MAS ${DRUG_DIR}/NDCMO00MAS.v1
if test $? -eq 0
then
   date
   echo "--> Copy of NDCMO00MAS is complete"
   echo ""
else
   date
   echo "-*> Error during copy of NDCMO00MAS"
   echo ""
fi

echo "--> Start of GENER00MAS copy"
date
cp ${DRUG_DIR}/GENER00MAS ${DRUG_DIR}/GENER00MAS.v1
if test $? -eq 0
then
   date
   echo "--> Copy of GENER00MAS is complete"
   echo ""
else
   date
   echo "-*> Error during copy of GENER00MAS"
   echo ""
fi

exit 0
