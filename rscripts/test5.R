

r<-read.csv('/kbaskaran/bmrb/Chem_comp.csv',header=T)

plot1=ggplot(r)+
  geom_histogram(aes(x=Formula_weight,color=Aromatic,fill=Aromatic),alpha=0.5)

s<-read.csv('/kbaskaran/bmrb/meta.hsqc_peaks.csv',header=T)
p<-read.csv('/kbaskaran/bmrb/meta.hsqcpeakcount.csv',header=T)

p2<-merge(r,p,by=c("BMRB"))

d<-merge(r,s,by=c("BMRB"))


plot2=ggplot(d)+
  geom_point(aes(x=x_chem_shift,y=y_chem_shift,size=(x_width*y_width),color=Aromatic))

plot3=ggplot(p2)+
  geom_point(aes(x=Formula_weight,y=peakcount,color=Aromatic))

plot1
plot2
plot3

pdf('/kbaskaran/stat.pdf')
plot1
plot2
plot3
dev.off()