#!/bin/bash
while :
do
	echo $(date -u) 
	echo "running"
	argo list | grep -i dummy |grep -i running | wc -l
	echo "pending"
	argo list | grep -i dummy |grep -i pending | wc -l
	echo "succeeded"
	argo list | grep -i dummy |grep -i succeeded | wc -l
	echo "***********************************************"
	sleep 2
done