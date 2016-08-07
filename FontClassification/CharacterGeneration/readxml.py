import lxml.etree as ET
import sys
from math import ceil
import os

#list fonts directory

fontfile = 'text-2.txt'

'''
fontCollection = []
for file in os.listdir("../sinhalaFontList"):
    if file.endswith(".TTF") or file.endswith(".ttf"):
        fontCollection.append(file.lower().replace('.ttf','\n'))
print fontCollection

fd = open(fontfile,'w')
fd.writelines(fontCollection)
fd.close()
'''

#read fonts file

fd = open(fontfile,'r')
fonts = fd.readlines()
for i in range(0,len(fonts)):
    fonts[i]= fonts[i].strip('\n')


tree = ET.parse('sa.xml')
root = tree.getroot()
pkg = '{http://schemas.microsoft.com/office/2006/xmlPackage}'
w='{http://schemas.openxmlformats.org/wordprocessingml/2006/main}'

for part in root:
    print part.attrib[pkg+'name']
    if part.attrib[pkg+'name']=='/word/document.xml':
        data = part


data = data[0][0][0]

table = data.find(w+'tbl')
rows = table.findall(w+'tr')

#no of rows
#-1 because we already have a row
noOfRows = int(ceil(len(fonts)/3.0)) - 1

for i in range(0,noOfRows):
    new_element = ET.fromstring(ET.tostring(rows[0]))
    table.append(new_element)
#rows.pop()
#rows.pop()

rows = table.findall(w+'tr')

fontindex = 0

for r in range(0,len(rows)):
    
    row = rows[r]
    cols = row.findall(w+'tc')
    for c in range(0,len(cols)):
        if(fontindex>=len(fonts)):
            break
        newfont = fonts[fontindex]
        col = cols[c]
        wp = col.find(w+'p').getchildren()
        print wp
        #inside there is two fond declarations, I should change both
        for i in range(0,len(wp)):
            tab = wp[i]
            try:
                oldfont = tab.find(w+'rPr').find(w+'rFonts')
                for key in oldfont.keys():
                    print oldfont.attrib[key]
                    print newfont
                    oldfont.attrib[key] = newfont
                        
            except:
                print tab,' Does not have font field'
        fontindex+=1


doc = ET.ElementTree(root)

outFile = open('sa_.xml', 'w')
doc.write(outFile, encoding='utf-8') 
outFile.close()





