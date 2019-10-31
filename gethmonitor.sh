
#!/bin/bash

GETHATTACH(){
   echo "/********************************************/"
   echo "/******** MORE THAN 2 LAC ACC  **********/"
   echo "/******** ETH 6000 BLOCK IN A DAY  **********/"
   echo "/******** SO CREATE CHECK AND REMOVE  ********/"
   echo "/*********************************************/"
 
   #CONSTANT
   g=geth
   path=/blockchain/ethereum/geth.ipc
   blk_nu_cost=0
   tr_cnt=0
   exblocknumber=blocknumber 
   #WHILE WILL KEEP ALIVE  
   while [ true ];
   do
    exblocknumber=$(($exblocknumber+1)) 
     if [ $exblocknumber ];then
          ethtranscount=$($g --exec "eth.getBlockTransactionCount($exblocknumber)" attach $path)
          if [ $exblocknumber != $blk_nu_cost ];then
                  echo "blocknumber :" $blk_nu_cost , "count :" $ethtranscount
                  if [ $ethtranscount != 0  ]; then
                          blockinfo=$($g --exec "JSON.stringify(eth.getBlock($exblocknumber))" attach $path)
                          if [[   "$blockinfo" != ""  &&   "$exblocknumber" != 0 ]];then
                                 
                                     echo "/******************/"
                                     echo "/***** MKDIR *******/"
                                     mkdir $exblocknumber
                                     cd  $exblocknumber
                                  
                                     echo "/***** SAVE BLOCK INFO IN A FILE *******/"
                                     echo "$blockinfo" >> $exblocknumber"_txt.json" 
                                     echo "/***** find and replace forwardslashes *******/"
                                   
                                     rp=$(sed 's/\\//g' $exblocknumber"_txt.json")
                                     echo  $rp > $exblocknumber"_txt.json" 

                                     echo "/***** REPLACE DOUBLE QUOTE { *******/"
                                    
                                     rpfstbracket=$(sed -i 's/"{/{/g' $exblocknumber"_txt.json")
                                 
                                     echo "/***** REPLACE DOUBLE QUOTE } *******/"
                                  
                                     rplstbracket=$(sed -i 's/}"/}/g' $exblocknumber"_txt.json")
                                     
                                     echo "/***** SAVE ACCOUNTS *******/"
                                     exaccounts=$($g --exec "eth.accounts" attach $path)
                                     echo $exaccounts > account_txt.json 
                                                                        
 
                                     echo "/***** JQ LOOP *******/"
                                    
                                     jqlp=$(jq '.transactions[]' $exblocknumber"_txt.json")
                                     

                                   for trHash in $jqlp
                                   do 
                                        tr_cnt=$((tr_cnt+1))
                                        bT=$($g --exec "JSON.stringify(eth.getTransaction($trHash))" attach $path)
                                        
                                        echo $bT > $tr_cnt.json
                                      
                                        rpt=$(sed 's/\\//g' $tr_cnt".json")
                                        echo  $rpt >$tr_cnt.json
                                        
                                        echo "/***** REPLACE DOUBLE QUOTE { *******/"
                                        rptfstbracket=$(sed -i 's/"{/{/g' $tr_cnt".json")
                                        
                                        echo "/***** REPLACE DOUBLE QUOTE } *******/"
                                        rptlstbracket=$(sed -i 's/}"/}/g' $tr_cnt".json")
                                        
                                        echo " /******** RUN 1 MORE LOOP   **********/"
                                        cat account_txt.json  | jq '.' > accounts.json                                      
                                       #  jqla=$(jq '.[]'  account_txt.json)
                                         jqlto=$(jq '.to'  $tr_cnt".json")
                                         jqlfrom=$(jq '.from'  $tr_cnt".json")
                                         jqlhash=$(jq '.hash'  $tr_cnt".json")
                                         jqlvalue=$(jq '.value'  $tr_cnt".json") 
                                         jqlgasPrice=$(jq '.gasPrice'  $tr_cnt".json") 
                                         
                                         
                                         #touch transaction.sql
                                        
                                        # for account in $jqla
                                         # do
                                               # echo "$account ,$jqlto "
                                                echo "/******** IF to IS EQUAL TO THE ACCOUNT ADDRESS **********/"
                                                 grep "$jqlto" accounts.json 
                                                if [ $? -eq 0 ];then
                                                   echo "insert into ethtransaction(NULL,$jqlto ,$jqlfrom,$jqlhash,$jqlvalue,$jqlgasPrice);\n" >>home/rammohan/sql/eth.sql
                                                   echo $jqlto ,$jqlfrom ,$jqlhash ,$jqlvalue ,$jqlgasPrice
                                                   echo " /******** SAVE IN MYSQL TABLE   **********/" 
                                                else
                                                    echo " /********NO MATCH RM FILE **********/"    
                                                    rm -rf $tr_cnt".json"
                                                fi
                                          #done
                                                                        
                                       
                                    done
                                    echo "/********COME OUT OF FOLDER **********/"
                                    cd ..
                                    echo "/********RM FOLDER **********/"
                                   # rm -rf $exblocknumber
                                    
                          fi
                  fi
          fi
          blk_nu_cost=$(( $exblocknumber ))
        
        fi
   # fi 
  done

  # $g --exec "eth.blockNumber" attach /opt/ethereum/geth.ipc 
  # $g  --exec "eth.accounts.length" attach /opt/ethereum/geth.ipc
  # $g  --exec "eth.accounts.length" attach /opt/ethereum/geth.ipc
  # $g --exec "eth.accounts[0]" attach  /opt/ethereum/geth.ipc  
}
GETHATTACH
