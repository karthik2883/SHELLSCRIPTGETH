
#!/bin/bash

GETHATTACH(){
   echo "/********************************************/"
   echo "/******** MORE THAN 2 LAC ACC  **********/"
   echo "/******** ETH 6000 BLOCK IN A DAY  **********/"
   echo "/******** SO CREATE CHECK AND REMOVE  ********/"
   echo "/*********************************************/"
 
   #CONSTANT
   G=geth
   PATH=/blockchain/ethereum/geth.ipc
   BLK_NU_COST=0
   TR_CNT=0
   EXBLOCKNUMBER=blocknumber 

   MYSQL_HOST="localhost"
   MYSQL_USER="root"
   MYSQL_PASS="orange@123"
   MYSQL_DB="Ethmapping"

   #WHILE WILL KEEP ALIVE  
   while [ true ];
   do
   for i in `seq 0 10`
   do
    EXBLOCKNUMBER=$(($EXBLOCKNUMBER+1)) 
     if [ $EXBLOCKNUMBER ];then
          ethtranscount=$($G --exec "eth.getBlockTransactionCount($EXBLOCKNUMBER)" attach $PATH)
          #ethtranscount !
          if [ $EXBLOCKNUMBER != $BLK_NU_COST && ! -z "$ethtranscount"];then
                  echo "blocknumber :" $BLK_NU_COST , "count :" $ethtranscount
                  if [ $ethtranscount != 0  ]; then
                          blockinfo=$($G --exec "JSON.stringify(eth.getBlock($EXBLOCKNUMBER))" attach $PATH)
                          if [[   "$blockinfo" != ""  &&   "$EXBLOCKNUMBER" != 0 ]];then
                                 
                                     echo "/******************/"
                                     echo "/***** MKDIR *******/"
                                     mkdir $EXBLOCKNUMBER
                                     cd  $EXBLOCKNUMBER
                                  
                                     echo "/***** SAVE BLOCK INFO IN A FILE *******/"
                                     echo "$blockinfo" >> $EXBLOCKNUMBER"_txt.json" 
                                     echo "/***** find and replace forwardslashes *******/"
                                   
                                     rp=$(sed 's/\\//g' $EXBLOCKNUMBER"_txt.json")
                                     echo  $rp > $EXBLOCKNUMBER"_txt.json" 

                                     echo "/***** REPLACE DOUBLE QUOTE { *******/"
                                    
                                     rpfstbracket=$(sed -i 's/"{/{/g' $EXBLOCKNUMBER"_txt.json")
                                 
                                     echo "/***** REPLACE DOUBLE QUOTE } *******/"
                                  
                                     rplstbracket=$(sed -i 's/}"/}/g' $EXBLOCKNUMBER"_txt.json")
                                     
                                     echo "/***** SAVE ACCOUNTS *******/"
                                     exaccounts=$($G --exec "eth.accounts" attach $PATH)
                                     echo $exaccounts > account_txt.json 
                                                                        
 
                                     echo "/***** JQ LOOP *******/"
                                    
                                     jqlp=$(jq '.transactions[]' $EXBLOCKNUMBER"_txt.json")
                                     

                                   for trHash in $jqlp
                                   do 
                                        TR_CNT=$((TR_CNT+1))
                                        bT=$($G --exec "JSON.stringify(eth.getTransaction($trHash))" attach $PATH)
                                        
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
                                                   mysql -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS $MYSQL_DB -e "insert into ethtransaction(NULL,$jqlto ,$jqlfrom,$jqlhash,$jqlvalue,$jqlgasPrice);"
                                                   echo "insert into ethtransaction(NULL,$jqlto ,$jqlfrom,$jqlhash,$jqlvalue,$jqlgasPrice);\n" >>home/rammohan/sql/eth.sql
                                                   echo $jqlto ,$jqlfrom ,$jqlhash ,$jqlvalue ,$jqlgasPrice
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
                                   # rm -rf $EXBLOCKNUMBER
                                    
                          fi
                  fi
          fi
          BLK_NU_COST=$(( $EXBLOCKNUMBER ))
        
        fi
   # fi 
   done
   sleep 1
  done

  # $G --exec "eth.blockNumber" attach /opt/ethereum/geth.ipc 
  # $G  --exec "eth.accounts.length" attach /opt/ethereum/geth.ipc
  # $G  --exec "eth.accounts.length" attach /opt/ethereum/geth.ipc
  # $G --exec "eth.accounts[0]" attach  /opt/ethereum/geth.ipc  
}
GETHATTACH
