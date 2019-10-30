#!/bin/bash
echo "exit 1"
echo "exit 2"
echo "exit 3"
#exit
echo "exit 4"

read -p "what is your age? " age
# if [ ${age} -lt 0 -o ${age} -gt 200 ]; then
# echo "age is lower than required state"
# exit
# else
# echo "fine lets get in"
if [ -z "$age" ]; then
echo "empty age"
exit
fi
echo "move in"