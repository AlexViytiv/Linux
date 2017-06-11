#!/bin/bash

# Author | Oleksandr Viytiv
# E-mail | sviytiv@gmail.com

# Program realize float numbers division in bash. 
# At the beginning it takes 3 arguments :
#		- first 	- float (divided)
# 		- second 	- float (divisor)
#		- third 	- accuracy (number of digits after float point)
# -------------------------------------------------------------------------------

# Input format checking - minimal number of required arguments
# -------------------------------------------------------------------------------
if [[ $# -le 1 ]]; then
	echo " [error ] | input format : <command> <divided> <divisor> {<precision>}"
	exit 1;
fi

# Checking format of arguments via regular expressions for variables 
# and accuracy value
# -------------------------------------------------------------------------------
RegExPar='^-?[0-9]+([.][0-9]+)?$'
RegExAcc='^([0-9]+)?$'
if ! [[ $1 =~ $RegExPar ]] ; then
   echo " [error] | First argument have a false format."; exit 1
fi
if ! [[ $2 =~ $RegExPar ]] ; then
   echo " [error] | Second argument have a false format."; exit 1
fi
if ! [[ $3 =~ $RegExAcc ]] ; then
   echo " [error] | Third argument have a false format."; exit 1
fi

# First variable - divided - processing. Variables :
# 		- FST 		- divided
# 		- SZNFST 	- number of digits in divided
# 		- SIGNFST	- sign of divided
#		- SZAFST	- number of all digits and float points in number
#		- IFST		- integer part of divided
#		- SZIFST	- number of digits in $IFST
#		- DOTFST	- position of float point in number
# -------------------------------------------------------------------------------
FST=$1
SZNFST=${FST//.}
SIGNFST='+'
if [[ SZNFST -lt 0 ]]; then
	SIGNFST='-'
	FST=${FST//-}
fi
SZAFST=${#FST}
SZNFST=${#SZNFST}
IFST=${FST%.*}
SZIFST=${#IFST}
if [[ $SZIFST -gt $SZAFST ]]; then
	DOTFST=$(($SZIFST+1))
else 
	DOTFST=$SZIFST
fi

# Second variable - divisor - processing. Variables :
# 		- SND 		- divisor
# 		- SZNSND 	- number of digits in divisor
# 		- SIGNSND	- sign of divisor
#		- SZASND	- number of all digits and float points in number
#		- ISND		- integer part of divisor
#		- SZISND	- number of digits in $ISND
#		- DOTSND	- position of float point in number
# -------------------------------------------------------------------------------
SND=$2
SZNSND=${SND//.}
SIGNSND='+'
if [[ SZNSND -lt 0 ]]; then
	SIGNSND='-'
	SND=${SND//-}
fi
SZASND=${#SND}
SZNSND=${#SZNSND}
ISND=${SND%.*}
SZISND=${#ISND}
if [[ $SZISND -gt $SZASND ]]; then 
	DOTSND=$(($SZISND+1))
else
	DOTSND=$SZISND
fi

# Checking accuracy argument and shaping it. 
# -------------------------------------------------------------------------------
[[ $# -eq 3 ]] && ACC=$3 || ACC=1
if [[ $ACC -lt 1 ]]; then
	echo " [warning] | Accuracy cannot be lower than 1. It was automaticaly set to 1."
	ACC=1
fi

# Preprocessing divided and divisor and zero-division prediction
# -------------------------------------------------------------------------------
FST=$((10#${FST//.}))
SND=$((10#${SND//.}))
if [[ $SND -eq 0 ]]; then
	echo " [error] | Second argument cannot be 0."; exit 1
fi

# Calculation of integer part of result and getting float point position
# -------------------------------------------------------------------------------
[[ $(($FST/$SND)) -eq 0 ]] && RES="" || RES="$(($FST/$SND))"
RDIF=${#RES}

# Calculation of float part of number
# -------------------------------------------------------------------------------
TACC=$ACC
while [[ $TACC -ge 0 ]]; do
	FST="$(($FST % $SND))0"
	RES="${RES}$(($FST/$SND))"
	TACC=$(($TACC-1))
done

# Formatting result in order to arguments sizes and required accuracy 
# -------------------------------------------------------------------------------
if [[ $DOTFST -gt $DOTSND  ]]; then
	RES="${RES:0:RDIF}.${RES:RDIF:ACC}"
elif [[ $DOTFST -lt $DOTSND ]]; then
	while [[ $RDIF -gt 1 ]];	do
		RES="0${RES}"
		RDIF=$(($RDIF-1))
	done
	RES="0.${RES:0:$ACC}"
else
	if [ ${1//.} -gt ${2//.} ]; then
		RES="${RES:0:1}.${RES:1:ACC}"
	else
		RES="0.${RES:0:ACC}"
	fi
fi

# Defining sign of result, based on arguments signs & output result
# -------------------------------------------------------------------------------
if [ $SIGNFST == '-' -a $SIGNSND == '+' -o $SIGNFST == '+' -a $SIGNSND == '-' ]; then
	RES="-$RES"
fi
echo "Result : $RES"
