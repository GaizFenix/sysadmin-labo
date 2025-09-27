#!/bin/bash

case $1 in
	"name") sort -n -t ":" -k1 /etc/passwd
	;;
	"uid") sort -n -t ":" -k3 /etc/passwd
	;;
	"gid") sort -n -t ":" -k4 /etc/passwd
	;;
esac
