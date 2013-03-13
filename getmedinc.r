

# get a dataset of median income by US states over time from a bunch of excel files

rm(list=ls(all=T))
library(xlsx)
library(reshape)
library(data.table)

setwd("~/git/Rdata")

medinc   <- read.xlsx(file="raw/median-income.xls",sheetName="medinc.2011CPI")
semedinc <- read.xlsx(file="raw/median-income.xls",sheetName="SE.medinc.2011CPI")

names(medinc)   <- c("State",paste(2011:1984))
names(semedinc) <- c("State",paste(2011:1984))

lmed        <- melt(medinc,id.vars=c("State"))
lsemed      <- melt(semedinc,id.vars=c("State"))
names(lmed) <- c("State","Year","medinc")
lmed$se     <- lsemed$value

medinc <- list(wide=data.table(medinc),long=data.table(lmed),se.side=data.table(semedinc),se.long=data.table(lsemed))

save(medinc,file="out/medinc.RData")
