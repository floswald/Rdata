

CAUTION: to be discontinued
===========================

This repo is in the process of migrating to an R data package developed at
[https://github.com/floswald/EconData](https://github.com/floswald/EconData).

Migration to a proper R package has become necessary because I cannot keep
updating the `.RData` files without making the size of this repo explode (they are binaries). `EconData`
will be self-sufficient in the sense that it contains all raw data and can build
the `.RData`sets itself. Plan to release it on CRAN as well.

`EconData` only contains a few datasets so far, so keep using this here
until further notice. cheers!


RData contents
=======================

FRED data
---------

### CPI
* raw data in [fred-cpi.xls](fred-cpi.xls)
* cpi.Rdata: zoo object with CPI
* source: [http://research.stlouisfed.org/fred2/graph/?g=eH4](CPI U monthly series)


US List of State Abbreviations
------------------------------
* states-abbrev.Rdata: R data.frame with state abbreviations and full state names.
* states-abbrev.csv: same in csv
* abbr-state.r: Rscript that creates the data


Long/Lat Coordinates of geographic center of US States
------------------------------------------------------
* useful for plotting US data on a map at the center of each state.


BLS unemployment rates from 1981-2011 by US state
------------------------------------------------------
* getunemp.r: Rscript to create the files
* unemp.RData: several data.frames that contain the data in different forms.


American Bankruptcy Institute Annual Filings rates by state over time
------------------------------------------------------
* getrates.r
* Filings-by-state.RData


US Census
---------

### median income by state over time
* getmedinc.r
* medinc.RData

### population estimates by state over time
* getpop.r
* pop2000s.RData

### ownership rates by US state over time
* getOwnership.r
* Ownership.RData

Federal Housing Finance Administration House price index
---------

* data from [http://www.fhfa.gov/Default.aspx?Page=87](www.fhfa.gov)
* getFHFA.r
* fhfa.RData












