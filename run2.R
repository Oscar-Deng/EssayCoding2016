# ----
# source('run2.R',encoding='utf-8')
# Clean Console # only available for rstudio.
cat("\014")
# set directory to path
#setwd("D:\\Documents\\Dropbox\\MyEssay\\Rcoding\\")

# load in all functions
source('functions.R',encoding='utf-8')

##watch R version
#sessionInfo() 

#Sys.getlocale(category = "LC_ALL")

#Sys.setlocale("LC_ALL",locale='cht')

## other trouble shooting please read:
# https://github.com/dspim/R/wiki/R-&-RStudio-Troubleshooting-Guide

# ----
Install.pack()
# http://stackoverflow.com/questions/7019912/using-the-rjava-package-on-win7-64-bit-with-r
Load.pack()
wd <- getwd()
TEJ <- readDB(fil = "DB2.xlsx", attr_sht = "TEJ_attr", xls_sht = "TEJ")
TEJ01 <- DBfilter(x = TEJ,filt = 'filtered')
TEJ02 <- DBfilter(x = TEJ,filt = 'dropped')
TEJ1 <- NAto0(x ='TEJ01',col=c('OERD','OEPRO','Land','LandR','CTP_IFRS_CFI','CTP_IFRS_CFO','CTP_IFRS_CFF','CTP_GAAP'))
TEJ2 <- control_var(x=TEJ1)
TEJ3 <- exp_var_STR(x=TEJ2)
TEJ4 <- dep_var(TEJ3,k=5)
TEJ5 <- STR(TEJ4)
TEJ6 <- STRrank(TEJ5)
TEJ7 <- fnHHI(TEJ6)
TEJ81 <- TEJ7
TEJ81 <- winsamp1(x='TEJ81',col=c('ETR','CETR','ROA','SIZE','LEV','INTANG','QUICK','EQINC','OUTINSTI','RELATIN','RELATOUT')
                  ,prob=0.01,na.rm=TRUE)
TEJ82 <- TEJ7
TEJ82 <- winsamp2(x='TEJ82',col = c('ETR','CETR','ROA','SIZE','LEV','INTANG'
                                    ,'QUICK','EQINC','OUTINSTI','RELATIN','RELATOUT')
                  ,prob = 0.01)
TEJ91 <- catchDB(x=TEJ81)
TEJ92 <- catchDB(x=TEJ82)
TEJ101 <- fnGDP(x=TEJ91,file="DB2.xlsx",col_sht="GDP_colnames",DB_sht="GDP")
TEJ102 <- fnGDP(x=TEJ92,file="DB2.xlsx",col_sht="GDP_colnames",DB_sht="GDP")

# ----
source('output.R',encoding='utf-8')
outputcsv()
#outputSPSS()
#outputSAS()
#outputSTATA

# ----
source('tables.R',encoding='utf-8')

# ----
print("Finished running 'run2.R' !")

#View(TEJ101)
#View(TEJ102)


# ----
# replace TSE_code to TEJ_code1 ### code beneath havn't finished!!!!!!!!!
# GIANT & MERIDA are deleted< sort by TSE_code>, do we have to use TEJ_code1 or TEJ_code2 to classify?
# ----


