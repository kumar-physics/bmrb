library(httr)
library(reshape)
library(ggplot2)

fetchBMRB<-function(bmrbID){
  q<-sprintf('select distinct cast("Entry_ID" as integer),"Comp_index_ID","Comp_ID","Atom_ID",
             cast("Val" as float) from "Atom_chem_shift" where "Entry_ID" = 
             \'%d\'order by cast("Entry_ID" as integer),"Comp_index_ID",
             "Comp_ID","Atom_ID",cast("Val" as float)',bmrbID)
  rawdata<-GET('http://manta.bmrb.wisc.edu/api/a/query.php',
               query=list(db="bmrb",
                          query=q))
  c<-content(rawdata,'text')
  d<-gsub("\\]","",gsub("\\[","",c))
  t<-read.table(textConnection(d),sep="\n")
  outdata<-colsplit(t$V1,",",names=c('BMRBId','resId','Res','Atm','CS'))
  return(outdata)
}

r1<-fetchBMRB(10002)
r2<-fetchBMRB(10005)
r<-rbind(r1,r2)
r$AtmId=NA
r$AtmId<-ifelse(grepl("C",r$Atm),"C",ifelse(grepl("H",r$Atm),"H",ifelse(grepl("N",r$Atm),"N",NA)))
ggplot(r)+
  facet_wrap(~AtmId,scales='free')+
  geom_density(aes(x=CS,color=Res,linetype=as.character(BMRBId)))


