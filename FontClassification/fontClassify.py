import os
from sklearn import metrics
from sklearn.cluster import KMeans
import numpy as np

path = 'sa\\'

#list all the txt files in the folder

data = []
fileNames = []

for file in os.listdir(path):
    if file.endswith(".txt"):
        text_file = open(path+file,'r')
        
        ar = (text_file.readline().split(' '))
        ar.remove('\n')
        if(len(ar)>0):
            #print map(int,ar)
            row = map(int,ar);
            data.append(row)
            fileNames.append(file)
        #print(row)

#create np array

npData = np.array(data)
n_samples, n_features = npData.shape
n_digits = 10
kmeans = KMeans(init='random', n_clusters=n_digits, n_init=10)
kmeans.fit(npData)
list1 = kmeans.labels_
list2 = fileNames
print kmeans.labels_
print fileNames

list1, list2 = zip(*sorted(zip(list1, list2)))

print list1
print list2

k=0
lim = len(list1)-1
for i in range(0,n_digits):
    
    while(list1[k]==i):
        print list1[k],list2[k]
        k+=1
        if k==lim:
            break
