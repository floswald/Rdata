


# NYFed default and bankruptcy data
# =================================

# obtained at http://www.newyorkfed.org/householdcredit/

# definitions:
# bal90   : percentage of population 90+ days late on balance (=>" bankruptcy") and
# mort90  : percentage of population 90+ days late on mortgage (=> "default")
# newbk   : percentage of consumers with new bankruptcy
# newfore : percentage of consumers with new foreclosures


rm(list=ls(all=T))
setwd("~/git/Rdata")
library(xlsx)

sheets <- c(37,39,45,47)
rows <- list(3:15,3:15,4:16,4:16)

tables <- list()
for (i in 1:4){
	tables[[i]] <- read.xlsx(file="raw/HHD_C_Report_2012Q3.xls",sheetIndex=sheets[i],rowIndex=rows[[i]],colIndex=1:40)
}
names(tables) <- c("bal90","mort90","newfore","newbk")
states <- as.character(tables$bal90[,1])

for (i in 1:4){
	tables[[i]] <- ts(t(tables[[i]][,-1]),start=2003,frequency=4)
	colnames(tables[[i]]) <- states
}

# make one long dataset for each variable
dates <- as.Date(as.yearqtr(time(tables$bal90)))
for (i in 1:4){
	tables[[i]] <- as.data.frame(tables[[i]])
	tables[[i]]$Date <- dates
}

for (i in 1:4){
	tables[[i]] <- melt(tables[[i]],id.vars="Date")
}

NYFed <- cbind(tables[[1]],tables[[2]]$value,tables[[3]]$value,tables[[4]]$value)
names(NYFed) <- c("Date","State",names(tables))

save(NYFed,file="out/NYFed.RData")



