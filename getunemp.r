


# get a dataset of unemployment rates by US states over time from a bunch of excel files
# original data obtained from a query to http://data.bls.gov/cgi-bin/dsrv
# the author of http://en.wikipedia.org/wiki/File:US_Seasonal_Unemployment.svg uses this series
# ftp://ftp.bls.gov/pub/time.series/la/la.data.3.AllStatesS
# but he/she is aggregating over states and there was no way to find out what the codes mean.



rm(list=ls(all=T))
library(xlsx)
library(zoo)
library(reshape)

setwd("~/git/Rdata/raw/state-unemp")
files <- list.files(path=".")

states <- list()
st.names <- c()
for (i in 1:length(files)){
	tmp         <- loadWorkbook(files[i])
	mysheet     <- getSheets(tmp)
	mysheet     <- mysheet[['BLS Data Series']]
	rows        <- getRows(sheet=mysheet)
	cells       <- getCells(rows,colIndex=2)
	vals        <- lapply(cells,getCellValue)
	st.names[i] <- vals[[2]]	# that's the current state
	states[[i]] <- read.xlsx(files[i],sheetName="BLS Data Series",rowIndex=12:44,colIndex=1:13)
}
names(states) <- st.names

yrly         <- lapply(states,function(x) data.frame(year=x[,1],unemp.rate=rowMeans(x[,-1])))
yrz          <- lapply(yrly,function(z) zoo(x=z$unemp.rate,z$year))
yrz.all      <- yrz[[1]]
for (i in 2:length(yrz)) {
	yrz.all <- cbind(yrz.all,yrz[[i]],deparse.level=0)
}

colnames(yrz.all) <- st.names
ydf               <- as.data.frame(yrz.all)
ydf$year          <- rownames(ydf)
rownames(ydf)     <- NULL
m                 <- melt(ydf,id.vars="year")
names(m)          <- c("Year","State","unemp.rate")

save(m,states,yrly,yrz.all,ydf,file="~/git/Rdata/out/unemp.RData")