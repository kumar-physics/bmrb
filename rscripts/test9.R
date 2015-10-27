library(BMRB)
library(ggplot2)

df<-fetchallBMRB()

aa<-c('ALA','ARG','ASN','ASP','CYS',
      'GLN','GLU','GLY','HIS','ILE',
      'LEU','LYS','MET','PHE','PRO',
      'SER','THR','TRP','TYR','VAL')

sl<-df[df$Comp_ID %in% aa,]

ggplot(subset(sl,Val<300 & Val>-100))+
  facet_wrap(~Atom_ID,scale='free')+
  geom_density(aes(x=Val,color=Comp_ID))

shiftH<-subset(sl,Atom_ID=="CA",select = c(Entry_ID,Assigned_chem_shift_list_ID,Comp_index_ID,Val,Comp_ID))
colnames(shiftH)[4]="CA"
shiftN<-subset(sl,Atom_ID=="N",select = c(Entry_ID,Assigned_chem_shift_list_ID,Comp_index_ID,Val,Comp_ID))
colnames(shiftN)[4]="N"
shiftHN<-merge(shiftH,shiftN, by =c('Entry_ID','Assigned_chem_shift_list_ID','Comp_index_ID','Comp_ID') )


hsqc<-function(df,atm1,atm2){
  shiftH<-subset(df,grepl(atm1,df$Atom_ID),select = c(Entry_ID,Assigned_chem_shift_list_ID,Comp_index_ID,Val,Comp_ID))
  colnames(shiftH)[4]=atm1
  shiftN<-subset(sl,grepl(atm2,df$Atom_ID),select = c(Entry_ID,Assigned_chem_shift_list_ID,Comp_index_ID,Val,Comp_ID))
  colnames(shiftN)[4]=atm2
  shiftHN<-merge(shiftH,shiftN, by =c('Entry_ID','Assigned_chem_shift_list_ID','Comp_index_ID','Comp_ID'))
  return(shiftHN)
}


ggplot(shiftHN)+
  facet_wrap(~Comp_ID)+
  geom_point(aes(x=CA,y=N,color=Comp_ID),alpha=0.3)+
  xlim(0,100)+
  ylim(0,200)

ggplot(df)+
  geom_histogram(aes(x=as.character(Entry_ID),binwidth=100))

ggplot(sl)+
  facet_wrap(~Atom_type)+
  geom_histogram(aes(x=Entry_ID,y=Ambiguity_code,binwidth=1000))

hcb<-hsqc(subset(sl,Val>0 & Val<200),'HB','CB')


ggplot(subset(sl,Val>0 & Val<200 & Atom_ID=="CB"))+
  geom_density(aes(x=Val,color=Comp_ID))

ggplot(hcb)+
  geom_point(aes(x=HB,y=CB,color=Comp_ID))+xlim(0,10)+ylim(0,200)


x<-N15HSQC(fetchBMRB('15060'))
