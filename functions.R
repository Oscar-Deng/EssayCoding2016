# -*- encoding : utf-8 -*-
# Clear Global Environment
rm(list=ls())

# functions!!!
# install all packages and load.
Install.pack <- function(list = c("readxl","xlsx","data.table","plyr","dplyr","knitr",
                                  "gridExtra","ggplot2","zoo","R.oo","R.utils","psych",
                                  "robustHD")){
  list.of.packages <- list
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)){install.packages(new.packages)}else{update.packages(list.of.packages)}
}
Load.pack <- function(lst=list("readxl","xlsx","data.table","plyr","dplyr","knitr",
                               "gridExtra","ggplot2","zoo","R.oo","R.utils","psych",
                               "robustHD")){
  lapply(lst, require, character.only = TRUE)}

readDB <- function(fil = "DB2.xlsx", attr_sht = "TEJ_attr", xls_sht = "TEJ"){
  DBattr <- read_excel(fil, sheet=attr_sht, col_names = TRUE)
  # read in excel database: DB2.xlsx, excel sheet: TEJ, with column names.
  DBori <- read_excel(fil, sheet=xls_sht, col_names = TRUE, col_types = DBattr$attr)
  # rename columns
  setnames(DBori,old=as.character(DBattr$old), new=as.character(DBattr$new))
} # read in xlsx
DBfilter <- function(x = TEJ,filt='filtered'){
  DB0 <- as.data.table(x)[,.SD[.N > 0],by=list(TSE_code,year(date))]
  DB1 <- as.data.table(x)[,.SD[.N >= 5],by=list(TSE_code,year(date))] # removed M1800<2001-2005>,M2200<2001>
  DB2 <- DB1[!(DB1$TSE_code %in% c('M2800','M9900','M2331','W91')) & # M2800金融業 # M9900其他 # M2331其他電子 # W91存託憑證
               !(DB1$FAMILY %in% NA) & # most family with NA got lots of NAs in other columns
               !(DB1$PB %in% NA) & # important var, must not be NA
               !(DB1$TA %in% NA) & # denominator or main var as PPE, ROA, SIZE, LEV, INTANG, must not bo NA.
               !(DB1$NetSales %in% c(0,NA)) & # remove netsales = 0 ... Denominator of (RD,EMP,MARKET),HHI's main var,
               !(DB1$employee %in% NA)]
  DB3 <- rbind(DB0,DB2)
  DB3 <- DB3[order(DB3$TSE_code,DB3$year),]
  DB4 <- DB3[!(duplicated(DB3) | duplicated(DB3, fromLast = TRUE)),]
  base::ifelse(filt=='filtered', return(DB2), base::ifelse(filt=='dropped', return(DB4), print("please assign filter type")))
} # 篩選後的:filt=filtered, #篩選刪掉的filt=dropped
NAto0 <- function(x = 'TEJ0',col=c(NA)){
  x1 <- captureOutput(
    for(y in col){cat(x,'$',y,'[is.na(',x,'$',y,')] <- 0',sep="",fill = TRUE)})
  x2 <- captureOutput(cat('return(',paste(x),')',sep=""))
  xx <- c(x1,x2)
  eval(base::parse(text=xx))} # replace NA with 0.
control_var <- function(x=TEJ1){
  y <- transform(x,
                 ROA = as.numeric(PTEBX) / as.numeric(TA), # ROA : NetSales / TotalAssets
                 SIZE = as.numeric(log(x = as.numeric(TA), base = exp(1))), # SIZE : ln(TA)
                 LEV = as.numeric(TL) / as.numeric(TA), # LEV : TL / TA
                 INTANG = as.numeric(INTAN) / as.numeric(TA), # INTANG : intangible assets / TA
                 QUICK = as.numeric(QUICK), # QUICK : = QUICK
                 EQINC = as.numeric(-(InvIn + InvLoss)) / as.numeric(TA), # EQINC : (InvIn + InvLos) / TA
                 # should make InvIn positive and make InvLos negative, 
                 # so thus just add minus in denominator.
                 OUTINSTI = as.numeric(OUTINSTI), # OUTINSTI : = OUTINSTI
                 # RELATION : Relation in and out, two variables:  RELATIN, RELATOUT
                 RELATIN = as.numeric(RELATIN),
                 RELATOUT = as.numeric(RELATOUT),
                 # FAMILY : if company is FAMILY, then 1, else 0. 
                 # Observations with FAMILY in NA had been removed.
                 FAM_Dum = ifelse(FAMILY == 'F', 1, 0)
  )
  DB <- as.data.table(y[order(y$company,y$year),]) # sort by company<ascending> and year<ascending>
  return(DB)} # set new vars
exp_var_STR <- function(x=TEJ1){
  y <- transform(x,
                 CTP_IFRS = as.numeric(-(CTP_IFRS_CFI + CTP_IFRS_CFO + CTP_IFRS_CFF)),
                 STR_RD = as.numeric(OERD) / as.numeric(NetSales),
                 STR_EMP = as.numeric(employee) / as.numeric(NetSales),
                 STR_MB = as.numeric(PB),
                 STR_MARKET = as.numeric(OEPRO) / as.numeric(NetSales),
                 STR_PPE = as.numeric( FA - Land - LandR ) / as.numeric(TA)
  )
  z <- transform(y, CTP = ifelse(year >= 2012,CTP_IFRS,CTP_GAAP)) # combine IFRS as 2012~ , GAAP as ~2011
  DB <- as.data.table(z[order(z$company,z$year),]) # sort by company<ascending> and year<ascending>
  return(DB)}
dep_var <- function(x=TEJ2,k=5){
  DB01 <- x[,.SD[.N >= k],by=company]
  DB02 <- x[,.SD[.N < k],by=company]
  DB1 <- DB01[,`:=`(BTE5yrsum = rollapplyr(BTE, width = 5, FUN = sum, fill = NA),
                    CTP5yrsum = rollapplyr(CTP, width = 5, FUN = sum, fill = NA),
                    PTEBX5yrsum = rollapplyr(PTEBX, width = 5, FUN = sum, fill = NA)),
              by=company]
  DB2 <- DB02[,`:=`(BTE5yrsum = NA,CTP5yrsum = NA,PTEBX5yrsum = NA),by=company]
  DB3 <- rbind(DB1,DB2)
  DB <- transform(DB3,
                  ETR = as.numeric(BTE5yrsum) / as.numeric(PTEBX5yrsum),
                  CETR = as.numeric(CTP5yrsum) / as.numeric(PTEBX5yrsum))
  return(as.data.table(DB[order(DB$company,DB$year),]))} # add up 5 years moving sum
STR <- function(x=TEJ4,k=5,na.rm=TRUE) {
  x <- x[order(x$company,x$year),]
  rollmn <- function(x) rollapplyr(x, width, function(x) mean(x , na.rm = TRUE), fill=NA)
  
  width <- list(numeric(0),1,-(1:2),-(1:3),-(1:4),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5))
  DB15 <- transform(x[,.SD[.N == 15],by=list(company,year)],
                    STR_RD_mean = ave(STR_RD, company, FUN=rollmn),
                    STR_EMP_mean = ave(STR_EMP, company, FUN=rollmn),
                    STR_MB_mean = ave(STR_MB, company, FUN=rollmn),
                    STR_MARKET_mean = ave(STR_MARKET, company, FUN=rollmn),
                    STR_PPE_mean = ave(STR_PPE, company, FUN=rollmn))
  
  width <- list(numeric(0),1,-(1:2),-(1:3),-(1:4),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5))
  DB14 <- transform(x[,.SD[.N == 14],by=list(company,year)],
                    STR_RD_mean = ave(STR_RD, company, FUN=rollmn),
                    STR_EMP_mean = ave(STR_EMP, company, FUN=rollmn),
                    STR_MB_mean = ave(STR_MB, company, FUN=rollmn),
                    STR_MARKET_mean = ave(STR_MARKET, company, FUN=rollmn),
                    STR_PPE_mean = ave(STR_PPE, company, FUN=rollmn))
  
  width <- list(numeric(0),1,-(1:2),-(1:3),-(1:4),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5))
  DB13 <- transform(x[,.SD[.N == 13],by=list(company,year)],
                    STR_RD_mean = ave(STR_RD, company, FUN=rollmn),
                    STR_EMP_mean = ave(STR_EMP, company, FUN=rollmn),
                    STR_MB_mean = ave(STR_MB, company, FUN=rollmn),
                    STR_MARKET_mean = ave(STR_MARKET, company, FUN=rollmn),
                    STR_PPE_mean = ave(STR_PPE, company, FUN=rollmn))
  
  width <- list(numeric(0),1,-(1:2),-(1:3),-(1:4),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5))
  DB12 <- transform(x[,.SD[.N == 12],by=list(company,year)],
                    STR_RD_mean = ave(STR_RD, company, FUN=rollmn),
                    STR_EMP_mean = ave(STR_EMP, company, FUN=rollmn),
                    STR_MB_mean = ave(STR_MB, company, FUN=rollmn),
                    STR_MARKET_mean = ave(STR_MARKET, company, FUN=rollmn),
                    STR_PPE_mean = ave(STR_PPE, company, FUN=rollmn))
  
  width <- list(numeric(0),1,-(1:2),-(1:3),-(1:4),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5))
  DB11 <- transform(x[,.SD[.N == 11],by=list(company,year)],
                    STR_RD_mean = ave(STR_RD, company, FUN=rollmn),
                    STR_EMP_mean = ave(STR_EMP, company, FUN=rollmn),
                    STR_MB_mean = ave(STR_MB, company, FUN=rollmn),
                    STR_MARKET_mean = ave(STR_MARKET, company, FUN=rollmn),
                    STR_PPE_mean = ave(STR_PPE, company, FUN=rollmn))
  
  width <- list(numeric(0),1,-(1:2),-(1:3),-(1:4),-(1:5),-(1:5),-(1:5),-(1:5),-(1:5))
  DB10 <- transform(x[,.SD[.N == 10],by=list(company,year)],
                    STR_RD_mean = ave(STR_RD, company, FUN=rollmn),
                    STR_EMP_mean = ave(STR_EMP, company, FUN=rollmn),
                    STR_MB_mean = ave(STR_MB, company, FUN=rollmn),
                    STR_MARKET_mean = ave(STR_MARKET, company, FUN=rollmn),
                    STR_PPE_mean = ave(STR_PPE, company, FUN=rollmn))
  
  width <- list(numeric(0),1,-(1:2),-(1:3),-(1:4),-(1:5),-(1:5),-(1:5),-(1:5))
  DB09 <- transform(x[,.SD[.N == 9],by=list(company,year)],
                    STR_RD_mean = ave(STR_RD, company, FUN=rollmn),
                    STR_EMP_mean = ave(STR_EMP, company, FUN=rollmn),
                    STR_MB_mean = ave(STR_MB, company, FUN=rollmn),
                    STR_MARKET_mean = ave(STR_MARKET, company, FUN=rollmn),
                    STR_PPE_mean = ave(STR_PPE, company, FUN=rollmn))
  
  width <- list(numeric(0),1,-(1:2),-(1:3),-(1:4),-(1:5),-(1:5),-(1:5))
  DB08 <- transform(x[,.SD[.N == 8],by=list(company,year)],
                    STR_RD_mean = ave(STR_RD, company, FUN=rollmn),
                    STR_EMP_mean = ave(STR_EMP, company, FUN=rollmn),
                    STR_MB_mean = ave(STR_MB, company, FUN=rollmn),
                    STR_MARKET_mean = ave(STR_MARKET, company, FUN=rollmn),
                    STR_PPE_mean = ave(STR_PPE, company, FUN=rollmn))
  
  width <- list(numeric(0),1,-(1:2),-(1:3),-(1:4),-(1:5),-(1:5))
  DB07 <- transform(x[,.SD[.N == 7],by=list(company,year)],
                    STR_RD_mean = ave(STR_RD, company, FUN=rollmn),
                    STR_EMP_mean = ave(STR_EMP, company, FUN=rollmn),
                    STR_MB_mean = ave(STR_MB, company, FUN=rollmn),
                    STR_MARKET_mean = ave(STR_MARKET, company, FUN=rollmn),
                    STR_PPE_mean = ave(STR_PPE, company, FUN=rollmn))
  
  width <- list(numeric(0),1,-(1:2),-(1:3),-(1:4),-(1:5))
  DB06 <- transform(x[,.SD[.N == 6],by=list(company,year)],
                    STR_RD_mean = ave(STR_RD, company, FUN=rollmn),
                    STR_EMP_mean = ave(STR_EMP, company, FUN=rollmn),
                    STR_MB_mean = ave(STR_MB, company, FUN=rollmn),
                    STR_MARKET_mean = ave(STR_MARKET, company, FUN=rollmn),
                    STR_PPE_mean = ave(STR_PPE, company, FUN=rollmn))
  
  width <- list(numeric(0),1,-(1:2),-(1:3),-(1:4))
  DB05 <- transform(x[,.SD[.N == 5],by=list(company,year)],
                    STR_RD_mean = ave(STR_RD, company, FUN=rollmn),
                    STR_EMP_mean = ave(STR_EMP, company, FUN=rollmn),
                    STR_MB_mean = ave(STR_MB, company, FUN=rollmn),
                    STR_MARKET_mean = ave(STR_MARKET, company, FUN=rollmn),
                    STR_PPE_mean = ave(STR_PPE, company, FUN=rollmn))
  
  width <- list(numeric(0),1,-(1:2),-(1:3))
  DB04 <- transform(x[,.SD[.N == 4],by=list(company,year)],
                    STR_RD_mean = ave(STR_RD, company, FUN=rollmn),
                    STR_EMP_mean = ave(STR_EMP, company, FUN=rollmn),
                    STR_MB_mean = ave(STR_MB, company, FUN=rollmn),
                    STR_MARKET_mean = ave(STR_MARKET, company, FUN=rollmn),
                    STR_PPE_mean = ave(STR_PPE, company, FUN=rollmn))
  
  width <- list(numeric(0),1,-(1:2))
  DB03 <- transform(x[,.SD[.N == 3],by=list(company,year)],
                    STR_RD_mean = ave(STR_RD, company, FUN=rollmn),
                    STR_EMP_mean = ave(STR_EMP, company, FUN=rollmn),
                    STR_MB_mean = ave(STR_MB, company, FUN=rollmn),
                    STR_MARKET_mean = ave(STR_MARKET, company, FUN=rollmn),
                    STR_PPE_mean = ave(STR_PPE, company, FUN=rollmn))
  
  width <- list(numeric(0),1)
  DB02 <- transform(x[,.SD[.N == 2],by=list(company,year)],
                    STR_RD_mean = ave(STR_RD, company, FUN=rollmn),
                    STR_EMP_mean = ave(STR_EMP, company, FUN=rollmn),
                    STR_MB_mean = ave(STR_MB, company, FUN=rollmn),
                    STR_MARKET_mean = ave(STR_MARKET, company, FUN=rollmn),
                    STR_PPE_mean = ave(STR_PPE, company, FUN=rollmn))
  
  width <- list(numeric(0))
  DB01 <- transform(x[,.SD[.N == 1],by=list(company,year)],
                    STR_RD_mean = NA,
                    STR_EMP_mean = NA,
                    STR_MB_mean = NA,
                    STR_MARKET_mean = NA,
                    STR_PPE_mean = NA)				   
  
  DB <- rbind(DB01,DB02,DB03,DB04,DB05,DB06,DB07,DB08,DB09,DB10,DB11,DB12,DB13,DB14,DB15)
  DBA <- as.data.table(DB[order(DB$company,DB$year),])
  return(DBA)
}
STRrank <- function(x=TEJ3){
  prank<-function(x) {ifelse(is.na(x),NA,rank(x,ties.method = 'min')/sum(!is.na(x)))} # STRATEGY ranktile.
  rankscore <- function(x) ifelse(x>=0 & x<=0.2,1,ifelse(x>0.2 & x<=0.4,2,ifelse(x>0.4 & x<=0.6,3,ifelse(x>0.6 & x<=0.8,4,ifelse(x>0.8 & x<=1,5,NA)))))
  DB <- transform(x[,by=c(TSE_code,year)],
                  STR_RD_mean_rank = prank(STR_RD_mean),
                  STR_EMP_mean_rank = prank(STR_EMP_mean),
                  STR_MB_mean_rank = prank(STR_MB_mean),
                  STR_MARKET_mean_rank = prank(STR_MARKET_mean),
                  STR_PPE_mean_rank = prank(STR_PPE_mean))
  DB2 <- transform(DB,
                   RD = rankscore(STR_RD_mean_rank),
                   EMP = rankscore(STR_EMP_mean_rank),
                   MB = rankscore(STR_MB_mean_rank),
                   MARKET = rankscore(STR_MARKET_mean_rank),
                   PPE = rankscore(STR_PPE_mean_rank))
  DB2$STR <- as.numeric(DB2$RD) + as.numeric(DB2$EMP) + as.numeric(DB2$MB) + as.numeric(DB2$MARKET) + as.numeric(DB2$PPE)
  return(DB2)} # rank score function
fnGDP <- function(file="DB2.xlsx",col_sht="GDP_colnames",DB_sht="GDP"){
  # GDP : ln(realGDP)
  GDP_colname <- read_excel(file, sheet=col_sht)
  rGDP <- read_excel(file, sheet=DB_sht)
  # rename GDP columns
  setnames(rGDP, old=as.character(GDP_colname$old), new=as.character(GDP_colname$new))
  return(rGDP)
} # GDP
fnHHI_na.rm <- function(x,k=5) {
  # construct function rollmean
  rollmn0 <- function(x) rollapplyr(x, k+1, function(x) mean(x[-k-1],na.rm = TRUE), fill = NA) # add remove na
  rollsm0 <- function(x) rollapplyr(x, k+1, function(x) sum(x[-k-1],na.rm = TRUE), fill = NA) # add remove na
  x1 <- x[,NSsum := sum(NetSales,na.rm = TRUE),by=list(TSE_code,year)]
  x2 <- x1[,NSalpha2 := (as.numeric(NetSales) / as.numeric(NSsum))^2 ]
  x3 <- x2[,`:=`(HHIsum = sum(NSalpha2,na.rm = TRUE),
                 count_TSE_in_year = .N)
           ,by=list(TSE_code,year)]
  y1 <- subset(x3,select=c(TSE_code,year,count_TSE_in_year,HHIsum))
  y2 <- y1[!duplicated(y1)][order(TSE_code, year),]
  y3 <- transform(y2[,.SD[.N > k],by=TSE_code],
                  HHI = ave(HHIsum, TSE_code, FUN=rollmn0)) # ,by=TSE_code
  y4 <- subset(y3,select=c(TSE_code,year,HHI))
  y5 <- merge(x3,y4,by=c('TSE_code','year'))
  DB <- transform(y5, STR_HHI = as.numeric(STR)*as.numeric(HHI))
  DBA <- as.data.table(DB[order(DB$TSE_code,DB$year,DB$company),])
  return(DBA)
}
catchDB <- function(x){
  y <- base::subset(x=x,select=c(company,market,TSE_code,TSE_name,year,
                         ETR,CETR,STR,HHI,STR_HHI,
                         ROA,SIZE,LEV,INTANG,QUICK,EQINC,OUTINSTI,RELATIN,RELATOUT,FAM_Dum
  ))
  return(y)}
winsorized.sample <- function (x, prob = 0) { # remove NA
  n <- length(x)
  n0 <- length(x[!is.na(x)])
  low <- floor(n0 * prob) + 1
  high <- n0 + 1 - low
  idx <- seq(1,n)
  DT<-data.frame(idx,x)
  DT2<-DT[order(DT$x,DT$idx,na.last=TRUE),]
  DT2$x[1:low]<-DT2$x[low]
  DT2$x[high:n0]<-DT2$x[high]
  DT3<-DT2[order(DT2$idx,DT2$x),]
  x2<-DT3$x
  return(x2)}
winsamp1 <- function(x = 'TEJ7', col, prob=0.01, na.rm=TRUE){
  x1 <- captureOutput(
    for(y in col){cat(x,'$',y,' <- winsor(',x,'$',y,',trim = ',prob,',na.rm = ',na.rm,')',sep="",fill = TRUE)})
  eval(base::parse(text=x1))} 
winsamp2 <- function(x = 'TEJ7', col, prob=0.01){
  DD <- captureOutput(
    for(y in col){cat(x,'$',y,' <- winsorized.sample(x=',x,'$',y,',prob = ',prob,')',sep="",fill = TRUE)})
  eval(base::parse(text=DD))} 