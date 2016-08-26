'''
Created on Aug 26, 2016

@author: kumaran
'''

import time,requests


class Metabolic_mixture(object):
    api_url="http://webapi.bmrb.wisc.edu/current/jsonrpc"
    
    def __init__(self):
        '''
        '''
        
    
    def get_peaklist(self,met_id):
        self.met_id=met_id
        self.loop_keys=["_Peak_general_char","_Assigned_peak_chem_shift"]
        self.tag_keys=["_Spectral_peak_list.ID","_Spectral_peak_list.Experiment_name"]
        loop_request = {
                        "method":"loop",
                        "jsonrpc":"2.0",
                        "params":{ "ids":self.met_id,
                                  #"database":"metabolomics",
                                  #"ids":[15000, 16000],
                                  "keys":self.loop_keys
                                  },
                        "id":1
                        }
        tag_request = {
                        "method":"tag",
                        "jsonrpc":"2.0",
                        "params":{ "ids":self.met_id,
                                  #"database":"metabolomics",
                                  #"ids":[15000, 16000],
                                  "keys":self.tag_keys
                                  },
                        "id":2
                        }
        self.loop_res = requests.post(self.api_url,json=loop_request)
        self.tag_res = requests.post(self.api_url,json=tag_request)
        self.loop_data=self.loop_res.json()
        self.tag_data=self.tag_res.json()
        self.get_1d1h_id()
        self.get_peak_list()
      
    def get_peak_list(self):
        self.peak_list=[]
        for met_id in self.met_id:
            pk=[]
            try:
                print self.loop_data['result'][met_id][self.loop_keys[1]][0]['tags']
            except KeyError:
                print "_Spectral_peak_list is missing in ",met_id
                pk=[]
            
          
    def get_1d1h_id(self):
        self.ID_1h1d=[]
        for met_id in self.met_id:
            try:
                exp_list=self.tag_data['result'][met_id]
                try:
                    exp_id=exp_list[self.tag_keys[0]][exp_list[self.tag_keys[1]].index('1D 1H')]
                except ValueError:
                    #print "1D 1H experiment is missing in",met_id
                    exp_id=-1
                
            except KeyError:
                #print "_Spectral_peak_list is missing in ",met_id
                exp_id=-1
            self.ID_1h1d.append(exp_id)
        return self.ID_1h1d
        
                


if __name__ == '__main__':
    p=Metabolic_mixture()
    p.get_peaklist(['bmse000576','bmse010032','bmse000577'])