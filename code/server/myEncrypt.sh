#!/bin/bash
read -p "cmd:" cmd
read -s -p "input password:" password
here=`pwd`

function encrypt()
{
	Luas=`find . -name "*.lua"`
	for file in $Luas
	do
	    filename=`basename $file`
	    filedirname=`dirname $file`
	    if [ $cmd == 'encode' ];
		then
			echo 'encode'
			#openssl enc -aes256 -k $password -in $file -out $filedirname"/"$filename
			openssl enc -aes-128-cbc -k $password -in $file -out $filedirname"/new_"$filename
			mv $filedirname"/new_"$filename $file

		else
			echo 'decode'
   			#openssl enc -aes256 -k $password -d -in $file -out $filedirname"/"$filename
   			openssl enc -d -aes-128-cbc -k $password  -in $file -out $filedirname"/new_"$filename
   			mv $filedirname"/new_"$filename $file

		fi
	     
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
