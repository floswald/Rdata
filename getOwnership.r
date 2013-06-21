
# get ownership rates by state over time
# source: https://www.census.gov/housing/hvs/data/rates/

rm(list=ls(all=T))
library(xlsx)
library(reshape)
library(zoo)
library(data.table)

setwd("~/git/Rdata")

rows <- list(9:59,70:120,131:181,192:242,253:303,314:364,375:425,436:486)
years <- 2012:2005

tabs <- list()
for (i in 1:length(years)){
	cat("reading year",years[i],"\n")
	tabs[[i]]          <- read.xlsx(file="raw/tab3_state05_2012_hmr.xls",sheetName="A",rowIndex=rows[[i]],colIndex=c(1,seq(2,8,by=2)),header=FALSE)
	tmp                <- read.xlsx(file="raw/tab3_state05_2012_hmr.xls",sheetName="A",rowIndex=rows[[i]],colIndex=c(1,seq(3,9,by=2)),header=FALSE)
	tabs[[i]][,1]      <- gsub("\\.+$","",tabs[[i]][,1])
	tmp[,1]            <- gsub("\\.+$","",tmp[,1])
	names(tabs[[i]])   <- c("State",paste(years[i]," Q",1:4,sep=""))
	names(tmp)         <- c("State",paste(years[i]," Q",1:4,sep=""))
	tabs[[i]]          <- melt(tabs[[i]],"State")
	tabs[[i]]$variable <- as.Date(as.yearqtr(tabs[[i]]$variable))
	names(tabs[[i]])   <- c("State","Date","own.rate")
	tmp                <- melt(tmp,"State")
	tabs[[i]]$se       <- tmp$value
}

names(tabs) <- paste("y",years,sep="")
ownership.state.qtr<- rbindlist(tabs)

# get ownership by age from SCF
library(foreign)
ownership.age = read.dta("~/Dropbox/bankruptcy/data/PhilFed/scf/ownership.dta")

save(ownership.state.qtr,ownership.age,file="out/Ownership.RData")
