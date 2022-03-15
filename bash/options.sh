#!/bin/bash

# Variables

# Functions

function usage () {
    echo "Syntax: `basename "$0"` [-h|d]"
    echo "options:"
    echo "h     Print this Help"
    echo "d     The target directory name"

    exit
}

# Main code

while getopts ":hd:" option; do
   case $option in
      h) 
         usage
         ;;
      d) 
         directoryName=$OPTARG
         ;;
     \?) 
         usage
         ;;
   esac
done

if [ -z "${directoryName}" ]; then
   usage
fi

echo "directoryName = " ${directoryName}