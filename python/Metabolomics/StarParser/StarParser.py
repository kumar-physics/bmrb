'''
Created on Nov 5, 2015

@author: kbaskaran
'''
import sys
sys.path.append('./parser/')
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
        #print self.starData.printTree()
        #for i in self.starData['assigned_chemical_shifts']:
        #    for j in i:
        #        print j
        #print self.starData['assigned_chemical_shifts'][-1]
        #print self.starData['spectral_peak_1H_13C_HSQC']['_Spectral_dim'].getDataByTag(['Atom_type','ID'])
        #print self.starData['assigned_chemical_shifts']['_Atom_chem_shift'].getDataByTag(['Atom_ID','Val'])
        #print self.starData['spectral_peak_1H_13C_HSQC']['_Peak_char'].getDataByTag(['Peak_ID','Chem_shift_val'])
        #print self.starData['spectral_peak_1H_13C_HSQC']['_Assigned_peak_chem_shift'].getDataByTag(['Peak_ID','Spectral_dim_ID','Val','Atom_ID'])
        #print self.starData['assembly'].getTag('Number_of_components')
        
    def check(self):
        compounds_count=atoi(self.starData['assembly'].getTag('Number_of_components')[0])
        try:
            assigned_peak_list=self.starData['spectral_peak_1H_13C_HSQC']['_Assigned_peak_chem_shift'].getDataByTag(['Peak_ID','Spectral_dim_ID','Val','Atom_ID'])
            peak_list=self.starData['spectral_peak_1H_13C_HSQC']['_Peak_char'].getDataByTag(['Peak_ID','Chem_shift_val'])
        except KeyError:
            try:
                assigned_peak_list=self.starData['spectral_peak_HSQC']['_Assigned_peak_chem_shift'].getDataByTag(['Peak_ID','Spectral_dim_ID','Val','Atom_ID'])
                peak_list=self.starData['spectral_peak_HSQC']['_Peak_char'].getDataByTag(['Peak_ID','Chem_shift_val'])
            except KeyError:
                assigned_peak_list=[]
                peak_list=['0']
            self.flg="Not Ok HSQC not assigned"
        assigned_chem_shifts=self.starData['assigned_chemical_shifts']['_Atom_chem_shift'].getDataByTag(['Atom_ID','Val'])
        atom_names=self.starData['chem_comp_1']['_Atom_nomenclature'].getDataByTag(['Atom_ID'])
        unique_peaks=set([i[0] for i in peak_list])
        unique_assigned_peaks=set([i[0] for i in assigned_peak_list])
        if unique_peaks == unique_assigned_peaks:
            self.flg="Ok"
        else:
            self.flg="Not Ok"
        print unique_peaks
        print unique_assigned_peaks
        return self.flg
    def checklist(self,fname):
        f=open(fname,'r').read().split("\n")
        for id in f:
            try:
                self.getData(id)
                print id,self.check()
            except IOError:
                print id,"Not in database"
            
            
            
        
if __name__=="__main__":
    p=MetaParser()
    p.checklist('/kbaskaran/metabolomics/metab_under_assigned.txt')