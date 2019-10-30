#!/bin/bash
read -p "enter the number" num1 
if [ ${num1} -eq 10 ]; then
echo "equal number"
elif [ ${num1} -eq 2 ]; then
echo "it is equal "
else
echo "not equal"
fi
echo "bye"