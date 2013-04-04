
# obtain data for census state to state migration flows
# uses data from http://www.census.gov/hhes/migration/data/acs/state-to-state.html

rm(list=ls(all=T))
setwd("~/git/Rdata")

library(xlsx)
idx <- seq(from=13,to=21,by=2)
while (tail(idx,1) < 121) {
	newfrom <- tail(idx,1) + 3
	newto <- newfrom + 8
	idx <- c(idx,seq(newfrom,newto,by=2))
}
idx <- idx[idx<121]


d <- read.xlsx(file="raw/State_to_State_Migrations_Table_2011.xls",
			   sheetIndex=1,
			   rowIndex=c(12:16,18:22,24:28,30:34,36:40,42,43,49:53,55:59,61:65,67:71,73:76),
			   colIndex=c(1,2,6,10,idx),header=FALSE)

names(d) <- c("current","pop.current","instate.mig",as.character(d$V1))

load("~/git/Rdata/out/states-abbrev.RData")
snames <- names(d)
snames <- sub("\\s+$", '',snames)	# remove white space at end of string
snames <- data.frame(State=snames)
snames <- merge(snames,abbr,"State")

names(d)[4:ncol(d)] <- as.character(snames$Abbreviation)
d[,1] <- names(d)[4:ncol(d)]
d[,-1] <- apply(d[,-1],2,as.numeric)
frac <- as.matrix(d[,-1])

# as percentage of current population
dd <- d
dd[,-1] <- t(apply(frac,1,function(X) X / X[1]))

library(reshape)
m <- melt(dd[,-c(2,3)],"current")
w.own <- m
w.own[w.own$current==w.own$variable,]$value <- dd$instate.mig

level <- d
props <- m
props2 <- w.own
state.migration <- list(level=level,props=props,props.with.own=props2)

save(state.migration,file="out/state-migration.RData")






