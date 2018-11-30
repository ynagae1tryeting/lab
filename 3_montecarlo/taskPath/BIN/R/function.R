make2Dcell <- function(mesh,SnPercent){
    # --- 初期のSiSnの結晶構造作成
    cell <- matrix(-1, nrow=mesh^2)
    samp <- sample(1:mesh^2, as.integer(mesh^2*SnPercent))  # --- 7.5%のSnを導入
    cell[samp] <- 0 # --- サンプリングした番号にSi-Snペアを入れる
    cell <- matrix(cell,nrow=mesh,ncol=mesh)
    return(cell)
}

cellRatio <- function(cell){
    numA <- table(cell==0)
    numA <- as.numeric(numA["TRUE"])
    numB <- table(cell==-1)
    numB <- as.numeric(numB["TRUE"])
    numC <- table(cell==1)
    numC <- as.numeric(numC["TRUE"])

    if (is.na(numA)) { numA <- 0 }
    if (is.na(numB)) { numB <- 0 }
    if (is.na(numC)) { numC <- 0 }
    rA <- numA / (numA + numB + numC)
    rB <- numB / (numA + numB + numC)
    rC <- numC / (numA + numB + numC)
    cellRatio <- data.frame("Si_Sn"=numA, "Si_Si"=numB, "Sn_Sn"=numC, "Aratio"=rA, "Bratio"=rB, "Cratio"=rC) 
    return(cellRatio)
}


FofReactpath <- function(index0, pathindex){
    # --- A,Aの時
    if ((index0 == 0) && (pathindex == 0)){
      f <- 0.5 + 0.5*exp((-myuB - myuC + 2*myuA)/(KB*T))
    } else {
      f <- 1
    }
    # --- indexが-1の時
    if (index0 == -1){
      f <- 1
    }
    # --- indexが-1の時
    if (index0 == 1){
      f <- 1
    }
    return(f)
}

makeP.df <- function(
    index0,
    pathindex.df
    ){
    for (i in 1:ncol(pathindex.df)){
        assign(sprintf("f%d", i), FofReactpath(index0=index0,pathindex=pathindex.df[1,i]))
        if (i==1){fsum <- 0}
        fsum <- fsum + get(sprintf("f%d", i))
    }
    p.df <- matrix(0,nrow=1, ncol=ncol(pathindex.df))
    for (i in 1:ncol(pathindex.df)){
        assign(sprintf("p%d", i), get(sprintf("f%d", i))/fsum)
        p.df[1,i] <- get(sprintf("p%d", i))
    }
    return(data.frame(p.df))
}

Reaction <- function(P.df, index0, pathindex.df){
    R <- runif(1,min=0,max=1.0)
    fcompare  <- 0
    reactpath <- 0
    for (i in 1:ncol(P.df)){
        if (R >= fcompare && R < fcompare + P.df[1,i]){
            # --- 箱に入った時の動作を書く
            reactpath <- i  # --- 相互作用するpathを決定(index.dfの列番号になっている)
        }
        fcompare <- fcompare + P.df[1,i]
    }
    # --- index0==0のとき
    if ((index0 == 0) && (pathindex.df[,reactpath] == 0 )){
        R <- runif(1,min=0,max=1.0)
        if (R >= 0 && R < 0.5 ){
            index0 <- index0                
            pathindex.df[,reactpath] <- pathindex.df[,reactpath]}
        if (R >= 0.5 && R < 0.75 ){
            index0 <- -1   
            pathindex.df[,reactpath] <- 1}
        if (R >= 0.75 && R <= 1 ){
            index0 <- 1  
            pathindex.df[,reactpath] <- -1}
    } else if ( (index0 == 0) && (pathindex.df[,reactpath] == -1 )){
        R <- runif(1,min=0,max=1.0)
        if (R >= 0 && R < 0.5 ){
            index0 <- index0                
            pathindex.df[,reactpath] <- pathindex.df[,reactpath]}
        if (R >= 0.5 && R <= 1 ){
            index0 <- pathindex.df[,reactpath]   
            pathindex.df[,reactpath] <- index0}
    } else if ( (index0 == 0) && (pathindex.df[,reactpath] == 1 )){
        R <- runif(1,min=0,max=1.0)
        if (R >= 0 && R < 0.5 ){
            index0 <- index0                
            pathindex.df[,reactpath] <- pathindex.df[,reactpath]}
        if (R >= 0.5 && R <= 1 ){
            index0 <- pathindex.df[,reactpath]   
            pathindex.df[,reactpath] <- index0}
    }

    # --- index0==-1のとき
    if ((index0 == -1) && (pathindex.df[,reactpath] == 0 )){
        R <- runif(1,min=0,max=1.0)
        if (R >= 0 && R < 0.5 ){
            index0 <- index0                
            pathindex.df[,reactpath] <- pathindex.df[,reactpath]}
        if (R >= 0.5 && R <= 1 ){
            index0 <- pathindex.df[,reactpath]   
            pathindex.df[,reactpath] <- index0}
    } else if ( (index0 == -1) && (pathindex.df[,reactpath] == 1 )){
        R <- runif(1,min=0,max=1.0)
        if (R >= 0 && R < 0.5 ){
            index0 <- 0                
            pathindex.df[,reactpath] <- 0}
        if (R >= 0.5 && R < 0.75 ){
            index0 <- index0   
            pathindex.df[,reactpath] <- pathindex.df[,reactpath]}
        if (R >= 0.75 && R <= 1 ){
            index0 <- pathindex.df[,reactpath]  
            pathindex.df[,reactpath] <- index0}
    }

    # --- index0==1のとき
    if ((index0 == 1) && (pathindex.df[,reactpath] == 0 )){
        R <- runif(1,min=0,max=1.0)
        if (R >= 0 && R < 0.5 ){
            index0 <- index0                
            pathindex.df[,reactpath] <- pathindex.df[,reactpath]}
        if (R >= 0.5 && R <= 1 ){
            index0 <- pathindex.df[,reactpath]   
            pathindex.df[,reactpath] <- index0}
    } else if ( (index0 == 1) && (pathindex.df[,reactpath] == -1 )){
        R <- runif(1,min=0,max=1.0)
        if (R >= 0 && R < 0.5 ){
            index0 <- 0                
            pathindex.df[,reactpath] <- 0}
        if (R >= 0.5 && R < 0.75 ){
            index0 <- index0   
            pathindex.df[,reactpath] <- pathindex.df[,reactpath]}
        if (R >= 0.75 && R <= 1 ){
            index0 <- pathindex.df[,reactpath]  
            pathindex.df[,reactpath] <- index0}
    }

    index.df <- data.frame(index0,pathindex.df)
    return(index.df)
}

MCS.binaryalloy.2D <- function(cell){
    for (i in 1:nrow(cell)){
        for (j in 1:ncol(cell)){
            #message(paste("i: ", i, " j: ", j, sep=""))
            # --- 着目するセルの回りのindexを格納
            # XXX i, jが端っこの時の周期境界条件を設定しないといけない
            pathj1 <- j-1
            pathj2 <- j+1
            pathi3 <- i-1
            pathi4 <- i+1
            if (j == 1) {pathj1 <- ncol(cell)}
            if (j == ncol(cell)) {pathj2 <- 1}
            if (i == 1) {pathi3 <- nrow(cell)}
            if (i == nrow(cell)) {pathi4 <- 1}

            index0 <- cell[i,j]
            index1 <- cell[i,pathj1]
            index2 <- cell[i,pathj2]
            index3 <- cell[pathi3,j]
            index4 <- cell[pathi4,j]
            pathindex.df <- data.frame(index1,index2,index3,index4)
            P.df <- makeP.df(
                index0=index0,
                pathindex.df=pathindex.df)
            index.df <- Reaction(P.df, index0, pathindex.df)
            # --- 相互作用した後のindexを入れ直す
            cell[i,j]   <- index.df[,1]
            cell[i,pathj1] <- index.df[,2]
            cell[i,pathj2] <- index.df[,3]
            cell[pathi3,j] <- index.df[,4]
            cell[pathi4,j] <- index.df[,5]
        }
    }
    return(cell)
}


# 計算を高速化した
MCS.binaryalloy.2D_rev <- function(cell){
    x <- 1:nrow(cell)
    y <- 1:ncol(cell)
    data <- data.frame("x"=x,"y"=y)

    getcell <- function(d, cell){
        i <- d[1]
        j <- d[2]
        pathj1 <- j-1
        pathj2 <- j+1
        pathi3 <- i-1
        pathi4 <- i+1
        if (j == 1) {pathj1 <- ncol(cell)}
        if (j == ncol(cell)) {pathj2 <- 1}
        if (i == 1) {pathi3 <- nrow(cell)}
        if (i == nrow(cell)) {pathi4 <- 1}
        index0 <- cell[i,j]
        index1 <- cell[i,pathj1]
        index2 <- cell[i,pathj2]
        index3 <- cell[pathi3,j]
        index4 <- cell[pathi4,j]
        pathindex.df <- data.frame(index1,index2,index3,index4)
        P.df <- makeP.df(
            index0=index0,
            pathindex.df=pathindex.df)
        index.df <- Reaction(P.df, index0, pathindex.df)
        # --- 相互作用した後のindexを入れ直す
        cell[i,j]   <- index.df[,1]
        cell[i,pathj1] <- index.df[,2]
        cell[i,pathj2] <- index.df[,3]
        cell[pathi3,j] <- index.df[,4]
        cell[pathi4,j] <- index.df[,5]

        celllist <- list(
            "c1"=index.df[,1],
            "c2"=index.df[,2],
            "c3"=index.df[,3],
            "c4"=index.df[,4],
            "c5"=index.df[,5])

        return(celllist)
    }

    l <- apply(data,1,getcell, cell)
    d <- matrix(unlist(l),nrow=nrow(data))
    
    for(r in 1:nrow(d)){
        i <- data[r,1]
        j <- data[r,2]
        if(j!=30){
            pathj1 <- j-1
            pathj2 <- j+1
        }else{
            j <- j - 30
            pathj1 <- j-1
            pathj2 <- j+1
        }
        if(i!=30){
            i <- i - 30
            pathi3 <- i-1
            pathi4 <- i+1
        }
        cell[i,j]      <- d[r,1]
        cell[i,pathj1] <- d[r,2]
        cell[i,pathj2] <- d[r,3]
        cell[pathi3,j] <- d[r,4]
        cell[pathi4,j] <- d[r,5]
    }
    return(cell)
}