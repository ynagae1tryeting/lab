#!/bin/bash

red=31
green=32
yellow=33
blue=34

function usage {
    cat <<EOF
$(basename ${0}) is a tool for ...

Usage:
    $(basename ${0}) [command] [<options>]

Options:
    --version, -v     print $(basename ${0}) version
    --help, -h        print this
EOF
}

function version {
    echo "$(basename ${0}) version 0.0.1 "
}  


function cecho {
    color=$1
    shift
    echo -e "\033[${color}m$@\033[m"
}


#  directry中のすべてのファイルを読み込み、vaspを実行
function vasprun() {
    filename=./*
    for i in $filename ; do
        if [ -d $filename] ; then
            cd $filename
            vasp.exe np-16 > vasp.log
            cd ../
        fi
    done
}





case ${1} in 
    start) start ;;
    stop) stop ;;
    restart) start && stop ;;
    help|--help|-h) usage ;;
    version|--version|-v) version ;;
    *) echo "[ERROR] Invalid subcommand '${1}'" 
       usage
       exit 1 ;;
esac



#!bin/sh
#vasp_BMEOS.sh

#設定ファイルの読み込み
. ./conf_BMEOS.txt

echo "コア数は？(16)"
read core

cd ./BM

$nn=$(( n + 1 ))
for i in `seq 1 $nn`
do
cd ./$i
vasp.exe np-$core > vasp.log 
cd ../
done