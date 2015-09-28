library(ggplot2)
library(scatterplot3d) 



q<-sprintf('select distinct T0."ID" as "Atom_chem_shift.ID",
T0."Entity_ID" as "Atom_chem_shift.Entity_ID",
T0."Comp_index_ID" as "Atom_chem_shift.Comp_index_ID",
T0."Comp_ID" as "Atom_chem_shift.Comp_ID",
T0."Atom_ID" as "Atom_chem_shift.Atom_ID",
T0."Atom_type" as "Atom_chem_shift.Atom_type",
T0."Val" as "Atom_chem_shift.Val",
T0."Val_err" as "Atom_chem_shift.Val_err",
T0."Ambiguity_code" as "Atom_chem_shift.Ambiguity_code",
T0."Entry_ID" as "Atom_chem_shift.Entry_ID" 
from "Atom_chem_shift" T0 where 
T0."Comp_ID" ~* \'.*\' and 
T0."Atom_ID" ~* \'.*\' and 
T0."Atom_type" ~* \'.*\' and 
T0."Ambiguity_code" ~* \'.*\' and 
T0."Entry_ID" ~* \'.*\'')

q<-sprintf('select distinct T0."ID" as "Atom_chem_shift.ID",
T0."Entity_ID" as "Atom_chem_shift.Entity_ID",
T0."Comp_index_ID" as "Atom_chem_shift.Comp_index_ID",
T0."Comp_ID" as "Atom_chem_shift.Comp_ID",
T0."Atom_ID" as "Atom_chem_shift.Atom_ID",
T0."Atom_type" as "Atom_chem_shift.Atom_type",
T0."Val" as "Atom_chem_shift.Val",
T0."Val_err" as "Atom_chem_shift.Val_err",
T0."Ambiguity_code" as "Atom_chem_shift.Ambiguity_code",
T0."Entry_ID" as "Atom_chem_shift.Entry_ID" 
from "Atom_chem_shift" T0 where 
T0."Comp_ID" ~* \'.*\' and 
T0."Atom_ID" ~* \'.*\' and 
T0."Atom_type" ~* \'.*\' and 
T0."Ambiguity_code" ~* \'.*\' and 
T0."Entry_ID" ~* \'.*\'')

rawdata2<-GET('http://manta.bmrb.wisc.edu/api/a/query.php',
             query=list(db="metabolomics",
                        query=q))
rawdata<-GET('http://manta.bmrb.wisc.edu/api/a/query.php',
             query=list(db="bmrb",
                        query=q))

c<-content(rawdata,'text')
# the content looks like python list object, so I am removing unwanted [[]]
d<-gsub("\\]","",gsub("\\[","",c))
# convert the data into csvs of single column
t<-read.table(textConnection(d),sep="\n")
outdata<-colsplit(t$V1,",",names=c('CSId','CSEntryId','CSCompIndexId','CSCompId','CSAtomId','CSAtomType','CS','CSError','CSAmbigCode','BMRBId'))

plot1<-ggplot(outdata)+
  geom_density(aes(x=CS,color=CSAtomId,fill=CSAtomId),alpha=0.5);
plot1


shiftCA=subset(outdata,CSAtomId=="CA",select=c(BMRBId,CSCompIndexId,CSCompId,CS))
shiftCB=subset(outdata,CSAtomId=="CB",select=c(BMRBId,CSCompIndexId,CSCompId,CS))
shiftN=subset(outdata,CSAtomId=="N",select=c(BMRBId,CSCompIndexId,CSCompId,CS))
colnames(shiftCA)[4]="CA"
colnames(shiftCB)[4]="CB"
colnames(shiftN)[4]="N"
CAvsCB<-merge(shiftCA,shiftCB,by=c("BMRBId","CSCompIndexId"))

shiftHA=subset(outdata,CSAtomId=="HA",select=c(BMRBId,CSCompIndexId,CSCompId,CS))
shiftHB=subset(outdata,CSAtomId=="HB",select=c(BMRBId,CSCompIndexId,CSCompId,CS))
colnames(shiftHA)[4]="HA"
colnames(shiftHB)[4]="HB"
HAvsHB<-merge(shiftHA,shiftHB,by=c("BMRBId","CSCompIndexId"))


triple<-merge(CAvsCB,shiftN,by=c("BMRBId","CSCompIndexId"))
CAvsCB$tag=NA
CAvsCB$tag[CAvsCB$CSCompId.x=="ALA"]<-"Ala"
CAvsCB$tag[CAvsCB$CSCompId.x=="LYS"|CAvsCB$CSCompId.x=="ARG"|CAvsCB$CSCompId.x=="GLN"|
             CAvsCB$CSCompId.x=="GLU"|
             CAvsCB$CSCompId.x=="HIS"|
             CAvsCB$CSCompId.x=="TRP"|
             CAvsCB$CSCompId.x=="CYS"|
             CAvsCB$CSCompId.x=="VAL"|
             CAvsCB$CSCompId.x=="MET"]<-"Lys,Arg,Gln,Glu,His,Trp,Cys,Val,Met"
CAvsCB$tag[CAvsCB$CSCompId.x=="VAL"]<-"Val"
CAvsCB$tag[CAvsCB$CSCompId.x=="ASP"|
             CAvsCB$CSCompId.x=="ASN"|
             CAvsCB$CSCompId.x=="PHE"|
             CAvsCB$CSCompId.x=="TYR"|
             CAvsCB$CSCompId.x=="ILE"|
             CAvsCB$CSCompId.x=="LEU"]<-"Asp,Asn,Phe,Tyr,Ile,Leu"
CAvsCB$tag[CAvsCB$CSCompId.x=="THR"]<-"Thr"
plot2<-ggplot(CAvsCB)+
  geom_point(aes(x=CA,y=CB,color=tag),alpha=0.2)+
  geom_density2d(aes(x=CA,y=CB,color=tag),size=1)+
  xlim(90,0)+
  ylim(90,0)+
  theme(panel.background = element_blank(),
        text = element_text(color='black'),
        axis.text.x=element_text(color='black',angle=90,hjust=1,vjust=0.5),
        axis.text=element_text(color='black'),
        panel.grid.major = element_line(colour = "gray"),
        panel.grid.minor = element_line(colour = "gray"),
        panel.border =element_rect(colour = "black",fill=NA),
        legend.position='bottom');
plot2

plot4<-ggplot(HAvsHB)+
  geom_point(aes(x=HA,y=HB,color=CSCompId.x))+
  theme(panel.background = element_blank(),
        text = element_text(color='black'),
        axis.text.x=element_text(color='black',angle=90,hjust=1,vjust=0.5),
        axis.text=element_text(color='black'),
        panel.grid.major = element_line(colour = "gray"),
        panel.grid.minor = element_line(colour = "gray"),
        panel.border =element_rect(colour = "black",fill=NA),
        legend.position='bottom');
plot4

write.table(triple,"/kbaskaran/bmrb/triple.dat")

plot3<-scatterplot3d(triple$CA,triple$CB,triple$N,color = triple$CSCompId.x);
plot3
head(outdata)
