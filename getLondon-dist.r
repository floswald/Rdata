

# London Income distribution
# download data from http://data.london.gov.uk/visualisations/fol-2010-income-report-data.xls

library(xlsx)

setwd("~/git/Rdata/")
d <- read.xlsx("raw/London-income.xls",sheetIndex=3,rowIndex=10:31,colIndex=1:2)
d$cumsum = cumsum(d$London)
d$cdf = d$cumsum/tail(d$cumsum,1)
d$range=factor(1:nrow(d),labels=as.character(d$band))
pdf("out/income-london.pdf")
plot(d$range,d$cdf,main="Unequivalized Household Income distribution in London 2009",yaxt="n",xaxt="n",ylab="F(x) = Pr(income <= x)")
mtext("source: http://data.london.gov.uk/datastore/applications/focus-london-income-and-spending-home\n",cex=0.8)
axis(2,at=c(0,0.2,0.4,0.5,0.6,0.8,1))
axis(1,at=c(1,5,7,9,13,17,21),labels=as.character(d$range[c(1,5,7,9,13,17,21)]),las=2)
grid()
lines(x=0:7,y=rep(0.5,8),col="red")
lines(x=rep(7,7),y=seq(0,0.5,le=7),col="red")
dev.off()
