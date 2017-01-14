#!bin/bash

# ------------
# Birch Murnaghan計算の入力を作成するスクリプト
# 実行ディレクトリ中に存在するdirectryに対して再帰的に実行
# directry内に/BMが作成され、その中に、格子定数を変化させたものが生成
# ------------

LF=$(printf '\\\012_') #sed 挿入コマンド用
LF=${LF%_}             #sed 挿入コマンド用


###  $1...ディレクトリの名前($i)    $2...POSCARの格子定数(lat)
function BM () {
    for k in `seq -10 10`; do
        lat_slide=`echo "scale=7; $2 * (100 + $k) / 100"  | bc` #格子定数計算k%だけlatから調整
        if [ $k -lt 0 ]; then
            mkdir $1/BM/minus${k##-}
            cat $1/POSCAR | sed -e "2s/^/${lat_slide}${LF}/" | sed -e 3d > $1/BM/minus${k##-}/POSCAR
            cp  $1/POTCAR $1/BM/minus${k##-}/POTCAR
            cp  $1/INCAR $1/BM/minus${k##-}/INCAR
            cp  $1/KPOINTS $1/BM/minus${k##-}/KPOINTS
        else
            mkdir $1/BM/$k
            cat $1/POSCAR | sed -e "2s/^/${lat_slide}${LF}/" | sed -e 3d > $1/BM/$k/POSCAR
            cp  $1/POTCAR $1/BM/$k/POTCAR
            cp  $1/INCAR $1/BM/$k/INCAR
            cp  $1/KPOINTS $1/BM/$k/KPOINTS
        fi
    done
}

### BM中にdirectry名の数字だけ参考の格子定数から調整してPOSCAR作って格納
### DFPT計算回す
function BM.MakeInput() {
    filepath=./*
        for i in $filepath; do
            if [ ! -e $i/POSCAR ]; then
                cecho red "please put proper POSCAR in $i"
            fi
            if [ -d $i ]; then
                if [ ! -e $i/BM ]; then
                    mkdir $i/BM
                fi
                lat=`sed -n 2p $i/POSCAR` #POSCARの格子定数を取得
                BM $i $lat #BM用の計算ディレクトリ作成関数
            fi
    done
}

### BMを削除する関数
function BM.Clean () {
    filepath=./*
    for i in $filepath; do
        if [ -e $i/BM ]; then
        rm -fr $i/BM
        fi
    done
}

function BM.prep () {
    echo "Birch Murnaghan計算用directryを作成しますか？\n (Y/n)"
    read ans
    if [ "$ans" = "Y" ] ; then
       echo "directryを作成します"
       BM.MakeInput
       echo "作成終了"
    elif [ "$ans" = "n" ] ; then
       echo "終了します"
    else
       echo "不正な値"
    fi
}