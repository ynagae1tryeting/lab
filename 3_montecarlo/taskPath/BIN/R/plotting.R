source("./function.R")
library(lattice)
library(tidyverse)

ct <- 1
for(N in seq(10,200,10)){
    d <- read.csv(paste("./ana/step",N,".csv",sep=""))
    d <- data.frame(
        d,
        "step"=N
    )
    if(ct == 1){
        D <- d
        ct <- ct + 1
    }else{
        D <- rbind(D, d)
        ct <- ct + 1
    }
}

# 全てのstep
ggplot(D, aes(x=V3, y=V4, color=step)) +
  geom_point()

# 50stepまで
ggplot(D[D[,5]<50,], aes(x=V3, y=V4, color=step)) +
  geom_point()

# 50~100stepまで
ggplot(D[((D[,5]>=50)*(D[,5]<100))==1,], aes(x=V3, y=V4, color=step)) +
  geom_point()

# 100〜150stepまで
ggplot(D[((D[,5]>=100)*(D[,5]<150))==1,], aes(x=V3, y=V4, color=step)) +
  geom_point()

# 150〜200stepまで
ggplot(D[((D[,5]>=150)*(D[,5]<=200))==1,], aes(x=V3, y=V4, color=step)) +
  geom_point()
