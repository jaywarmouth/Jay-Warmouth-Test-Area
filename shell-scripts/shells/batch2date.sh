#!/bin/sh
#
#
# Shell for converting  a PDMI batch to a date
# Version 1.0

usage()
{
        echo "USAGE:"
        echo "batch2date.sh pdm_date"
	echo "	  date must be in the format YMdd i.e. ME21"
	exit 1
}

if [ "$1" = "" ]
then
	usage
fi
DATE="$1"
BATCH_YEAR=`echo $DATE | cut -c1-1`
BATCH_MONTH=`echo $DATE | cut -c2-2`
BATCH_DAY=`echo $DATE | cut -c3-4`

	case ${BATCH_YEAR} in
		"A") YEAR="2000"
			;;
		"B") YEAR="2001"
			;;
		"C") YEAR="2002"
			;;
		"D") YEAR="2003"
			;;
		"E") YEAR="2004"
			;;
		"F") YEAR="2005"
			;;
		"G") YEAR="2006"
			;;
		"H") YEAR="2007"
			;;
		"I") YEAR="2008"
			;;
		"J") YEAR="2009"
			;;
		"K") YEAR="2010"
			;;
		"L") YEAR="2011"
			;;
		"M") YEAR="2012"
			;;
		"N") YEAR="2013"
			;;
		"O") YEAR="2014"
			;;
		"P") YEAR="2015"
			;;
		"Q") YEAR="2016"
			;;
		"R") YEAR="2017"
			;;
		"S") YEAR="2018"
			;;
		"T") YEAR="2019"
			;;
		"U") YEAR="2020"
			;;
		"V") YEAR="2021"
			;;
		"W") YEAR="2022"
			;;
		"X") YEAR="2023"
			;;
		"Y") YEAR="2024"
			;;
		"Z") YEAR="2025"
			;;
		*)  usage
			;;
	esac

case ${BATCH_MONTH} in
	"A") MONTH="01"
		;;
	"B") MONTH="02"
		;;
	"C") MONTH="03"
		;;
	"D") MONTH="04"
		;;
	"E") MONTH="05"
		;;
	"F") MONTH="06"
		;;
	"G") MONTH="07"
		;;
	"H") MONTH="08"
		;;
	"I") MONTH="09"
		;;
	"J") MONTH="10"
		;;
	"K") MONTH="11"
		;;
	"L") MONTH="12"
		;;
	*)  usage
		;;
esac

echo ${YEAR}${MONTH}${BATCH_DAY}

exit 0
