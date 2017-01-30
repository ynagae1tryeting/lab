#!/bin/bash

# 8原子・2元系の混晶の組み合わせ計算を行う
# 基準のPOSCARを一つずつ入れておくこと

LF=$(printf '\\\012') #sed 挿入コマンド用
LF=${LF%}             #sed 挿入コマンド用

###  ----- (2元混晶のPOSCARの体積を設定した%ずつ変化させて出力) -----
function BM.Integratedata () {
    filepath=./*
    rootpath=`pwd`
        for i in $filepath; do
        if [ -d $i ]; then  # --- directryのみに作用するという条件
                    echo "#cell_volume energy_of_cell" > $i/BM/e-v.dat  # e-v.dat初期化
            if [ -e $i/BM ]; then
                for k in `seq -10 10`; do
                    if [ $k -lt 0 ]; then
                        cd $i/BM/minus${k##-}
                        volline=`grep vol ./OUTCAR | tail -n 1`
                        set $volline
                        vol=$5
                        eneline=`grep TOTEN ./OUTCAR | tail -n 1`
                        set $eneline
                        ene=$5
                        e_v=`echo $vol $ene`
                        echo $e_v >> ../e-v.dat
                        cd $rootpath
                    else
                        cd $i/BM/$k
                        volline=`grep vol ./OUTCAR | tail -n 1`
                        set $volline
                        vol=$5
                        eneline=`grep TOTEN ./OUTCAR | tail -n 1`
                        set $eneline
                        ene=$5
                        e_v=`echo $vol $ene`
                        echo $e_v >> ../e-v.dat
                        cd $rootpath
                    fi
                done
            fi
        fi
        done
}