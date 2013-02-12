

# get a dataset of population count by US states over time from a bunch of excel files

rm(list=ls(all=T))
library(xlsx)
library(reshape)

setwd("~/git/Rdata")

pop       <- read.xlsx(file="raw/pop2000s.xls",sheetName="Sheet2",rowIndex=1:53)
pop$State <- gsub("\\.([[:alpha:]])","\\1",as.character(pop$State))

names(pop) <- c("State",paste(2000:2010))

lpop <- melt(pop,"State")
names(lpop) <- c("State","Year","population")

save(lpop,pop,file="out/pop2000s.RData")
