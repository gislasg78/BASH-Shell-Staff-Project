#!/bin/bash

my_var=1

if [ $# -gt 0 ]; then my_limit=$1; else my_limit=10; fi

date
while [ $my_var -le $my_limit ]
do
	echo "[" $my_var "] = [" $RANDOM "]"
	sleep 0.125
	my_var=$(( $my_var + 1 ))
done

my_var=1

echo ""
date
for current_number in {1..10}
do
	echo "[" $current_number "] = [" $RANDOM "]"
	sleep 0.125
done

echo ""
echo "Exit Code: [" $? "]."
