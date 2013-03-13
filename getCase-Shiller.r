
# make NYFed data available for R.

rm(list=ls(all=T))
setwd("~/git/Rdata")
source("~/git/Rtools/tools.r")
library(data.table)
library(reshape)

library(zoo)	# date utilities

# Case and Shiller house price data
# =================================

# make a quarterly time series
dat      <- read.csv("raw/case-shiller.csv",stringsAsFactors=FALSE)
dat$YEAR <- paste("01 ",dat$YEAR,sep="")	# bring YEAR in format "day month year"
dat$Date <- as.Date(dat$YEAR,format="%d %B %Y")

# take average over multiple cities in one state
dat$CA <- rowMeans(dat[,2:4],na.rm=TRUE)
dat$FL <- rowMeans(dat[,7:8],na.rm=TRUE)
# get rid of multiples
dat    <- dat[,!names(dat) %in% c("YEAR","CA.Los.Angeles","CA.San.Diego","CA.San.Francisco","FL.Miami","FL.Tampa")]

# setup zoo structure
cs.mnth  <- zoo(dat[,!names(dat) %in% "Date"],dat$Date)
sp            <- strsplit(names(cs.mnth),split="\\.")
states        <- unlist(lapply(1:length(sp),function(x) sp[[x]][1]))	# states are first element
states[16:17] <- c("Comp10","Comp20")
names(cs.mnth) <- states
# aggregate to quarterly data
cs.qtr <- aggregate(cs.mnth,as.yearqtr,mean,na.rm=TRUE)

# aggregate to annual data
cs.yr <- aggregate(cs.mnth,as.year,mean,na.rm=TRUE)

# convert to data.frame for long



cs.qtr <- cbind(data.frame(Date=time(cs.qtr)),as.matrix(cs.qtr))
format(cs.qtr$Date, "%Y Q%q")
cs.qtr$Date <- as.Date(cs.qtr$Date)

case.shiller <- list(mnth=cs.mnth,qtr=cs.qtr,yr=cs.yr)

save(case.shiller,file="out/case-shiller.RData")
