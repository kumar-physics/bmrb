library(httr)
library(reshape)
library(ggplot2)

fetchBMRB<-function(bmrbID,data=NA){
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

#Example 1: fetch bmrb chemical shist table for a given bmrb entry
r<-fetchBMRB(15076)
# multiple entries may be added to same data frame
r<-fetchBMRB(15077,r)
r<-fetchBMRB(15078,r)

# atmId is added  to identify atom type, which can be used to cs distribution for different atom type
r$AtmId=NA
# grepl is equal to whilecard like C* or H* or N*
r$AtmId<-ifelse(grepl("C",r$Atm),"C",ifelse(grepl("H",r$Atm),"H",ifelse(grepl("N",r$Atm),"N",NA)))

# plotting carbon chemical shifts for each residue type
plotC=ggplot(subset(r,AtmId=="C"))+
  facet_wrap(~Res,scales='free_y')+
  geom_point(aes(x=CS,y=resId,shape=Atm,color=as.character(BMRBId)))+
  theme(panel.background = element_blank(),
        text = element_text(color='black'),
        axis.text.x=element_text(color='black',angle=90,hjust=1,vjust=0.5),
        axis.text=element_text(color='black'),
        panel.grid.major = element_line(colour = "gray"),
        panel.grid.minor = element_line(colour = "gray"),
        panel.border =element_rect(colour = "black",fill=NA),
        legend.position='bottom');
plotC
# plotting proton chemical shifts for each residue type
plotH=ggplot(subset(r,AtmId=="H"))+
  facet_wrap(~Res,scales='free_y')+
  geom_point(aes(x=CS,y=resId,shape=Atm,color=as.character(BMRBId)))+
  theme(panel.background = element_blank(),
        text = element_text(color='black'),
        axis.text.x=element_text(color='black',angle=90,hjust=1,vjust=0.5),
        axis.text=element_text(color='black'),
        panel.grid.major = element_line(colour = "gray"),
        panel.grid.minor = element_line(colour = "gray"),
        panel.border =element_rect(colour = "black",fill=NA),
        legend.position='bottom');
plotH

# plotting nitrogen chemical shifts for each residue type
plotN=ggplot(subset(r,AtmId=="N"))+
  facet_wrap(~Res,scales='free_y')+
  geom_point(aes(x=CS,y=resId,shape=Atm,color=as.character(BMRBId)))+
  theme(panel.background = element_blank(),
        text = element_text(color='black'),
        axis.text.x=element_text(color='black',angle=90,hjust=1,vjust=0.5),
        axis.text=element_text(color='black'),
        panel.grid.major = element_line(colour = "gray"),
        panel.grid.minor = element_line(colour = "gray"),
        panel.border =element_rect(colour = "black",fill=NA),
        legend.position='bottom');
plotN


#Example 2: HSQC(H-N) spectra

# data can be directly fectched from BMRB
p<-hsqc_HN(15076)
# multiple entries can be loaded into the same data frame
p<-hsqc_HN(15077,p)
p<-hsqc_HN(15078,p)
p<-hsqc_HN(15953,p)
p<-hsqc_HN(16847,p)
#hsqc spectrum
hsqcplot=ggplot(p)+
  geom_text(aes(x=H,y=N,color=as.character(BMRBId),label=as.character(resId)),alpha=0.5)+
  #stat_density2d(aes(x=H,y=N,color=as.character(resId)),h=0.5,alpha=1.0)+
  geom_point(aes(x=H,y=N,shape=Res.x),alpha=0.3,size=3)+
  scale_shape_manual(values = 0:20)+
  theme(panel.background = element_blank(),
        text = element_text(color='black'),
        axis.text.x=element_text(color='black',angle=90,hjust=1,vjust=0.5),
        axis.text=element_text(color='black'),
        panel.grid.major = element_line(colour = "gray"),
        panel.grid.minor = element_line(colour = "gray"),
        panel.border =element_rect(colour = "black",fill=NA),
        legend.position='bottom');
hsqcplot

d<-ggplot(p,aes(H,N,color=as.character(resId),shape=as.character(BMRBId)))+
  geom_point()+geom_path(aes(group=as.character(resId)))
d