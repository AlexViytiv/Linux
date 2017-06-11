#!/bin/bash

# Author | Oleksandr Viytiv
# E-mail | sviytiv@gmail.com

# Program takes two parameters : (1) source directory; (2) name of new directory;
# -------------------------------------------------------------------------------
cd $1
mkdir $2
cd $2

echo -e "\n Program create files in $1/$2 directory. Please, wait ... "

# FOLDERS & FILES
# -------------------------------------------------------------------------------
FILES=1000
FOLDERS=100
ALLFILES=$(($FILES*$FOLDERS))

# Script create files in cycle in such way :
#             - names of directories by value of $i 
#             - names of variable files by value of $j variable
#
# Also files created by echo function through data thread redirection
# Files content defined by $i and $j values
# ------------------------------------------------------------------------------
for ((i=0; i < $FOLDERS; i++)); 
do
	mkdir $i ; cd $i	
	for ((j = 0; j < $FILES; j++)); 
	do
		echo "$i directory $j file" > $j.txt
		result=$((($i)*1000+$j+1))
		echo -ne "\r [files created : $result / $ALLFILES]     "
	done
	cd ..
done

# '\b' is used to remove from output '.' symbol of current directory
# ------------------------------------------------------------------------------
echo -e "\n Size of created files : $(du -bhs)\b bytes"  
echo -e '\n'
