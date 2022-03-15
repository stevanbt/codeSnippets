#!/bin/bash

# Variables

# Functions

function usage () {
    echo "Syntax: `basename "$0"` [-h|d]"
    echo "options:"
    echo "h     Print this Help"
    echo "d     The target directory name"

    exit 1
}

# Main code

while getopts ":hd:" option; do
   case $option in
      h) 
         usage
         ;;
      d) 
         dir=$OPTARG
         ;;
     \?) 
         usage
         ;;
   esac
done

if [ -z "${dir}" ]; then
   usage
fi

if [ ! -d "${dir}" ]; then
    echo The directory ${dir} doesn\'t exist, cannot continue
    exit 1
fi

for f in `ls ${dir}`; do
    echo ${dir}/${f}
done