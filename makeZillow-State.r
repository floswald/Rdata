
# all zillow data from http://www.zillowblog.com/research/data/


# make zillow state level dataset
rm(list=ls())

library(data.table)
library(reshape)
library(zoo)

setwd("~/git/Rdata/")
mnth <- fread(input="raw/State_Zhvi_AllHomes.csv")
mnth <- data.table(melt(mnth,"RegionName"))
setnames(mnth,c("State","Date","value"))
mnth[,Date := as.Date(as.yearmon(Date))]

yr <- mnth[,list(value=mean(value,na.rm=TRUE)),by=list(year(Date),State)]
setkey(yr,State)
setkey(mnth,State)

load("~/git/Rdata/out/states-abbrev.RData")
setkey(abbr,State)
mnth <- abbr[mnth]
yr   <- abbr[yr] 

mnth[,State := NULL]
yr[,State := NULL]
setnames(mnth,1,"State")
setnames(yr,1,"State")

zillow.state <- list(monthly=mnth,yearly=yr)

save(zillow.state,file="out/zillow-state.RData")
	 
