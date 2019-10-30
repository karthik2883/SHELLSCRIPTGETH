#!/bin/bash
MYSQL_HOST="localhost"
MYSQL_USER="root"
MYSQL_PASS="om!t$1166"
MYSQL_DB="gethinfo"
 
GETHATTACH(){
   local g=geth 
   echo "$g"
   #geth --exec "eth.blockNumber" --exec "eth.account.length"   attach /opt/ethereum/geth.ipc 
   #mysql -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS $MYSQL_DB -e 
  # "CREATE TABLE balance_history_$i LIKE balance_history_example;"

     
}
GETHATTACH 

GETHATTACH(){
   g=geth
   num=1
   ex= $g --exec "eth.blockNumber" attach /opt/ethereum/geth.ipc
   while [ true ];
   do
     echo "while loop"
     num=$((num+1))
     if [ $num -gt 7 ]; then
      exit
     else
     echo $ex
    # $g --exec "eth.blockNumber" attach /opt/ethereum/geth.ipc
    fi
  done
  # $g --exec "eth.blockNumber" attach /opt/ethereum/geth.ipc 
  # $g  --exec "eth.accounts.length" attach /opt/ethereum/geth.ipc
  # $g  --exec "eth.accounts.length" attach /opt/ethereum/geth.ipc
  # $g --exec "eth.accounts[0]" attach  /opt/ethereum/geth.ipc  
}
GETHATTACH


 