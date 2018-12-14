source("./function.R")
library(lattice)
library(tidyverse)
library(ggplot2)

ct <- 1
percent <- 0.2
a_lat <- 5.43 * (1-percent) + 6.46 * percent  # 格子定数(nm)
a_cell <- 0.55 * sqrt(2) / 2  # cellの一辺(nm)

for(N in seq(10,200,30)){
    d <- read.csv(paste("./ana/",percent*100,"_percent/step",N,".csv",sep=""))
    d[,5] <- sqrt(d[,3])*a_cell  # クラスタの一辺

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

# 度数
g <- ggplot(D, aes(x=V5, y=..density..))
g <- g + geom_histogram(position="identity", alpha=0.3, aes(fill=factor(step)),binwidth=a_cell)
#g <- g + geom_line(stat="density", aes(colour=factor(step)))
g <- g + labs(x="R (nm)", y="density")
g <- g + ggtitle(paste0(percent*100, "percent: ", "Density plot of each MCS step"))
#g <- g + scale_fill_npg() + scale_color_npg()
g <- g + xlim(c(0,25))
g
ggsave(paste0("./png_den/", percent*100, "_percent.png"))

# 度数
g_2 <- ggplot(D, aes(x=V4, y=..density..))
g_2 <- g_2 + geom_histogram(position="identity", alpha=0.1, aes(fill=factor(step)),binwidth=0.005)
g_2 <- g_2 + geom_line(stat="density", aes(colour=factor(step)))
g_2 <- g_2 + labs(x="Sn content (%)", y="density")
g_2 <- g_2 + ggtitle(paste0(percent*100, "percent: ", "Density plot of each MCS step for Sn contents of clusters"))
#g <- g + scale_fill_npg() + scale_color_npg()
#g_2 <- g_2 + xlim(c(0,1))
g_2
ggsave(paste0("./png_den/", percent*100, "_percent_2.png"))