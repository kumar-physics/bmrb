import urllib,re
from BeautifulSoup import BeautifulSoup
from string import atoi

def statistics():
    dat=urllib.urlopen('http://www.bmrb.wisc.edu/search/query_grid/initial_grid.html').read()
    #dat2=dat.replace("\n", "")
    x=list(BeautifulSoup(dat).findAll('b'))
    y=['Title']
    for i in x:
        x2="%s"%(i)
        y.append(" ".join(x2.split("\r\n")))
    for i in range(len(y)):
        if not (i-1)%4: c="Proteins"
        if not (i-2)%4: c="DNA"
        if not (i-3)%4 :c="RNA"
        if not i%4:
            tt=y[i].replace("<b>","").replace("</b>","").replace("<br />","")
        else:
            if i>4:
                t2=re.findall(r'(\d*)\s*(\(\d*\))',y[i].replace("<b>","").replace("</b>","").replace("<br />",""))
                if len(t2):
                    t=t2[0]
                else:
                    t=[]
                if len(t):
                    if t[0]:
                        s=atoi(t[0])
                    else:
                        s=0
                    if t[1]:
                        e=atoi(t[1].replace("(","").replace(")",""))
                else:
                    s=0
                    e=0
                print "%s,Entries,%s,%d"%(tt,c,e)
                print "%s,Values,%s,%d"%(tt,c,s)
if __name__=="__main__":
    statistics()
