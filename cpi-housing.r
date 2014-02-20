

# make cpi housing series

setwd("~/git/Rdata/")
cpi <- list()

x <- read.csv(file="raw/FRED-cpi-qtr.csv")
cpi$qtr.base2010 <- ts(x$VALUE,start=1955,frequency=4)

x <- read.csv(file="raw/FRED-cpi.csv")
cpi$mnth.base1982 <- ts(x$VALUE,start=1947,frequency=12)

x <- read.csv(file="raw/FRED-cpi-housing.csv")
cpi$house <- ts(x$VALUE,start=1967,frequency=12)

save(cpi,file="out/FRED-cpi.RData")
