# --- SiSnの結晶構造配置の、モンテカルロシミュレーション
# --- ダイアモンド構造を、2原子ペアのFCC構造として、AuCu(FCC)モンテカルロシミュレーションをお手本にコーディングしたもの。
# --- Si-Sn：A配置(0), Si-Si：B配置(-1), Sn-Sn：C配置(1)として、原子配置を計算する。
# --- 1000*1000の2次元でシミュレーション。7.5%だと単純に75000個Sn原子いる。
# --- 温度依存のchemical potentialを導入すべきだが、まずは簡単に0Kの第一原理データからシミュレーションする。

source("./function.R")
library(lattice)
library(tidyverse)


# --- 初期条件パラメータ入力
KB <- 8.6173303*10^(-5) # Boltzmann定数…　eV/K
T <- 1000     # --- 計算する温度条件
k <- 30     # --- セルのメッシュ数。k*kのモデルを作成する。
percent <- 0.2 # --- 作成するモデルに含まれるSnの数
MCS <- 200 # --- MCSステップの数

# --- 0K におけるHFE
myuA <- -35.441254 / 4
myuB <- -42.913069 / 4
myuC <- -30.486315 / 4

# --- 初期状態のcellを作成
cell <- make2Dcell(mesh=k,percent)
cellRatio <- cellRatio(cell)
Etotal <- cellRatio[1,1] * myuA + cellRatio[1,2] * myuB + cellRatio[1,3] * myuC # --- totalE計算

x <- k/10*(1:nrow(cell));   y <- k/10*(1:ncol(cell))
d <- melt(cell)
P <- ggplot(d, aes(x=Var1, y=Var2, fill=value))
P <- P + geom_tile()
P <- P + ggtitle(paste0(percent*100, "percent: ", 0, " MCS step"))
P
ggsave(paste0("./png/",percent*100,"_percent/step",0,".png"))

# --- MCS計算ステップ
for (l in 1:MCS){
    message(paste("step = ", l, sep=""))
    cell <- MCS.binaryalloy.2D(cell)
    message(paste("make png snapshot", sep=""))
    write.csv(cell, paste("./cell/",percent*100,"_percent/step",l,".csv", sep=""), quote=F, row.names=F)

    # 作図
    d <- melt(cell)
    P <- ggplot(d, aes(x=Var1, y=Var2, fill=value))
    P <- P + geom_tile()
    P <- P + ggtitle(paste0(percent*100, "percent: ", l, " MCS step"))
    P
    ggsave(paste0("./png/",percent*100,"_percent/step",l,".png"))
}

message("finished.")