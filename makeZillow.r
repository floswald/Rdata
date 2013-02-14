

# make zillow dataset

library(data.table)
library(zoo)
z <- data.table(read.csv(file="~/Dropbox/bankruptcy/data/zillow/Zip_Zhvi_AllHomes.csv"))
dates <- gsub("X","",names(z)[-(1:5)])
dates <- as.yearmon(gsub("\\.","-",dates))
setnames(z,c(names(z)[1:5],as.character(dates)))

save(z,file="~/git/Rdata/zillow.RData")

z <- data.table(read.csv(file="~/Dropbox/bankruptcy/data/zillow/Zip_PctTransactionsThatArePreviouslyForeclosuredHomes_AllHomes.csv"))
setnames(z,c(names(z)[1:5],as.character(dates)))
frac.foreclosures <- z
save(frac.foreclosures,file="~/git/Rdata/out/pct-foreclosures.RData")

library(reshape)
mm <- melt(st[as.numeric(State)<10],id.vars="State")
mm$date <- as.Date(as.yearmon(as.character(mm$variable)))
mm$variable <- NULL
ggplot(mm,aes(x=date,y=value,group=State)) + geom_line(aes(color=State)) + scale_x_date()
