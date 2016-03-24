'''
Created on Nov 5, 2015

@author: kbaskaran
'''
import sys
sys.path.append('/home/kumaran/git/bmrb/python/Metabolomics/StarParser/parser/')
#sys.path.append('/home/kumaran/python/')
import meta
from string import atoi,atof

class MetaParser(object):
    '''
    classdocs
    '''

    def __init__(self):
        '''
        Constructor
        '''
        
    def getData(self,metaId):
        self.starData=meta.entry.fromDatabase(metaId)
#         self.NumberOfComponents=atoi(self.starData['assembly'].getTag('Number_of_components')[0])
#         try:
#             self.assigned_chemical_shifts=self.starData['assigned_chemical_shifts']['_Atom_chem_shift'].getDataByTag(['Atom_ID','Val','Ambiguity_code'])
#         except KeyError:
#             self.assigned_chemical_shifts=[]
#         try:
#             self.assigned_peak_list=self.starData['spectral_peak_1H_13C_HSQC']['_Assigned_peak_chem_shift'].getDataByTag(['Peak_ID','Spectral_dim_ID','Val','Atom_ID'])
#             self.peak_list=self.starData['spectral_peak_1H_13C_HSQC']['_Peak_char'].getDataByTag(['Peak_ID','Chem_shift_val'])
#         except KeyError:
#             try:
#                 self.assigned_peak_list=self.starData['spectral_peak_HSQC']['_Assigned_peak_chem_shift'].getDataByTag(['Peak_ID','Spectral_dim_ID','Val','Atom_ID'])
#                 self.peak_list=self.starData['spectral_peak_HSQC']['_Peak_char'].getDataByTag(['Peak_ID','Chem_shift_val'])
#             except KeyError:
#                 self.assigned_peak_list=[]
#                 self.peak_list=[]
#         self.atomId=self.starData['chem_comp_1']['_Atom_nomenclature'].getDataByTag(['Atom_ID'])
#         self.bondInfo=self.starData['chem_comp_1']['_Chem_comp_bond'].getDataByTag(['Atom_ID_1','Atom_ID_2','Value_order'])
#         self.hsqcAtoms=[]
#         for i in self.bondInfo:
#             if i[0][0]=="C" and i[1][0]=="H" and i[2]=="SING":
#                 self.hsqcAtoms.append(i[0])
#                 self.hsqcAtoms.append(i[1])
        self.hsqc_peaks()
    
    
    def checkAll2(self):
        for i in range(300,305):#range(1,10600):
            self.metId="bmse%06d"%(i)
            if i!=124:
                try:
                    self.getData(self.metId)
                    if len(self.peak_list)>0:
                        n=len(self.peak_list)/2
                        apid=[atoi(i[0]) for i in self.assigned_peak_list]
                        ambi=[i[-1] for i in self.assigned_chemical_shifts]
                        xx=[apid.count(j+1) for j in range(n)]
                        #if ambi.count('1')==len(ambi) and len(self.peak_list)/2<= len(self.hsqcAtoms)/2:
                        print self.metId,len(self.hsqcAtoms)/2,len(self.peak_list)/2,len(self.assigned_peak_list),len(self.assigned_chemical_shifts)
                        
                   
                        #print self.assigned_chemical_shifts
                        #print self.atomId
                        #print [i[0] for i in self.peak_list]
                        #print self.hsqcAtoms
                    
                except IOError:
                    pass
   
    
    
       
    def checkEntry(self,bmseid):
        self.metId="bmse%06d"%(bmseid)
        self.getData(self.metId)
        name=self.starData.getTag('_Entry.Title')[0]
        peak_list=len(self.starData.getTag('_Spectral_peak_list.ID'))
        apeak_list=len(set(self.starData.getTag('_Assigned_peak_chem_shift.Spectral_peak_list_ID')))
        #print bmseid,name,peak_list,apeak_list
        pid=self.starData.getTag('_Spectral_peak_list.ID')
        exp=self.starData.getTag('_Spectral_peak_list.Experiment_name')
        dim=self.starData.getTag('_Spectral_peak_list.Number_of_spectral_dimensions')
        asp=self.starData.getTag('_Assigned_peak_chem_shift.Spectral_peak_list_ID')
        t1=self.starData.getTag('_Peak_char.Spectral_peak_list_ID')
        p1=self.starData.getTag('_Spectral_transition_char.Spectral_peak_list_ID')
        #print self.metId,exp
        for e in exp:
            eid=pid[exp.index(e)]
            d=atoi(dim[exp.index(e)])
            if asp.count(eid)>0 and t1.count(eid)>0:
                if asp.count(eid)>t1.count(eid):
                    m="yes"
                else:
                    m="no"
                if p1.count(eid)>0:
                    if p1.count(eid) > t1.count(eid) :
                        m2="yes"
                    else:
                        m2="no"
                else:
                    m2="info unavailable"
            else:
                m="info unavailable"
                m2="info unavailable"
            print "%d;%s;%s;%d;%d;%d;%s;%s"%(bmseid,name,e,asp.count(eid),t1.count(eid)/d,p1.count(eid)/d,m,m2)
#         print self.starData.getTag('_Assigned_peak_chem_shift.Atom_ID')
#         print self.starData.getTag('_Assigned_peak_chem_shift.Spectral_peak_list_ID')
#         print self.starData.getTag('_Spectral_peak_list.ID')
#         print self.starData.getTag('_Spectral_peak_list.Experiment_name')
#         print self.starData.getTag('_Peak.ID')
#         print self.starData.getTag('_Peak_char.Spectral_peak_list_ID')
#         x=self.starData.getTag('_Spectral_transition_char.Spectral_peak_list_ID')
#         print x,set(x)
#         for i in set(x):
#             print i,x.count(i)
#         print self.hsqc_expected_peaks
    def hsqc_peaks(self):
        self.starData
        a1=self.starData.getTag('_Chem_comp_bond.Atom_ID_1')
        a2=self.starData.getTag('_Chem_comp_bond.Atom_ID_2')
        v1=self.starData.getTag('_Chem_comp_bond.Value_order')
        n=0
        for i in range(len(a1)):
            if (a1[i][0]=="C" and a2[i][0]=="H" and v1[i]=="SING") or (a2[i][0]=="C" and a1[i][0]=="H" and v1[i]=="SING"):
                n+=1
        self.hsqc_expected_peaks=n
        
        
    def checkAssignment(self,atmlist,asignlist):
        x=[]
        for i in asignlist:
            x.append(atmlist.count(i[0]))
            x.append(atmlist.count(i[1]))
        return x
    
    def checkAllPeaksAssigned(self):
        try:
            self.allpeaks=set(self.starData['spectral_peak_1H_13C_HSQC']['_Peak_char'].getDataByTag(['Peak_ID'])[0])
            self.allAsignedPeaks=set(self.starData['spectral_peak_1H_13C_HSQC']['_Assigned_peak_chem_shift'].getDataByTag(['Peak_ID'])[0])
        except KeyError:
            try:
                self.allpeaks=set(self.starData['spectral_peak_HSQC']['_Peak_char'].getDataByTag(['Peak_ID'])[0])
                self.allAsignedPeaks=set(self.starData['spectral_peak_HSQC']['_Assigned_peak_chem_shift'].getDataByTag(['Peak_ID'])[0])
            except KeyError:
                self.allpeaks=set([1])
                self.allAsignedPeaks=set([0])
        
        if self.allpeaks==self.allAsignedPeaks:
            self.flgg=True
        
        else:
            self.flgg=False
        
        return self.flgg
        
            
    def checkAll(self):
        for i in range(1,10600):
            self.metId="bmse%06d"%(i)
            if i!=124:
                try:
                    self.getData(self.metId)
                    nhsqc=len(self.hsqcAtoms)/2
                    npeaks=len(self.peak_list)/2
                    nassigned=len(self.assigned_peak_list)/2
                    ambi=[i[-1] for i in self.assigned_chemical_shifts if i[-1]!='1']
                    if len(self.assigned_chemical_shifts)==0:
                        assigned_cs="no"
                    else:
                        assigned_cs="yes"
                    if len(self.assigned_peak_list)==0:
                        hsqc_assigned="no"
                    else:
                        hsqc_assigned="yes"
                        
                    if len(ambi)==0:
                        all_unique="yes"
                    else:
                        all_unique="no"
                        
                    if npeaks>nhsqc:
                        morehsqcpeaks="yes"
                    else:
                        morehsqcpeaks="no"
                    if hsqc_assigned=="no":
                        all_unique="no"
                        morehsqcpeaks="no"
                    print "%s\t%s\t%s\t%s\t%s"%(self.metId,hsqc_assigned,all_unique,morehsqcpeaks,assigned_cs)
                    #print self.assigned_chemical_shifts
                    #print self.assigned_peak_list
                    #print self.peak_list
                    #print self.hsqcAtoms
                    #if (not(self.checkAllPeaksAssigned()) and len(self.allpeaks)>=2):
                     #   print self.metId,len(self.allpeaks),len(self.allAsignedPeaks)
#                     self.SingleBondCH()
#                     self.AmbiguityCode()
#                     #print self.metId
#                     #print self.assigned_peak_list
#                     asigned_atoms_hsqc=[i[3] for i in self.assigned_peak_list]
#                     uniq_asign=self.checkAssignment( asigned_atoms_hsqc,self.hsqcAtoms)
#                     ambcheck= self.ambigu[0].count('1')==len(self.ambigu[0])
#                     if len(uniq_asign)==sum(uniq_asign) and len(uniq_asign)!=0 and ambcheck:
#                         print self.metId,len(uniq_asign),len(self.peak_list)#,ambcheck,self.ambigu#,uniq_asign,asigned_atoms_hsqc,self.hsqcAtoms
                    #print len(self.ChemicalShifts())
                    #print "Assigned peaks",len(self.assigned_peak_list)
                    #print "Actual peaks",len(self.peak_list)/2
                    #self.SingleBondCH()
                    #print "Possible peaks",len(self.hsqcAtoms)
                    
                except IOError:
                    pass
                    #print self.metId, "Not in database"
            else:
                #print self.metId, "File format problem"
                pass
            
        
if __name__=="__main__":
    p=MetaParser()
<<<<<<< HEAD
<<<<<<< Updated upstream
    p.checkAll2()
=======
    p.checklist('/home/kumaran/share/bmrb/metab_under_assigned.txt')
>>>>>>> Stashed changes
=======
    #p.checkEntry(150)
    for i in range(0,1100):
        try:
            if i!=124 :p.checkEntry(i)
        except IOError:
            pass
>>>>>>> origin/master
