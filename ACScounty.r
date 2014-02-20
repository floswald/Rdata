

# read county level data from ACS 2011 Factfinder tables
# ======================================================

# outcomes include: 
# 1) race
# 2) marital status
# 3) industry composition
# 4) education
# 5) num rooms in house / dist of house values


# All data obtained via http://factfinder2.census.gov/
# advanced search for "economic characteristics" and "social characteristics"
# select "geographies": all counties in the USA
# download both 5-year and 3-year estimates


# this program produces two datasets: 
# 1) from 5 year ACS estimates: complete universe of counties, but not all variables measured
# 2) from 3 year ACS estimates: not all counties present, but more variables 


rm(list=ls())
library(data.table)
library(stringr)
library(texreg)


# start with 5 year estimates
# ===========================

# Social Characteristics by county
# --------------------------------

setwd("~/git/Rdata/raw/ACS_11_5YR_DP02/")

# find meta data file
f <- list.files()
metaf <- f[grep("metadata",f)]
dataf <- f[grep("with_ann.csv",f)]
mynames <- c("FIPS","county","hh.size","males.married","males.divorced","females.married","females.divorced","pop","less.9th.grade","grade.9.12","HS.grad","some.col","Ass.deg","Bachelor","Graduate","perc.HS","perc.Bachelor.plus","Non.US")

tmp <- read.csv(file=metaf,header=FALSE)
names(tmp) <- c("name","label")
tmp <- tmp[c(2:3,grep("Percent; EDUCATIONAL ATTAINMENT|Percent; MARITAL STATUS - Now married|Percent; MARITAL STATUS - Divorced|Percent; U.S. CITIZENSHIP STATUS - Not a U.S. citizen|Estimate; HOUSEHOLDS BY TYPE - Average household size",tmp$label)), ]
tmp$name <- as.character(tmp$name)
tmp[2,1] <- "GEO.display.label"

soc <- data.table(read.csv(dataf))
soc[,names(soc)[!names(soc) %in% tmp$name] := NULL,with=FALSE]
setnames(soc,mynames)
soc[,county := as.character(county)]
soc[,pop := NULL]

setkey(soc,FIPS)


# get economic characteristics
# ----------------------------

setwd("~/git/Rdata/raw/ACS_11_5YR_DP03/")
	  
# note: had to delete second line first as introduces some ';' characters to delimit.

# find meta data file

f <- list.files()
dataf <- f[grep("with_ann.csv",f)]
metaf <- f[grep("metadata",f)]

tmp <- read.csv(file=metaf,header=FALSE)
names(tmp) <- c("name","label")
tmp <- tmp[c(2:3,grep("Median earnings for male full-time",tmp$label)[1],tmp$label[grep("POVERTY",tmp$label)][1],grep("Estimate; Median Household Income|Percent; INDUSTRY - Agriculture|Percent; INDUSTRY - Construction|Percent; INDUSTRY - Manufacturing|Percent; INDUSTRY - Wholesale trade|Percent; INDUSTRY - Retail trade|Percent; INDUSTRY - Transportation|Percent; INDUSTRY - Information|Percent; INDUSTRY - Finance|Percent; INDUSTRY - Professional|Percent; INDUSTRY - Educational|Percent; INDUSTRY - Arts|Percent; INDUSTRY - Public|Percent; INDUSTRY - Other",tmp$label)), ]
tmp$name <- as.character(tmp$name)
tmp[2,1] <- "GEO.display.label"

# mynames must be in order of tmp's index
mynames <- c("FIPS","county","remove","ind.agric","ind.construc","ind.manufact","ind.wholesale","ind.retail","ind.transport","ind.information","ind.finance","ind.scientific","ind.educational","ind.arts","ind.other.industry","ind.public.admin","median.earnings")

ec <- data.table(read.csv(file=dataf))
ec[,names(ec)[!names(ec) %in% tmp$name] := NULL,with=FALSE]
setnames(ec,mynames)
ec[,c("remove","county") := NULL]
#     ec[,year := as.integer(paste("20",substr(metaf[i],5,6),sep=""))]
setkey(ec,FIPS)


# get race information
# --------------------

setwd("~/git/Rdata/raw/ACS_11_5YR_B02001/")
	  
# note: had to delete second line first as introduces some ';' characters to delimit.

# find meta data file

f <- list.files()
dataf <- 'ACS_11_5YR_B02001.csv'
metaf <- f[grep("metadata",f)]

tmp <- read.csv(file=metaf,header=FALSE)
names(tmp) <- c("name","label")
tmp <- tmp[c(2:3,grep("Estimate; Total:|Estimate; Total: - White alone|Estimate; Total: - Black or African American alone|Estimate; Total: - American Indian and Alaska Native alone|Estimate; Total: - Asian alone",tmp$label))[1:7], ]
tmp$name <- as.character(tmp$name)
tmp[2,1] <- "GEO.display.label"

mynames <- c("FIPS","county","pop","race.white","race.black","race.am.ind","race.asian")

race <- data.table(read.csv(file=dataf))
race[,names(race)[!names(race) %in% tmp$name] := NULL,with=FALSE]
setnames(race,mynames)

# compute race as proportion of population
tpop <- race[,pop]
race[,c(4,5,6,7) := lapply(.SD, function(j) j/tpop),.SDcols=c(4,5,6,7),with=FALSE]
race[,c('pop','county') := NULL]
rm(tpop)

setkey(race,FIPS)


# get houseing characteristics
# ----------------------------

setwd("~/git/Rdata/raw/ACS_11_5YR_DP04/")
	  

# find meta data file

f <- list.files()
dataf <- 'ACS_11_5YR_DP04.csv'
metaf <- f[grep("metadata",f)]

tmp <- read.csv(file=metaf,header=FALSE)
names(tmp) <- c("name","label")
tmp <- tmp[c(2:3,grep("Percent; ROOMS - 1 room|Percent; ROOMS - 2 rooms|Percent; ROOMS - 3 rooms|Percent; ROOMS - 4 rooms|Percent; ROOMS - 5 rooms|Percent; ROOMS - 6 rooms|Percent; ROOMS - 7 rooms|Percent; ROOMS - 8 room|Percent; ROOMS - 9 rooms or more|Percent; HOUSING TENURE - Owner-occupied|Percent; HOUSING TENURE - Renter-occupied|Percent; MORTGAGE STATUS - Housing units with a mortgage|Estimate; GROSS RENT - Median",tmp$label)), ]
tmp$name <- as.character(tmp$name)
tmp[2,1] <- "GEO.display.label"

mynames <- c("FIPS","county","rooms.1","rooms.2","rooms.3","rooms.4","rooms.5","rooms.6","rooms.7","rooms.8","rooms.9","owner.occ","rental","have.mortg","gross.rent")

own <- data.table(read.csv(file=dataf))
own[,names(own)[!names(own) %in% tmp$name] := NULL,with=FALSE]
setnames(own,mynames)

# compute own as proportion of population
own[,county := NULL]

setkey(own,FIPS)

# merge all three datasets by FIPS

ACS5 <- soc[race[own[ec]]]

ACS5 <- ACS5[complete.cases(ACS5)]


# get county and state separately
# fix doña ana county
ACS5[.(35013),county := "Dona Ana County, New Mexico"]

# drop puerto rico
ACS5 <- ACS5[FIPS<72001]
s=ACS5[,tolower(unlist(strsplit(county,"\\,")))]
ACS5[,State := s[which(1:length(s) %% 2==0)]]
ACS5[,cnty  := s[which(1:length(s) %% 2==1)]]
ACS5[,cnty  := gsub(" county","",cnty)]
ACS5[,cnty  := str_trim(cnty)]
ACS5[,State := str_trim(State)]
load("~/git/Rdata/out/states-abbrev.RData")
abbr[,State := tolower(State)]
setkey(abbr,State)
setkey(ACS5,State)
ACS5 <- copy(abbr[ACS5])
ACS5[,c("county") := NULL]
setkey(ACS5,FIPS)




# repeat for 3 year estimates
# ===========================

# Social Characteristics by county
# --------------------------------

setwd("~/git/Rdata/raw/ACS_11_3YR_DP02/")

# find meta data file
f <- list.files()
metaf <- f[grep("metadata",f)]
dataf <- "ACS_11_3YR_DP02.csv"
mynames <- c("FIPS","county","hh.size","males.married","males.divorced","females.married","females.divorced","pop","less.9th.grade","grade.9.12","HS.grad","some.col","Ass.deg","Bachelor","Graduate","perc.HS","perc.Bachelor.plus","perc.disability","Non.US")

tmp <- read.csv(file=metaf,header=FALSE)
names(tmp) <- c("name","label")

tmp <- tmp[c(2:3,grep("Percent; EDUCATIONAL ATTAINMENT|Percent; MARITAL STATUS - Now married|Percent; MARITAL STATUS - Divorced|Percent; U.S. CITIZENSHIP STATUS - Not a U.S. citizen|Estimate; HOUSEHOLDS BY TYPE - Average household size",tmp$label),grep("Percent; DISABILITY STATUS OF THE CIVILIAN NONINSTITUTIONALIZED POPULATION - With a disability",tmp$label)[1]), ]

tmp$name <- as.character(tmp$name)
tmp[2,1] <- "GEO.display.label"

soc <- data.table(read.csv(dataf))
soc[,names(soc)[!names(soc) %in% tmp$name] := NULL,with=FALSE]
setnames(soc,mynames)
soc[,pop := NULL]
soc[,county := as.character(county)]

setkey(soc,FIPS)


# get economic characteristics
# ----------------------------

setwd("~/git/Rdata/raw/ACS_11_3YR_DP03/")
	  
# note: had to delete second line first as introduces some ';' characters to delimit.

# find meta data file

f <- list.files()
dataf <- "ACS_11_3YR_DP03.csv"
metaf <- f[grep("metadata",f)]

grep("Percent; HEALTH INSURANCE COVERAGE - No health insurance coverage",tmp$label)[1]

tmp <- read.csv(file=metaf,header=FALSE)
names(tmp) <- c("name","label")
tmp <- tmp[c(2:3,grep("Median earnings for male full-time",tmp$label)[1],tmp$label[grep("POVERTY",tmp$label)][1],grep("Estimate; Median Household Income|Percent; INDUSTRY - Agriculture|Percent; INDUSTRY - Construction|Percent; INDUSTRY - Manufacturing|Percent; INDUSTRY - Wholesale trade|Percent; INDUSTRY - Retail trade|Percent; INDUSTRY - Transportation|Percent; INDUSTRY - Information|Percent; INDUSTRY - Finance|Percent; INDUSTRY - Professional|Percent; INDUSTRY - Educational|Percent; INDUSTRY - Arts|Percent; INDUSTRY - Public|Percent; INDUSTRY - Other",tmp$label),grep("Percent; HEALTH INSURANCE COVERAGE - No health insurance coverage",tmp$label)[1]), ]
tmp$name <- as.character(tmp$name)
tmp[2,1] <- "GEO.display.label"

# mynames must be in order of tmp's index
mynames <- c("FIPS","county","remove","ind.agric","ind.construc","ind.manufact","ind.wholesale","ind.retail","ind.transport","ind.information","ind.finance","ind.scientific","ind.educational","ind.arts","ind.other.industry","ind.public.admin","median.earnings","perc.no.health.insurance")

ec <- data.table(read.csv(file=dataf))
ec[,names(ec)[!names(ec) %in% tmp$name] := NULL,with=FALSE]
setnames(ec,mynames)
ec[,c("remove","county") := NULL]
#     ec[,year := as.integer(paste("20",substr(metaf[i],5,6),sep=""))]
setkey(ec,FIPS)


# get race information
# --------------------

setwd("~/git/Rdata/raw/ACS_11_3YR_B02001/")
	  
# note: had to delete second line first as introduces some ';' characters to delimit.

# find meta data file

f <- list.files()
dataf <- 'ACS_11_3YR_B02001.csv'
metaf <- f[grep("metadata",f)]

tmp <- read.csv(file=metaf,header=FALSE)
names(tmp) <- c("name","label")
tmp <- tmp[c(2:3,grep("Estimate; Total:|Estimate; Total: - White alone|Estimate; Total: - Black or African American alone|Estimate; Total: - American Indian and Alaska Native alone|Estimate; Total: - Asian alone",tmp$label))[1:7], ]
tmp$name <- as.character(tmp$name)
tmp[2,1] <- "GEO.display.label"

mynames <- c("FIPS","county","pop","race.white","race.black","race.am.ind","race.asian")

race <- data.table(read.csv(file=dataf))
race[,names(race)[!names(race) %in% tmp$name] := NULL,with=FALSE]
setnames(race,mynames)

# compute race as proportion of population
tpop <- race[,pop]
race[,c(4,5,6,7) := lapply(.SD, function(j) j/tpop),.SDcols=c(4,5,6,7),with=FALSE]
race[,c('pop','county') := NULL]
rm(tpop)

setkey(race,FIPS)

# get houseing characteristics
# ----------------------------

setwd("~/git/Rdata/raw/ACS_11_3YR_DP04/")
	  

# find meta data file

f <- list.files()
dataf <- 'ACS_11_3YR_DP04.csv'
metaf <- f[grep("metadata",f)]

tmp <- read.csv(file=metaf,header=FALSE)
names(tmp) <- c("name","label")
tmp <- tmp[c(2:3,grep("Percent; ROOMS - 1 room|Percent; ROOMS - 2 rooms|Percent; ROOMS - 3 rooms|Percent; ROOMS - 4 rooms|Percent; ROOMS - 5 rooms|Percent; ROOMS - 6 rooms|Percent; ROOMS - 7 rooms|Percent; ROOMS - 8 room|Percent; ROOMS - 9 rooms or more|Percent; HOUSING TENURE - Owner-occupied|Percent; HOUSING TENURE - Renter-occupied|Percent; MORTGAGE STATUS - Housing units with a mortgage|Estimate; GROSS RENT - Median",tmp$label)), ]
tmp$name <- as.character(tmp$name)
tmp[2,1] <- "GEO.display.label"

mynames <- c("FIPS","county","rooms.1","rooms.2","rooms.3","rooms.4","rooms.5","rooms.6","rooms.7","rooms.8","rooms.9","owner.occ","rental","have.mortg","gross.rent")

own <- data.table(read.csv(file=dataf))
own[,names(own)[!names(own) %in% tmp$name] := NULL,with=FALSE]
setnames(own,mynames)

# compute own as proportion of population
own[,county := NULL]

setkey(own,FIPS)


# merge all three datasets by FIPS

ACS3 <- soc[race[own[ec]]]

ACS3 <- ACS3[complete.cases(ACS3)]


# get county and state separately
# fix doña ana county
ACS3[.(35013),county := "Dona Ana County, New Mexico"]

# drop puerto rico
ACS3 <- ACS3[FIPS<72001]
s=ACS3[,tolower(unlist(strsplit(county,"\\,")))]
ACS3[,State := s[which(1:length(s) %% 2==0)]]
ACS3[,cnty  := s[which(1:length(s) %% 2==1)]]
ACS3[,cnty  := gsub(" county","",cnty)]
ACS3[,cnty  := str_trim(cnty)]
ACS3[,State := str_trim(State)]
load("~/git/Rdata/out/states-abbrev.RData")
abbr[,State := tolower(State)]
setkey(abbr,State)
setkey(ACS3,State)
ACS3 <- copy(abbr[ACS3])
ACS3[,c("county") := NULL]
setkey(ACS3,FIPS)


save(ACS3,ACS5,file="~/git/Rdata/out/ACScounty.RData")

