#!/bin/bash
# loop forever
EXBLOCKNUMBER=0 
G=geth
P=/blockchain/ethereum/geth.ipc

while true
do
  # start threads
   blockNumber=$($G --exec "eth.blockNumber" attach $P)
   if [ $blockNumber -gt $EXBLOCKNUMBER ];then
    for i in `seq 0 50`
     do
      EXBLOCKNUMBER=$(($EXBLOCKNUMBER+1)) 
      echo "count: $(( $EXBLOCKNUMBER))"
       echo "process id $$"
      ./gethmonitor.sh $(( $EXBLOCKNUMBER )) &
      # /path/to/script/A &
     # EXBLOCKNUMBER=$(( $i ))
      sleep 5
    done
    echo "outside: $(( $EXBLOCKNUMBER))"
   fi
  sleep 5m
done
