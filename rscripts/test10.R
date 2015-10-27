library(BMRB)
library(ggplot2)

df<-fetchBMRB('10051,17183,17678,17785,18461,18479,18529,18629,25114,25115,25116,25730')
hd<-N15HSQC(df)


ggplot(hd)+
  geom_point(aes(x=H,y=N,color=as.character(BMRB_ID)))+
  geom_line(aes(x=H,y=N,group=as.character(Comp_index_ID)))

c<-subset(df,Atom_ID=="C")
ca<-subset(df,Atom_ID=="CA")
n<-subset(df,Atom_ID=="N")

ggplot(df)+
  facet_wrap(~Comp_ID)+
  geom_point(aes(x=Chemical_shift,y=Comp_index_ID,color=as.character(BMRB_ID)))


fullset<-fetchallBMRB()


ggplot(subset(fullset,Val < 200 & Val > 0 & (Atom_ID=="C" | Atom_ID=="CA" |Atom_ID=="CB") ))+
  geom_density(aes(x=Val,color=Atom_ID))

cashifts<-subset(fullset,Atom_ID=="CA",select=c(Entry_ID,Comp_index_ID,Assigned_chem_shift_list_ID,Comp_ID,Val))
cbshifts<-subset(fullset,Atom_ID=="CB",select=c(Entry_ID,Comp_index_ID,Assigned_chem_shift_list_ID,Comp_ID,Val))

colnames(cashifts)[5]="CA"
colnames(cbshifts)[5]="CB"

cacbshifts<-merge(cashifts,cbshifts,by=c('Entry_ID','Comp_index_ID','Assigned_chem_shift_list_ID','Comp_ID'))

cacbshifts$tag=NA
cacbshifts$tag[cacbshifts$Comp_ID=="ALA"]<-"Ala"
cacbshifts$tag[cacbshifts$Comp_ID=="LYS"|cacbshifts$Comp_ID=="ARG"|cacbshifts$Comp_ID=="GLN"|
                 cacbshifts$Comp_ID=="GLU"|
                 cacbshifts$Comp_ID=="HIS"|
                 cacbshifts$Comp_ID=="TRP"|
                 cacbshifts$Comp_ID=="CYS"|
                 cacbshifts$Comp_ID=="VAL"|
                 cacbshifts$Comp_ID=="MET"]<-"Lys,Arg,Gln,Glu,His,Trp,Cys,Val,Met"
cacbshifts$tag[cacbshifts$Comp_ID=="VAL"]<-"Val"
cacbshifts$tag[cacbshifts$Comp_ID=="ASP"|
                 cacbshifts$Comp_ID=="ASN"|
                 cacbshifts$Comp_ID=="PHE"|
                 cacbshifts$Comp_ID=="TYR"|
                 cacbshifts$Comp_ID=="ILE"|
                 cacbshifts$Comp_ID=="LEU"]<-"Asp,Asn,Phe,Tyr,Ile,Leu"
cacbshifts$tag[cacbshifts$Comp_ID=="THR"]<-"Thr"

ggplot(subset(cacbshifts,CA<100 & CB < 100 & CA >0 & CB >0))+
  geom_point(aes(x=CA,y=CB,color=tag))
