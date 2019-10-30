#!/bin/bash
for i in {1,"distance","danger","check",6}   
do
    echo "name this the value $i"
done

num=1
while [ $num -le 7 ];
do 
    echo "while loop"
    num=$((num+1))
done