rm(list=ls(all=T))
library(reshape)
library(zoo)
library(data.table)
library(ggplot2)


setwd("~/git/Rdata")

					
# state house price data: http://www.fhfa.gov/Default.aspx?Page=87
fhfa         <- read.csv("raw/FHFA-hpi.csv")
fhfa$Date    <- paste(fhfa$Year,"-",fhfa$Quarter,sep="")
fhfa$Year    <- NULL
fhfa$Quarter <- NULL
fhfa$Date    <- as.Date(as.yearqtr(fhfa$Date))
fhfa <- data.table(fhfa)
yfhfa <- fhfa[,list(hpi=mean(hpi)),by=list(State,year(Date))]

save(fhfa,yfhfa,file="out/fhfa.RData")
