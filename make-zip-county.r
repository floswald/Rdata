


library(data.table)
setwd("~/git/Rdata/raw")
d <- fread(input="zip-county.csv")
d[,zcta5 := as.integer(zcta5)]


zip <- d
zip[,c("pop10","afact") := NULL]
setkey(zip,zcta5)
m <- list(zip.pop=d,zip=zip)
save(m,file="../out/zip-county.RData")
