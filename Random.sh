#!/bin/bash

if [ $# -eq 2 ]; then my_start=$1; my_finish=$2; else my_start=1; my_finish=10; fi

for parm in $*; do echo "[" $parm "]."; done

my_counter=$my_start

date
while [ $my_counter -le $my_finish ]
do
	echo "[" $my_counter "] = [" $RANDOM "]"
	sleep 0.125
	my_counter=$(( $my_counter + 1 ))
done

echo ""
date
for current_number in $(seq "$my_start" "$my_finish")	# For example: {1..10}
do
	echo "[" $current_number "] = [" $RANDOM "]"
	sleep 0.125
done

echo ""
echo "Exit Code: [" $? "]."
