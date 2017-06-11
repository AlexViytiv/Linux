#!/bin/bash

# Author | Oleksandr Viytiv
# E-mail | sviytiv@gmail.com

# Program takes 3 arguements: (1) Source location; (2) Name of directory in /tmp
#                             (3) Output format;
# 3rd parameter is optional. Program support 2 options :
# 		<none> - if 3rd parameter is absent, program shows only progress bar
#		-f	   - in this case, program shows copying progress in files.
#		-b	   - in this case, program shows copying progress in bytes.
#		-p 	   - in this case, program shows copying progress in percents.
# -------------------------------------------------------------------------------

# clear screen and set it size to 25 lines per 80 coloumns 
# (just for good view, because program can resize progress bar to 74 coloumns)
# -------------------------------------------------------------------------------
clear
printf '\033[8;25;80t'

# Strings used to show progress and 'sun'(loader)
# -------------------------------------------------------------------------------
FILL='##########################################################################'    
EMPT='..........................................................................'    
SPIN='-\|/'

# ALLFILES- variable that contain number of files in source sirectory
# tHeight - contain number of rows in current terminal
# fCopied - variable contain number of copied files. Uses to regulate progress
#			bar.
# FILENAME- full path to file
# Temp 	  - path to file inside source directory
# tWidth  - width of progress bar in coloumns
# Load	  - width of filled part of progress bar
# time 	  - time in seconds since 01/01/1970
# cLoad	  - defines view of 'sun'(loader)
# DSTSZ	  - destination directory size
# SRCSZ	  - source directory size
# DONE	  - defines string with information about copying. Makes the
#			script aesthetic
# DIFF	  - defines number of coloumns needed to insert progress information
# -------------------------------------------------------------------------------
ALLFILES=0
tHeight=0
fCopied=0;
FILENAME=""
Temp=""
tWidth=0
Load=0
time=0
cLoad=0
DSTSZ=0
SRCSZ=0
DONE=""
DIFF=0

# Getting number of all files in source location and height of terminal for 
# setting progress bar to bottom. 
# -------------------------------------------------------------------------------
ALLFILES=$(find $1 -type f | wc -l)
tHeight=$(tput lines)

# Calculation of source directory size and truncating unnecessary data
# -------------------------------------------------------------------------------
SRCSZ=$(du -bsh $1)
SRCSZ=${SRCSZ//[^0-9,KMGT]}

# Shifts progress bar to bottom
# -------------------------------------------------------------------------------
for((k=0; k<$(($tHeight/2)); k++));
do
	echo -e '\n'
done

# Setting value of DIFF
# -------------------------------------------------------------------------------
if [[ $# -eq 2 ]]; then
	DIFF=10
elif [ $# -eq 3 ];then
	if [ $3 == "-f" ]; then
		DIFF=30
	elif [ $3 == "-b" ]; then
		DIFF=30
	elif [ $3 == "-p" ]; then
		DIFF=15
	fi	
fi

# According to number of parameters and their value, program choose one of 4
# algorithms. Copying process is similar in every algorithm. 
# They are : 
#		- Default:  Program shows only progress bar
# 		- First : 	Program takes 3 arguments (3rd is '-f') and shows progress
#					of copying in files.
# 		- Second:  	Program takes 3 arguments (3rd is '-b') and shows progress
#					of copying in bytes. 
#		- Third : 	Program takes 3 arguments (3rd is '-p') and shows progress
#					of copying in percents.
# -------------------------------------------------------------------------------

mkdir /tmp/$2
DSTSZ=$(du -bsh /tmp/$2)
DSTSZ=${DSTSZ//[^0-9,KMGT]}

cp -r $1 /tmp/$2 &
while [[ $fCopied -lt $ALLFILES ]]; do
	fCopied=$(find /tmp/$2 -type f | wc -l)
	tWidth=$(($(tput cols)-$DIFF))
	Load=$(($fCopied*$tWidth/$ALLFILES))
	time=$(date +%s)
	cLoad=$(($time%4))

	if [ $# -eq 3 ];then
		if [ $3 == "-f" ]; then
			DONE="${fCopied}/${ALLFILES} files"
		elif [ $3 == "-b" ]; then
			DSTSZ=$(du -bsh /tmp/$2)
			DSTSZ=${DSTSZ//[^0-9,KMGT]}
			DONE="$DSTSZ/$SRCSZ bytes"
		elif [ $3 == "-p" ]; then
			Perc=$(($fCopied*100/$ALLFILES))
			DONE="$Perc %"
		fi	
	fi
	echo -ne "\r (${SPIN:cLoad:1}) [${FILL:0:$Load}${EMPT:$i:$tWidth-$Load}] $DONE "
done


# Shows user message about successfull end of operation.
# -------------------------------------------------------------------------------
echo -e "\n Files had been copied to /tmp/$2.\n"
