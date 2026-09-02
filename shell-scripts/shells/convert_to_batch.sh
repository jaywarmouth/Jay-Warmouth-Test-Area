#!/bin/sh
#
#
# Shell for converting a date to PDMI batch format
# Version 1.0

usage()
{
        echo "USAGE:"
        echo "convert_to_batch.sh date"
	echo "	  date must be in the format yyyymmdd"
	echo "    works for dates between years 1990 and 2031"
	exit 99
}

if [ "$1" = "" ]
then
	usage
fi
DATE="$1"
#DATE=`date -d "$1" +%Y%m%d`
#if test $? -ne 0
#then
#	usage
#fi
YEAR=`echo $DATE | cut -c1-4`
MONTH=`echo $DATE | cut -c5-6`
DAY=`echo $DATE | cut -c7-8`

#echo $YEAR
if [ "$YEAR" -lt "1990" ]
then
	usage
fi
if [ "$YEAR" -ge "1990" -a "$YEAR" -lt "2000" ]
then
	BATCH_YR=`echo $YEAR | cut -c4`
else
	case ${YEAR} in
		"2000") BATCH_YR="A"
			;;
		"2001") BATCH_YR="B"
			;;
		"2002") BATCH_YR="C"
			;;
		"2003") BATCH_YR="D"
			;;
		"2004") BATCH_YR="E"
			;;
		"2005") BATCH_YR="F"
			;;
		"2006") BATCH_YR="G"
			;;
		"2007") BATCH_YR="H"
			;;
		"2008") BATCH_YR="I"
			;;
		"2009") BATCH_YR="J"
			;;
		"2010") BATCH_YR="K"
			;;
		"2011") BATCH_YR="L"
			;;
		"2012") BATCH_YR="M"
			;;
		"2013") BATCH_YR="N"
			;;
		"2014") BATCH_YR="O"
			;;
		"2015") BATCH_YR="P"
			;;
		"2016") BATCH_YR="Q"
			;;
		"2017") BATCH_YR="R"
			;;
		"2018") BATCH_YR="S"
			;;
		"2019") BATCH_YR="T"
			;;
		"2020") BATCH_YR="U"
			;;
		"2021") BATCH_YR="V"
			;;
		"2022") BATCH_YR="W"
			;;
		"2023") BATCH_YR="X"
			;;
		"2024") BATCH_YR="Y"
			;;
		"2025") BATCH_YR="Z"
			;;
		"2026") BATCH_YR="a"
			;;
		"2027") BATCH_YR="b"
			;;
		"2028") BATCH_YR="c"
			;;
		"2029") BATCH_YR="d"
			;;
		"2030") BATCH_YR="e"
			;;
		"2031") BATCH_YR="f"
			;;
                "2032") BATCH_YR="g"
                        ;;
                "2033") BATCH_YR="h"
                        ;;
                "2034") BATCH_YR="i"
                        ;;
                "2035") BATCH_YR="j"
                        ;;
                "2036") BATCH_YR="k"
                        ;;
                "2037") BATCH_YR="l"
                        ;;
                "2038") BATCH_YR="m"
                        ;;
                "2039") BATCH_YR="n"
                        ;;
                "2040") BATCH_YR="o"
                        ;;
                "2041") BATCH_YR="p"
                        ;;
                "2042") BATCH_YR="q"
                        ;;
                "2043") BATCH_YR="r"
                        ;;
                "2044") BATCH_YR="s"
                        ;;
                "2045") BATCH_YR="t"
                        ;;
                "2046") BATCH_YR="u"
                        ;;
                "2047") BATCH_YR="v"
                        ;;
                "2048") BATCH_YR="w"
                        ;;
                "2049") BATCH_YR="x"
                        ;;
                "2050") BATCH_YR="y"
                        ;;
                "2051") BATCH_YR="z"
                        ;;
		*)  usage
			;;
	esac
fi

case ${MONTH} in
	"01") BATCH_MON="A"
		;;
	"02") BATCH_MON="B"
		;;
	"03") BATCH_MON="C"
		;;
	"04") BATCH_MON="D"
		;;
	"05") BATCH_MON="E"
		;;
	"06") BATCH_MON="F"
		;;
	"07") BATCH_MON="G"
		;;
	"08") BATCH_MON="H"
		;;
	"09") BATCH_MON="I"
		;;
	"10") BATCH_MON="J"
		;;
	"11") BATCH_MON="K"
		;;
	"12") BATCH_MON="L"
		;;
	*)  usage
		;;
esac

BATCH_YRMONDAY=$BATCH_YR$BATCH_MON$DAY
echo $BATCH_YRMONDAY

exit 0
