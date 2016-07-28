# ----
# Clean Console # only available for rstudio.
cat("\014")
# set directory to path
setwd("D:\\Documents\\Dropbox\\MyEssay\\Rcoding\\")

# load in all functions
source('functions.R',encoding='utf-8')
source('test.R',encoding='utf-8')
# watch R version
sessionInfo() 
# setting locale # please mind that locale should be "Chinese Traditional"
Sys.getlocale(category = "LC_ALL")
## if not please set locale to:
Sys.setlocale("LC_ALL",locale='cht')

## other trouble shooting please read:
# https://github.com/dspim/R/wiki/R-&-RStudio-Troubleshooting-Guide

# ----
Install.pack()
Load.pack()
wd <- getwd()
GDP <- fnGDP()
TEJ <- readDB(fil = "DB2.xlsx", attr_sht = "TEJ_attr", xls_sht = "TEJ")
TEJ0 <- DBfilter(x = TEJ,filt = 'filtered')
TEJ01 <- DBfilter(x = TEJ,filt = 'dropped')
TEJ1 <- NAto0(x ='TEJ0',col=c('OERD','OEPRO','Land','LandR','CTP_IFRS_CFI','CTP_IFRS_CFO','CTP_IFRS_CFF','CTP_GAAP'))
TEJ2 <- control_var(x=TEJ1)
TEJ3 <- exp_var_STR(x=TEJ2)
TEJ4 <- dep_var(TEJ3,k=5)
TEJ5 <- STR(TEJ4,na.rm = TRUE) # TEJ4 removed NAs
#TEJ3 <- NAto0(x ='TEJ3',col=c('STR_RD_mean','STR_EMP_mean','STR_MB_mean','STR_MARKET_mean','STR_PPE_mean'))
TEJ6 <- STRrank(TEJ5)
TEJ7 <- fnHHI_na.rm(TEJ6,k=5)
TEJ81 <- TEJ7
TEJ81 <- winsamp1(x = 'TEJ81', col = c('ETR','CETR','ROA','SIZE','LEV','INTANG'
                                    ,'QUICK','EQINC','OUTINSTI','RELATIN','RELATOUT')
                  , prob = 0.01, na.rm = TRUE)
TEJ82 <- TEJ7
TEJ82 <- winsamp2(x='TEJ82',col = c('ETR','CETR','ROA','SIZE','LEV','INTANG'
                                    ,'QUICK','EQINC','OUTINSTI','RELATIN','RELATOUT')
                  ,prob = 0.01)
TEJ91 <- catchDB(x=TEJ81)
TEJ92 <- catchDB(x=TEJ82)
View(TEJ9)
# ----
# replace TSE_code to TEJ_code1 ### code beneath havn't finished!!!!!!!!!
# GIANT & MERIDA are deleted< sort by TSE_code>, do we have to use TEJ_code1 or TEJ_code2 to classify?
# ----

# HHI prepare
#TEJ$HHI
#TEJ$HHI_Q


