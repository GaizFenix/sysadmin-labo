#!/bin/bash

mkdir -p mensajenombres

while read -r line
do
	sed s/NOMBRE/${line}/g cuerpo.txt > mensajenombres/${line}.txt
	echo "Done message for ${line}"
done < nombres.txt
