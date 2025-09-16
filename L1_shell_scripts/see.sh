#!/bin/bash

if [ $# -eq 0 ]; then
	echo "Usage: $0 <path>"
	exit 1
fi

if [ -d $1 ]; then
	ls $1
elif [ -f $1 ]; then
	more $1
else
	echo "$1 is not a valid argument"
fi
