#!/bin/bash
. ./functions.sh

BM.MakeInput

BM.Clean

BM.Vasprun

BM.Integrateddata

phonopy-qha -b e-v.dat

MBJ.MakeInput