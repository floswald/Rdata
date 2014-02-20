

# data info in source spreadsheet



rm(list=ls(all=T))
library(xlsx)

setwd("~/git/RData")


d <- read.xlsx(file="raw/930_PerCapitaFilings2010.xls",sheetIndex=1,colIndex=1:4)
d$State <- as.character(d$State)
# is per thousand inhabitants

# now as a fraction of total population
d[ ,c(2,3,4)] <- d[ ,c(2,3,4)] * (1/1000)
pc.bkrates2010 <- d

save(pc.bkrates2010,file="out/pc-bkrates2010.RData")

