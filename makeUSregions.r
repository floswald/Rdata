



# raw from www.census.gov/popest/about/geo/state_geocodes_v2011.xls

library(xlsx)
library(data.table)

regions <- read.xlsx(file="~/git/Rdata/raw/state_geocodes_v2011.xls",sheetIndex=2,colClasses=c(rep("numeric",3)))


