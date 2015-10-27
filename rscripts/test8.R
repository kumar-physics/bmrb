
library(ggvis)
library(dplyr)


df<-fetchBMRB('16075,16076')

dfh<-N15HSQC(df)
dfh$BMRB_ID= as.character(dfh$BMRB_ID)
dfh$Comp_index_ID= as.character(dfh$Comp_index_ID)
dfh$aa<-NA
dfh$aa<-xx3to1(dfh$Comp_ID_H)
dfh %>% ggvis(~H,~N,stroke=~Comp_index_ID) %>% 
  layer_lines()%>%
  hide_legend("stroke")%>%
  layer_text(text:=~aa)


%>%
  add_legend("shape", properties = legend_props(legend = list(x = -100))) 

aa3to1<-list('ALA'='A','ARG'='R','ASN'='N','ASP'='D','CYS'='C',
             'GLU'='E','GLN'='Q','GLY'='G','HIS'='H','ILE'='I',
             'LEU'='L','LYS'='K','MET'='M','PHE'='F','PRO'='P',
             'SER'='S','THR'='T','TRP'='W','TYR'='Y','VAL'='V')

xx3to1<-function(aa){
  aa3to1<-list('ALA'='A','ARG'='R','ASN'='N','ASP'='D','CYS'='C',
               'GLU'='E','GLN'='Q','GLY'='G','HIS'='H','ILE'='I',
               'LEU'='L','LYS'='K','MET'='M','PHE'='F','PRO'='P',
               'SER'='S','THR'='T','TRP'='W','TYR'='Y','VAL'='V')
  outd<-aa3to1[aa]
  return(as.character(outd))
}
