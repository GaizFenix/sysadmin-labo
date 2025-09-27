#!/bin/bash

sum=0

for arg in "$@"
do
	sum=$((sum + arg))
done

rm "fich${sum}.txt"

echo "fich${sum}.txt deleted."
