#!/bin/bash

cd $1

for file in *.txt
do
	mv -- "$file" "${file%.txt}.t"
done

echo "Extensions changed (txt --> t)."
