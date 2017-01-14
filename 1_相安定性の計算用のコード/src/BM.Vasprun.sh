#!bin/bash
 
# ------------
# Birch Murnaghan計算の入力を実行するスクリプト
# 実行ディレクトリ中に存在するdirectryに対して再帰的に実行
# directry内に/BMが作成されたものの中で、全てでVASPを実行する
# ------------

LF=$(printf '\\\012_') #sed 挿入コマンド用
LF=${LF%_}             #sed 挿入コマンド用

### 全てのdirectryで実行
function BM.Vasprun () {
    filepath=./*
    rootpath=`pwd`
    for i in $filepath; do
        if [ -e $i/BM ]; then # BMの中に移動
        for k in `seq -10 10`; do
            if [ $k -lt 0 ]; then # BMの中の各directryへ移動(filepathを取得してもいいと思う)
                cd $i/BM/minus${k##-}
                    vasp.exe -np16 > vasp.log
                    cd $rootpath
                else
                    cd $i/BM/$k
                    vasp.exe -np16 > vasp.log
                    cd $rootpath
                fi
            done
        fi
    done
}

### 全てのdirectryで実行
function BM.Vasprun.Slack () {
    filepath=./*
    rootpath=`pwd`
    for i in $filepath; do
        if [ -e $i/BM ]; then # BMの中に移動
        for k in `seq -10 10`; do
            if [ $k -lt 0 ]; then # BMの中の各directryへ移動(filepathを取得してもいいと思う)
                cd $i/BM/minus${k##-}
                    vasp.exe -np16 > vasp.log
                    sendSlack "計算途中結果報告bot(alice)" "現在計算中の${i}ディレクトリの${k}フォルダの計算が完了"
                    cd $rootpath
                else
                    cd $i/BM/$k
                    vasp.exe -np16 > vasp.log
                    sendSlack "計算途中結果報告bot(alice)" "現在計算中の${i}ディレクトリの${k}フォルダの計算が完了"
                    cd $rootpath
                fi
            done
        fi
    done
    sendSlack "計算途中結果報告bot(alice)" "現在計算中のqueすべてが完了"
}