

# build a dataset of HMDA respondents from 2009-2011 flat files

# currently builds dataset for NV, CA, UT and AZ but can easily be extended.

# data source: http://www.ffiec.gov/hmda/hmdaflat.htm

# list of variable names for year yyyy in http://www.ffiec.gov/hmdarawdata/FORMATS/yyyyHMDALARRecordFormat.pdf


rm(list=ls())
setwd("~/datasets/HMDA")
library(data.table)

files <- list.files()
yrs <- c(2009,2010,2011)

# within year names of variables
name <- lapply(yrs, function(x) data.table(read.csv(file=paste0(x,"HMDALARRecordFormat.csv"))))
names(name) <- paste0("y",yrs)

dat <- list()

# get yearly datasets
for (yr in 1:length(yrs)){
	tmpfiles <- list.files(paste0("raw-",yrs[yr]))
	tmplist <- list()
	for (fi in 1:length(tmpfiles)){
		tmplist[[fi]] <- fread(input=paste0("raw-",yrs[yr],"/",tmpfiles[[fi]]))
		setnames(tmplist[[fi]],name[[yr]][,as.character(Fields)])
	}
	dat[[yr]] <- rbindlist(tmplist)
}

hmda2009 <- dat[[1]]
hmda2010 <- dat[[2]]
hmda2011 <- dat[[3]]

save(hmda2009,hmda2010,hmda2011,file="HMDA.RData")


