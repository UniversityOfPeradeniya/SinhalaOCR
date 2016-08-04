import xmltodict

with open('charPDFs\\Character1.xml') as fd:
    doc = xmltodict.parse(fd.read())

#list of parts in word document
parts = doc['pkg:package']['pkg:part']

#parts is a list I can iterate
#and select data part
for i in parts:
    #print i.keys()
    #print i['@pkg:name']
    if(i['@pkg:name'] == '/word/document.xml'):
        data = i

#now select document

document = data['pkg:xmlData']['w:document']['w:body']
table = document['w:tbl']
trs = table['w:tr']

for tr in trs:
    tcs = tr['w:tc']
    for tc in tcs:
        cell = tc['w:p']['w:r']
        #print cell['w:rPr']['w:rFonts'].keys()
        font = cell['w:rPr']['w:rFonts']['@w:ascii']
        data = cell['w:t']
        print font
        print data
    
