# output excel spreadsheet
TEJ0out <- paste(wd, "/TEJ0out.csv",sep="")
TEJ01out <- paste(wd, "/TEJ01out.csv",sep="")
TEJ1out <- paste(wd, "/TEJ1out.csv",sep="")
TEJ2out <- paste(wd, "/TEJ2out.csv",sep="")
TEJ3out <- paste(wd, "/TEJ3out.csv",sep="")
TEJ4out <- paste(wd, "/TEJ4out.csv",sep="")
write.csv(x=TEJ0, file=TEJ0out)
write.csv(x=TEJ01, file=TEJ01out)
write.csv(x=TEJ1, file=TEJ1out)
write.csv(x=TEJ2, file=TEJ2out)
write.csv(x=TEJ3, file=TEJ3out)
write.csv(x=TEJ4, file=TEJ4out)



# output SPSS
# write out text datafile and an SPSS program to read it
install.packages("foreign")
library(foreign)
spssfile <- paste(wd, "/SPSSout.txt",sep="")
spssset <- paste(wd, "/SPSSout.sps",sep="")
write.foreign(TEJ1, spssfile, spssset, package="SPSS")
# SAS
sasfile <- paste(wd, "/SASout.txt",sep="")
sasset <- paste(wd, "/SASout.sas",sep="")
write.foreign(TEJ1, sasfile, sasset, package="SAS")
# export data frame to Stata binary format 
dtafile <- paste(wd, "/STATAout.dta",sep="")
write.dta(TEJ1, dtafile)

############# use in practice ################

# a list of count for market and year.
table(TEJ$market,TEJ$year,useNA = 'ifany') -> table_markyear
# a list of count for TSE and year.
table(TEJ$TSE_name,TEJ$year,useNA = 'ifany') -> table_TSEyear
grid.table()


summary(TEJ1) -> sumaTEJ1
View(sumaTEJ1)

# make test data frame
y <- subset(TEJ1, select=c(company, year, TSE_code, STR_RD, STR_EMP, STR_MB, STR_MARKET, STR_PPE))[1:1000,]
y <- as.data.table(y)
class(y)

transform(y, STR_RD_mean = ave(STR_RD, company, FUN=rollmean)) -> y1
y[,PTrank := rank(PTEBX), by=list(TSE_code, year)]



