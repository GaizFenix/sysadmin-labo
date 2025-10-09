#!/bin/bash

Min=100
Max=240

random=$((RANDOM % ($Max - $Min + 1) + $Min))
randomDec=$(($random/10)).$(($random % 10))


echo $randomDec
