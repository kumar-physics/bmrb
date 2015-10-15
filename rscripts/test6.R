library(ggplot2)
library(scatterplot3d)
df <- read.csv("http://www.bmrb.wisc.edu/ftp/pub/bmrb/relational_tables/nmr-star3.1/Atom_chem_shift.csv", header=TRUE)


ggplot(df)+
  geom_density(aes(x=Val,group=Entry_ID))

ggplot(subset(df,Atom_ID="CB"))+
  geom_density2d(aes(x=Seq_ID,y=Val,group=Entry_ID))+
  ylim(0,100)

shiftCA=subset(df,Atom_ID=="CA")
shiftCB=subset(df,Atom_ID=="CB")
shiftN=subset(df,Atom_ID=="N")


shiftCA<-NA
shiftCB<-NA
shiftN<-NA
shiftCACB=merge(shiftCA,shiftCB,by=c("Entry_ID","Comp_index_ID","Assigned_chem_shift_list_ID"))
shiftCACBN=merge(shiftCACB,shiftN,by=c("Entry_ID","Comp_index_ID","Assigned_chem_shift_list_ID"))
attach(shiftCACBN)
qplot(Val.x,Val.y,Val,color=Comp_ID)
write.table(shiftCACBN,'/kbaskaran/bmrb/triple.dat')
ggplot(shiftCACB)+
  geom_point(aes(x=Val.x,y=Val.y,color=Comp_ID.x))+
  xlim(0,100)+
  ylim(0,100)