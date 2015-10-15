
library(httr)
library(reshape)
library(ggplot2)
library(plyr)

q<-sprintf("http://manta.bmrb.wisc.edu/api/a/chemshifts.php?idlist=1234,5678,90")

rawdata<-GET('http://manta.bmrb.wisc.edu/api/a/chemshifts.php',
             query=list(idlist='1234'))

c<-content(rawdata,'text')
d<-gsub("\\]","",gsub("\\[","",c))
d2<-gsub("\n\"Entry_ID\",\"id\",\"Entity_ID\",\"Comp_index_ID\",\"Comp_ID\",\"Atom_ID\",\"Atom_type\",\"Val\",\"Val_err\",\"Ambiguity_code\",\"Assigned_chem_shift_list_ID\"","",d)
t<-read.table(textConnection(d2),sep="\n")
outdata<-colsplit(t$V1,",",names=c('x','BMRB_ID','Entry_ID','Entity_ID','Comp_index_ID','Comp_ID','Atom_ID','Atom_type','Chemical_shift','err','Ambiguity_code','Assigned_chem_shift_list_ID'))
outdata$x<-NULL
