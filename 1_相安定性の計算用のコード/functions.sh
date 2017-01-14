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

function MBJ.MakeInput() {
    filepath=./*
        for i in $filepath; do
        mkdir $i/MBJ
            if [ ! -e $i/BM/CONTCAR ]; then
                cecho red "please perform BM.Vasprun in $i"
            fi
            if [ -d $i ]; then
                if [ ! -e $i/BM ]; then
                    mkdir $i/BM
                fi
                for k in `seq -10 10`; do
                        if [ $k -lt 0 ]; then
                            mkdir $i/BM/minus${k##-}
                            cat $i/POSCAR | sed -e "2s/^/${lat_slide}${LF}/" | sed -e 3d > $i/BM/minus${k##-}/POSCAR
                            cp  $i/POTCAR $i/BM/minus${k##-}/POTCAR
                            cp  $i/INCAR $i/BM/minus${k##-}/INCAR
                            cp  $i/KPOINTS $i/BM/minus${k##-}/KPOINTS
                        else
                            mkdir $i/BM/$k
                            cat $i/POSCAR | sed -e "2s/^/${lat_slide}${LF}/" | sed -e 3d > $i/BM/$k/POSCAR
                            cp  $i/POTCAR $i/BM/$k/POTCAR
                            cp  $i/INCAR $i/BM/$k/INCAR
                            cp  $i/KPOINTS $i/BM/$k/KPOINTS
                        fi
                done
            fi
    done
}



#  ----- (INCAR,POTCAR,KPOINTS,POSCARの存在を確認して、順次計算) -----


#  ----- (directry中の計算結果を一つのデータにまとめて、phonopyで回せるようにする) -----

#  ----- (phonopyで最安定の体積をBMfittingで計算、その出力を各原子配置ごとでまとめる) -----


#  ----- (温度依存を考えて、0,100,200,1500(16種類)の温度の体積に各POSCARを出力、INCARを原子位置の最適化でset) -----

#  ----- (phonopyでhelmholtz free energy計算) -----

#  ----- (INCAR,POTCAR,KPOINTS,POSCARの存在を確認して、順次計算) -----