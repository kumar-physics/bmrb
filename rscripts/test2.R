library(httr)
library(reshape)
library(ggplot2)

fetchBMRB2<-function(bmrbID,data=NA){
  # function to get the bmrb data using httr protocol
  # got this query from advanced search in BMRB website
  q<-sprintf('select distinct cast("Entry_ID" as integer),"Comp_index_ID","Comp_ID","Atom_ID",
             cast("Val" as float) from "Atom_chem_shift" where "Entry_ID" = 
             \'%s\'order by cast("Entry_ID" as integer),"Comp_index_ID",
             "Comp_ID","Atom_ID",cast("Val" as float)',bmrbID)
  # this will get the raw data with headders
  rawdata<-GET('http://manta.bmrb.wisc.edu/api/a/query.php',
               query=list(db="bmrb",
                          query=q))
  # extract the content of the data
  c<-content(rawdata,'text')
  # the content looks like python list object, so I am removing unwanted [[]]
  d<-gsub("\\]","",gsub("\\[","",c))
  # convert the data into csvs of single column
  t<-read.table(textConnection(d),sep="\n")
  # split the csv and now we have r data frame
  outdata<-colsplit(t$V1,",",names=c('BMRBId','resId','Res','Atm','CS'))
  # return the r data frame
  if (all(is.na(data))){
    data = outdata
  }else{
    data = rbind(data,outdata)
  }
  data<-rbind(data,outdata)
  return(data)
}

hsqc_HN<-function(bmrbID,data=NA){
  #function to create hsqc data set by selection only H and N chemial shifts
  r<-fetchBMRB(bmrbID)
  shiftH=subset(r,Atm=="H")
  shiftN=subset(r,Atm=="N")
  colnames(shiftH)[5]="H"
  colnames(shiftN)[5]="N"
  hsqc_HN_data<-merge(shiftH,shiftN,by=c("BMRBId","resId"))
  if (all(is.na(data))){
    data = hsqc_HN_data
  }else{
    data = rbind(data,hsqc_HN_data)
  }
  return(data)
}

d<-fetchBMRB2('.*')
