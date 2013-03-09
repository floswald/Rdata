

# make zillow datasets

rm(list=ls(all=T))
library(data.table)
library(zoo)
library(reshape)

setwd("~/Dropbox/bankruptcy/data/zillow/zip-raw/")

files <- list.files(path=".")

flist <- list()
melts <- list()

for (i in 1:length(files)){
	z     <- data.table(read.csv(file=files[i]))
	dates <- gsub("X","",names(z)[-(1:5)])
	dates <- as.yearmon(gsub("\\.","-",dates))
	setnames(z,c(names(z)[1:5],as.character(dates)))
	flist[[i]] <- z
	m          <- melt(z,id.vars="State")
	m$date     <- as.Date(as.yearmon(as.character(m$variable)))
	m$variable <- NULL
	melts[[i]] <- m
}

for (i in 1:length(files)){
	m          <- melt(flist[[i]][,c(3,6:ncol(flist[[i]])),with=FALSE],id.vars="State")
	m$date     <- as.Date(as.yearmon(as.character(m$variable)))
	m$variable <- NULL
	melts[[i]] <- m
}
flist.names <- gsub("Zip_","",files)
flist.names <- gsub("\\.csv","",flist.names)

names(flist) <- flist.names
names(melts) <- flist.names


stop()


z <- data.table(read.csv(file="~/Dropbox/bankruptcy/data/zillow/Zip_Zhvi_AllHomes.csv"))
dates <- gsub("X","",names(z)[-(1:5)])
dates <- as.yearmon(gsub("\\.","-",dates))
setnames(z,c(names(z)[1:5],as.character(dates)))

save(z,file="~/git/Rdata/zillow.RData")

z <- data.table(read.csv(file="~/Dropbox/bankruptcy/data/zillow/Zip_PctTransactionsThatArePreviouslyForeclosuredHomes_AllHomes.csv"))
setnames(z,c(names(z)[1:5],as.character(dates)))
frac.foreclosures <- z
save(frac.foreclosures,file="~/git/Rdata/out/pct-foreclosures.RData")

library(reshape)
mm <- melt(st[as.numeric(State)<10],id.vars="State")
mm$date <- as.Date(as.yearmon(as.character(mm$variable)))
mm$variable <- NULL
ggplot(mm,aes(x=date,y=value,group=State)) + geom_line(aes(color=State)) + scale_x_date()
