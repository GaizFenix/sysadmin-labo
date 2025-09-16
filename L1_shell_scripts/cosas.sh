#!/bin/bash

echo "Creating folder named cosas..."
mkdir cosas

echo "Creating empty files inside folder..."
cd cosas
for num in {0..99}
do
	man -P cat ls | sed -n "${num}p" > fich$num.txt
done
echo "Finished creating files"
