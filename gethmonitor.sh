#!/bin/bash

#GETHATTACH(){
   echo "/********************************************/"
   echo "/******** MORE THAN 2 LAC ACC  **********/"
   echo "/******** ETH 6000 BLOCK IN A DAY  **********/"
   echo "/******** SO CREATE CHECK AND REMOVE  ********/"
   echo "/*********************************************/"
 
   #CONSTANT
   G=geth
   P=/blockchain/ethereum/geth.ipc
   #P=/opt/ethereum/geth.ipc
   BLK_NU_COST=0
   TR_CNT=0
  # EXBLOCKNUMBER=0 

   MYSQL_HOST="127.0.0.1"
   MYSQL_USER="root"
   MYSQL_PASS="Everus@crypto2017$"
   MYSQL_DB="ethmapping"

   #WHILE WILL KEEP ALIVE  
      echo "process id inside gethmonitor $$"
      EXBLOCKNUMBER=$(( $1 )) 
      #echo $EXBLOCKNUMBER 	
      if [ $EXBLOCKNUMBER ];then
          ethtranscount=$($G --exec "eth.getBlockTransactionCount($EXBLOCKNUMBER)" attach $P)
	       #  echo $ethtranscount
          if [ $EXBLOCKNUMBER != $BLK_NU_COST  ];then
                  echo "blocknumber :" $EXBLOCKNUMBER , "count :" $ethtranscount
                  if [ $ethtranscount != 0  ]; then
                          blockinfo=$($G --exec "JSON.stringify(eth.getBlock($EXBLOCKNUMBER))" attach $P)
                          if [[   "$blockinfo" != ""  &&   "$EXBLOCKNUMBER" != 0 ]];then
                                 
                                   #  echo "/******************/"
                                   #  echo "/***** MKDIR *******/"
                                     mkdir $EXBLOCKNUMBER
                                     cd  $EXBLOCKNUMBER
                                  
                                    # echo "/***** SAVE BLOCK INFO IN A FILE *******/"
                                     echo "$blockinfo" >> $EXBLOCKNUMBER"_txt.json" 
                                    # echo "/***** find and replace forwardslashes *******/"
                                   
                                     rp=$(sed 's/\\//g' $EXBLOCKNUMBER"_txt.json")
                                     echo  $rp > $EXBLOCKNUMBER"_txt.json" 

                                    # echo "/***** REPLACE DOUBLE QUOTE { *******/"
                                    
                                     rpfstbracket=$(sed -i 's/"{/{/g' $EXBLOCKNUMBER"_txt.json")
                                 
                                    # echo "/***** REPLACE DOUBLE QUOTE } *******/"
                                  
                                     rplstbracket=$(sed -i 's/}"/}/g' $EXBLOCKNUMBER"_txt.json")
                                     
                                    # echo "/***** SAVE ACCOUNTS *******/"
                                     exaccounts=$($G --exec "eth.accounts" attach $P)
                                     #echo
                                    # echo $exaccounts > account_txt.json 
                                                                        
 
                                     echo $exaccounts > account_txt.json
                                     cat  account_txt.json  | jq '.' > accounts.json
                                    
                                     jqlp=$(jq '.transactions[]' $EXBLOCKNUMBER"_txt.json")
                                     

                                   for trHash in $jqlp
                                   do 
                                        TR_CNT=$((TR_CNT+1))
                                        bT=$($G --exec "JSON.stringify(eth.getTransaction($trHash))" attach $P)
                                        
                                        echo $bT > $TR_CNT.json
                                      
                                        rpt=$(sed 's/\\//g' $TR_CNT".json")
                                        echo  $rpt >$TR_CNT.json
                                        
                                        echo "/***** REPLACE DOUBLE QUOTE { *******/"
                                        rptfstbracket=$(sed -i 's/"{/{/g' $TR_CNT".json")
                                        
                                        echo "/***** REPLACE DOUBLE QUOTE } *******/"
                                        rptlstbracket=$(sed -i 's/}"/}/g' $TR_CNT".json")
                                        
                                        echo " /******** RUN 1 MORE LOOP   **********/"
                                        cat account_txt.json  | jq '.' > accounts.json                                      
                                       #  jqla=$(jq '.[]'  account_txt.json)
                                         jqlto=$(jq '.to'  $TR_CNT".json")
                                         jqlfrom=$(jq '.from'  $TR_CNT".json")
                                         jqlhash=$(jq '.hash'  $TR_CNT".json")
                                         jqlvalue=$(jq '.value'  $TR_CNT".json") 
                                         jqlgasPrice=$(jq '.gasPrice'  $TR_CNT".json") 
                                         
                                         
                                         #touch transaction.sql
                                        
                                        # for account in $jqla
                                         # do
                                               # echo "$account ,$jqlto "
                                                 echo "/******** IF to IS EQUAL TO THE ACCOUNT ADDRESS **********/"
                                                 grep "$jqlto" accounts.json 
                                                if [ $? -eq 0 ];then
                                                  NOW=$(date +'%F %T')
                                                  #  DATE_WITH_TIME=`date "+%Y-%m-%d %H %M %S"`
                                                    mysql  -u$MYSQL_USER -p$MYSQL_PASS $MYSQL_DB -e "insert into ethtransaction values($jqlto ,$jqlfrom,$jqlhash,$jqlvalue,$jqlgasPrice,NULL,'$NOW');"
                                                   echo "insert into ethtransaction values($jqlto ,$jqlfrom,$jqlhash,$jqlvalue,$jqlgasPrice,NULL,'$NOW');" >>/home/rammohan/sql/eth.sql
                                                  # echo $jqlto ,$jqlfrom ,$jqlhash ,$jqlvalue ,$jqlgasPrice
                                                   echo " /******** SAVE IN MYSQL TABLE   **********/" 
                                                else
                                                    echo " /********NO MATCH RM FILE **********/"    
                                                    rm -rf $TR_CNT".json"
                                                fi
                                          #done
                                                                        
                                       
                                    done
                                    echo "/********COME OUT OF FOLDER **********/"
                                    cd ..
                                    echo "/********RM FOLDER **********/"
                                    rm -rf $EXBLOCKNUMBER
                                    
                          fi
                  fi
          fi
          BLK_NU_COST=$(( $EXBLOCKNUMBER ))
        
        fi
   # fi 
     

  # $G --exec "eth.blockNumber" attach /opt/ethereum/geth.ipc 
  # $G  --exec "eth.accounts.length" attach /opt/ethereum/geth.ipc
  # $G  --exec "eth.accounts.length" attach /opt/ethereum/geth.ipc
  # $G --exec "eth.accounts[0]" attach  /opt/ethereum/geth.ipc  
#}
#GETHATTACH
