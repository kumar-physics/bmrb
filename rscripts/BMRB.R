library(httr)
library(reshape)
library(ggplot2)
library(plyr)
library(devtools)
library(roxygen2)
library(BMRB)
setwd('/home/kbaskaran/git/bmrb/RBMRB')
use_package("plyr")
use_package("httr")
use_package("reshape")
create('BMRB')
setwd('./BMRB')
document()
setwd("..")
install('BMRB')

fetchBMRB<-function(BMRBidlist){
  rawdata<-GET('http://manta.bmrb.wisc.edu/api/a/chemshifts.php',
               query=list(idlist=BMRBidlist))
  c<-content(rawdata,'text')
  if (nchar(c)>5){
    d<-gsub("\\]","",gsub("\\[","",c))
    d2<-gsub("\n\"Entry_ID\",\"id\",\"Entity_ID\",\"Comp_index_ID\",\"Comp_ID\",\"Atom_ID\",\"Atom_type\",\"Val\",\"Val_err\",\"Ambiguity_code\",\"Assigned_chem_shift_list_ID\"","",d)
    t<-read.table(textConnection(d2),sep="\n")
    outdata<-colsplit(t$V1,",",names=c('x','BMRB_ID','Entry_ID','Entity_ID','Comp_index_ID','Comp_ID','Atom_ID','Atom_type','Chemical_shift','err','Ambiguity_code','Assigned_chem_shift_list_ID'))
    outdata$x<-NULL
  }
  else{
    cat("Invalid BMRB ID")
    outdata<-NA
  }
  return (outdata)
}


N15HSQC<-function(csdata){
  shiftH<-subset(x,Atom_ID=="H")
  names(shiftH)[names(shiftH)=="Chemical_shift"]<-"H"
  shiftN<-subset(x,Atom_ID=="N")
  names(shiftN)[names(shiftN)=="Chemical_shift"]<-"N"
  shiftHN<-merge(shiftH,shiftN,by=c('BMRB_ID','Comp_index_ID','Assigned_chem_shift_list_ID'))
  outdat<-shiftHN[,c("BMRB_ID","Comp_index_ID","Assigned_chem_shift_list_ID","Comp_ID.x","Comp_ID.y","H","N")]
  names(outdat)[names(outdat)=="Comp_ID.x"]<-"Comp_ID_H"
  names(outdat)[names(outdat)=="Comp_ID.y"]<-"Comp_ID_N"
  return(outdat)
}


