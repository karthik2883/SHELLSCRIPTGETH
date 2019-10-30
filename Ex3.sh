#!/bin/bash

for i in {1..4}
do
touch $i"file.jpg"
echo "$i file.txt"
done
chr=""
while [ "$chr" != "j" ];
do
 echo "please enter j"
 read chr
done
