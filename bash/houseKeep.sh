#!/bin/bash

# Variables

delDays=3
compressDays=2
location=/applogs/ts-app
filePattern="*.log"

# Functions

function usage () {
    echo "Syntax: `basename "$0"` [-h|d|c|p]"
    echo "options:"
    echo "h     Print this Help"
    echo "c     Number of days before files are compressed"
    echo "d     Number of days before files are deleted"
    echo "p     Pattern for files to delete"

    exit
}

# Main code

while getopts "hd:c:p:" option; do
   case $option in
      h) 
         usage
         ;;
      d) 
         delDays=$OPTARG
         ;;
      c) 
         compressDays=$OPTARG
         ;;
      p) 
	 filePattern=$OPTARG
         ;;
     \?) 
         usage
         ;;
   esac
done

find $location -type f -name "${filePattern}" -mtime +${compressDays} -exec gzip -v {} \;

find $location -type f -name "${filePattern}.gz" -mtime +${delDays} -exec rm -fv {} \;

