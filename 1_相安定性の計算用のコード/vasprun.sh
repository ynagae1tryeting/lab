#!/bin/bash

# --- srcファイルの読み込み
srcpath=./src/*.sh ; for i in $srcpath ; do . $i; done

BM.Vasprun.Slack

BM.Integrateddata

#phonopy-qha -b e-v.dat

#MBJ.MakeInput