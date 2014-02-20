

# get a dataset of bankruptcy rates by US states over time by states from a bunch of excel files
# original data obtained from a query to 
# http://www.abiworld.org/Content/NavigationMenu/NewsRoom/BankruptcyStatistics/Bankruptcy_Filings_1.htm
# link Filings by chapter

rm(list=ls(all=T))
library(xlsx)
library(zoo)
library(reshape)

setwd("~/git/RData")


years <- list()
yr.names <- 2000:2006
for (i in 1:length(yr.names)){
	years[[i]] <- read.xlsx(file="raw/Filings-state-chapter.xls",sheetIndex=1,rowIndex=3:34,colIndex=c(1,(i-1)*4+(2:5)))
	years[[i]]$year <- yr.names[i]
}

all.y <- years[[1]] 
for (i in 2:length(years)){
	names(years[[i]]) <- names(years[[1]])
	all.y <- rbind(all.y,years[[i]])
}

bk.rates <- all.y
save(bk.rates,file="out/Filings-2000-2006.RData")

