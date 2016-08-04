import lxml.etree as ET
import sys

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
for i in range(0,100):
    new_element = ET.fromstring(ET.tostring(rows[0]))
    table.append(new_element)
#rows.pop()
#rows.pop()

doc = ET.ElementTree(root)

outFile = open('sa_.xml', 'w')
doc.write(outFile, encoding='utf-8') 
outFile.close()
