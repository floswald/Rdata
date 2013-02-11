

# make data.table of states names and abbreviationas
setwd("~/Dropbox/git/Rtools")

library(data.table)
abbr <- data.table(read.csv("~/Dropbox/git/Rtools/states-abbrev.csv"))

save(abbr,file="states-abbrev.RData")


