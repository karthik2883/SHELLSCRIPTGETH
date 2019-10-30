#!/bin/bash

read -p "test Your case ? " arg

case   "$arg"  in
[0-3] | 1[1-2] )
echo "You have chosen [0-3] | [7-9]" ;;
[a-z]) 
echo "You have chosen a-b" ;;
[A-Z]) 
echo "You have chosen A-Z" ;;
*".txt")
echo "You have chosen txt" ;;
*)
echo "You have chosen default";;

esac