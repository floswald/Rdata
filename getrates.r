

# get a dataset of bankruptcy rates by US states over time from a bunch of excel files
# original data obtained from a query to http://www.abiworld.org/AM/Template.cfm?Section=Filings_by_State1&Template=/TaggedPage/TaggedPageDisplay.cfm&TPLID=61&ContentID=36299

rm(list=ls(all=T))
library(xlsx)
library(zoo)
library(reshape)

setwd("~/git/RData")


years <- list()
yr.names <- 1980:2011
for (i in 1:length(yr.names)){
	years[[i]] <- read.xlsx(file="raw/Filings-by-state.xls",sheetIndex=i+1)
	years[[i]]$year <- yr.names[i]
}

all.y <- years[[1]] 
for (i in 2:length(years)){
	names(years[[i]]) <- names(years[[1]])
	all.y <- rbind(all.y,years[[i]])
}

save(all.y,file="out/Filings-by-state.RData")

