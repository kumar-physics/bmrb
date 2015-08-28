'''
Created on Aug 27, 2015

@author: kbaskaran
'''

import xml.etree.ElementTree as ET
import urllib,urllib2
import os


class BlastParser:
    '''
    http://www.bmrb.wisc.edu/ftp/pub/bmrb/entry_directories/bmr255/bmr255.blast.xml
    classdocs
    '''
    def getFile(self,bmrbId):
        self.bmrbId=bmrbId
        self.fname="/kbaskaran/bmrb/bmr%s.blast.xml"%(self.bmrbId)
        self.blasturl="http://www.bmrb.wisc.edu/ftp/pub/bmrb/entry_directories/bmr%s/bmr%s.blast.xml"%(self.bmrbId,self.bmrbId)
        try:
            resp=urllib2.urlopen(self.blasturl)
            urllib.urlretrieve(self.blasturl,self.fname)
            self.prinOutput()
        except urllib2.HTTPError:
            print "Not a valid bmrb Id"
            #os.system("rm %s"%(self.fname))
            
    def prinOutput(self):
        tree=ET.parse(self.fname)
        root=tree.getroot()
        for biter in root.findall('BlastOutput_iterations'):
            for iteration in biter.findall('Iteration'):
                iteration_query_def=iteration.find('Iteration_query-def').text
                for iteration_hits in iteration.findall('Iteration_hits'):
                    for hit in iteration_hits.findall('Hit'):
                        hit_num=hit.find('Hit_num').text
                        hit_id=hit.find('Hit_id').text
                        for hit_hsps in hit.findall('Hit_hsps'):
                            for hsp in hit_hsps.findall('Hsp'):
                                hsp_num= hsp.find('Hsp_num').text
                                hsp_bit_score=hsp.find('Hsp_bit-score').text
                                hsp_score=hsp.find('Hsp_score').text
                                hsp_evalue=hsp.find('Hsp_evalue').text
                                if 'pdb' in hit_id.split("|"):
                                    print hit_num,hit_id.split("|")[-2],hit_id.split("|")[-1],hsp_score,hsp_evalue,hsp_bit_score
                                    

        
if __name__=="__main__":
    p=BlastParser()
    p.getFile('4351')
    