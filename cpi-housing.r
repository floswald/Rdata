

# make cpi housing series

setwd("~/git/Rdata/")
x <- read.csv(file="raw/FRED-cpi-housing.csv")
cpi.house <- ts(x$VALUE,start=1967,frequency=12)

save(cpi.house,file="out/FRED-cpi-house.RData")
