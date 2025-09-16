#!/bin/bash

echo "Please write something: "
read comm

if command -v $comm >/dev/null; then
	echo "$comm IS a system command"
else
	echo "$comm IS NOT a system command"
fi
