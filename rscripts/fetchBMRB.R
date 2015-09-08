library(httr)
library(reshape)
library(ggplot2)

fetchBMRB<-function(bmrbID){
  # function to get the bmrb data using httr protocol
  # got this query from advanced search in BMRB website
  q<-sprintf('select distinct cast("Entry_ID" as integer),"Comp_index_ID","Comp_ID","Atom_ID",
             cast("Val" as float) from "Atom_chem_shift" where "Entry_ID" = 
             \'%d\'order by cast("Entry_ID" as integer),"Comp_index_ID",
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
  return(outdata)
}

r1<-fetchBMRB(10002)
r2<-fetchBMRB(10005)
r<-rbind(r1,r2)
# atmId is added  to identify atom type, which can be used to cs distribution for different atom type
r$AtmId=NA
# grepl is equal to whilecard like C* or H* or N*
r$AtmId<-ifelse(grepl("C",r$Atm),"C",ifelse(grepl("H",r$Atm),"H",ifelse(grepl("N",r$Atm),"N",NA)))
plot1=ggplot(r)+
  facet_wrap(~AtmId,scales='free')+
  geom_density(aes(x=CS,color=Res,linetype=as.character(BMRBId)))
plot1
#If you want pdf un comment the following lines
#pdf('example.pdf')
#plot1
#dev.off()

