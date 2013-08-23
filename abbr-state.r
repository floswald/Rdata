

# make data.table of states names, abbreviationas and FIPS codes

library(data.table)
library(XML)
url = "http://www.epa.gov/enviro/html/codes/state.html"
tab <- readHTMLTable(url)
abbr <- data.table(tab[[1]])
setnames(abbr,c("Abbreviation","FIPS","State"))
abbr[,State := as.character(State)]
abbr[,Abbreviation:= as.character(Abbreviation)]
abbr[,FIPS := as.numeric(as.character(FIPS))]

save(abbr,file="~/git/Rdata/out/states-abbrev.RData")


