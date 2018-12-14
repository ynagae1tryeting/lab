source("./function.R")
library(lattice)
library(tidyverse)

percent <- 0.2

centers2percent <- function(x, d, percent, thr){

    for(N in 0:(nrow(d)/2)){
        #message(paste(N, " / ", nrow(d)/2, sep=""))
        # 該当の座標に入っている記号を抽出
        i <- x[1]
        j <- x[2]
        i_1 <- seq(i-N, i+N)
        j_1 <- seq(j-N, j+N)
        i_2 <- seq(i-N-1, i+N+1)
        j_2 <- seq(j-N-1, j+N+1)

        # 周期境界を超える配置を規格化
        if(sum(i_1[i_1 > nrow(d)]) != 0){
            i_1[i_1 > nrow(d)] <- i_1[i_1 > nrow(d)] - nrow(d)
        }
        if(sum(j_1[j_1 > nrow(d)]) != 0){
            j_1[j_1 > nrow(d)] <- j_1[j_1 > nrow(d)] - nrow(d)
        }
        if(sum(i_2[i_2 > nrow(d)]) != 0){
            i_2[i_2 > nrow(d)] <- i_2[i_2 > nrow(d)] - nrow(d)
        }
        if(sum(j_2[j_2 > nrow(d)]) != 0){
            j_2[j_2 > nrow(d)] <- j_2[j_2 > nrow(d)] - nrow(d)
        }

        index <- 0
        for(I in i_1){
            for(J in j_1){
                index <- c(index, D[((D[,1]==c(I)) * (D[,2]==J))==1 ,3])
            }
        }
        index <- index[-1]
        N_Sn_1 <- sum(index==0) * 1 + sum(index==1) * 2
        N_Si_1 <- sum(index==-1) * 2 + sum(index==0) * 1

        index <- 0
        for(I in i_2){
            for(J in j_2){
                index <- c(index, D[((D[,1]==c(I)) * (D[,2]==J))==1 ,3])
            }
        }
        index <- index[-1]
        N_Sn_2 <- sum(index==0) * 1 + sum(index==1) * 2
        N_Si_2 <- sum(index==-1) * 2 + sum(index==0) * 1

        # N_Sn_1とN_Sn2が同じ時、Siに囲まれていると判断してループを終了する
        if( (N_Sn_2 - N_Sn_1) <= thr ){
            break
        }
    }

    # クラスタに含まれている原子数を返す
    res <- data.frame(
        "N_Si"=N_Si_1,
        "N_Sn"=N_Sn_1,
        "atoms"=N_Si_1 + N_Sn_1,
        "percent"=(N_Sn_1 / (N_Sn_1 + N_Si_1))
    )
    return(res)
}


for(N in seq(10, 200, 10)){
    message(paste("STEP: ", N, sep=""))

    # d: MCSを経たcell matrix
    d <- as.matrix(read.csv(paste("./cell/",percent*100,"_percent/step",N,".csv", sep="")))
    colnames(d) <- NULL
    D <- melt(d)
    # Si*2: -1
    # SiSn: 0
    # Sn*2: 1

    # D[((D[,1]==c(1,2,3)) * (D[,2]==j))==1 ,3]
    D_ <- D[D[,3]!=-1,]  # Snが入っているところだけを抽出

    # クラスタ中心を探索
    k <- kmeans(
        D_[,1:2],
        centers=round(nrow(d)*ncol(d)*percent,0)/2,
        iter.max = 10000,
        nstart = 1)

    f <- function(x, d){
        i <- x[1]
        j <- x[2]
        return(d[i, j])
    }

    centers <- unique(round(k$centers,0)[,1:2])
    centers <- data.frame(
        centers,
        apply(centers, 1, f, d)
    )
    centers <- centers[centers[,3]!=-1,1:2]

    r <- apply(centers, 1, centers2percent, d, percent, 3)
    label <- matrix(unlist(r),
        ncol=4, byrow=T)

    write.csv(label, paste("./ana/",percent*100,"_percent/step", N, ".csv", sep=""), quote=F, row.names=F)
}