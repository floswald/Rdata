

# make data.table of states names and abbreviationas
setwd("~/git/Rdata")

library(data.table)
abbr <- data.table(read.csv("raw/states-abbrev.csv"))
abbr[,State := as.character(State)]
abbr[,Abbreviation:= as.character(Abbreviation)]

save(abbr,file="out/states-abbrev.RData")


