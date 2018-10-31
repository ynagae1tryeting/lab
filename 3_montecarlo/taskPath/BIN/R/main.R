# --- SiSnの結晶構造配置の、モンテカルロシミュレーション
# --- ダイアモンド構造を、2原子ペアのFCC構造として、AuCu(FCC)モンテカルロシミュレーションをお手本にコーディングしたもの。
# --- Si-Sn：A配置(0), Si-Si：B配置(-1), Sn-Sn：C配置(1)として、原子配置を計算する。
# --- 1000*1000の2次元でシミュレーション。7.5%だと単純に75000個Sn原子いる。
# --- 温度依存のchemical potentialを導入すべきだが、まずは簡単に0Kの第一原理データからシミュレーションする。

source("./function.R")

# --- 初期条件パラメータ入力
KB <- 8.6173303*10^(-5) # Boltzmann定数…　eV/K
T <- 1000     # --- 計算する温度条件
k <- 200     # --- セルのメッシュ数。k*kのモデルを作成する。
SnPercent <- 0.075 # --- 作成するモデルに含まれるSnの数
MCS <- 150 # --- MCSステップの数

# --- 0K におけるHFE
myuA <- -35.441254 / 4
myuB <- -42.913069 / 4
myuC <- -30.486315 / 4

# --- 初期状態のcellを作成
cell <- make2Dcell(mesh=k,SnPercent)
cellRatio <- cellRatio(cell)
Etotal <- cellRatio[1,1] * myuA + cellRatio[1,2] * myuB + cellRatio[1,3] * myuC # --- totalE計算

x <- k/10*(1:nrow(cell));   y <- k/10*(1:ncol(cell))
png(
    paste("~/Desktop/500K/step0.png",sep=""),
    width     = 3.25,
    height    = 3.25,
    units     = "in",
    res       = 1200,
    pointsize = 4
    )
par(
    mar      = c(5, 5, 2, 2),
    xaxs     = "i",
    yaxs     = "i",
    cex.axis = 2,
    cex.lab  = 1
)
the_plot()
dev.off()

# --- MCS計算ステップ
for (l in 1:MCS){
    cell <- MCS.binaryalloy.2D(cell)
    png(
    paste("~/Desktop/500K/step",l,".png",sep=""),
    width     = 3.25,
    height    = 3.25,
    units     = "in",
    res       = 1200,
    pointsize = 4
    )
par(
    mar      = c(5, 5, 2, 2),
    xaxs     = "i",
    yaxs     = "i",
    cex.axis = 2,
    cex.lab  = 1
)
the_plot()
dev.off()
}

#system("ffmpeg -r 2 -i step%2d.png test.mp4")
#image(x, y, cell, col = terrain.colors(100), axes = T)
#saveRDS(cell, "~/Desktop/cellAfter150MCS_Sn20percent_T200K.obj")

