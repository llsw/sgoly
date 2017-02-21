#!/bin/bash
# 
# Luas=`find . -type f -name "*.bak"`
# for file in $Luas
# do
#     rm $file
# done
# 

here=`pwd`
LUAC=$here"/skynet/3rd/lua/luac"

function encrypt()
{
	Luas=`find . -name "*.lua"`
	for file in $Luas
	do
	    filename=`basename $file`
	    filedirname=`dirname $file`
	    echo $filedirname"/"$filename
	    $LUAC -o $filedirname"/"$filename $file
	done
     
}

cd $here"/cluster_database"
	encrypt
cd $here"/cluster_game"
	encrypt
cd $here"/cluster_gateway"
	encrypt
cd $here"/cluster_login"
	encrypt
cd $here"/cluster_rank"
	encrypt
cd $here"/cluster_shop"
	encrypt
cd $here"/cluster_test"
	encrypt
# cd $here"/clustername"
# 	encrypt
cd $here"/lualib"
	encrypt
