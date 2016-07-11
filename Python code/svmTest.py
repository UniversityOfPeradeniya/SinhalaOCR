import numpy as np
import random
from time import time


##x_init = np.loadtxt('')
##y_init = np.loadtxt('results.txt')
NumberOfFeatures = 8
X = [];
Y = [];
text_file = open('distanceArrays.txt','r')
lines = text_file.read().split('\n')
for line in lines:
    if(len(line)>NumberOfFeatures):
        tmp = line.split(' ');
        features = tmp[0:NumberOfFeatures]
        #print features
        tmpFeatures = map(float, features)
        X.append(tmpFeatures)
        Y.append(tmp[-1])
print(len(X))
print(len(Y))

## deviding train and test dataset      
##combined = zip(X, Y)
##random.shuffle(combined)
##
##X[:], Y[:] = zip(*combined)

## converting to numpy
np_X = np.array(X)
np_Y = np.array(Y)

from sklearn.cross_validation import train_test_split
data_train, data_test, labels_train, labels_test = train_test_split(np_X, np_Y, test_size=0.2, random_state=42)



#SVM
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score,confusion_matrix

t0 = time()

clf = SVC(C=1,kernel='rbf')
clf.fit(data_train, labels_train)
predicted = clf.predict(data_test)
print accuracy_score(labels_test, predicted)
print(time()-t0)

#print cross table
import pandas as pd
y_true = pd.Series(labels_test)
y_pred = pd.Series(predicted)

print pd.crosstab(y_true, y_pred, rownames=['True'], colnames=['Predicted'], margins=True)



#naive bayes
from sklearn.naive_bayes import GaussianNB


t0 = time()
clf = GaussianNB()
clf.fit(data_train, labels_train)
GaussianNB()
predicted = clf.predict(data_test)
print accuracy_score(labels_test, predicted)
print(time()-t0)

#print cross table
y_true = pd.Series(labels_test)
y_pred = pd.Series(predicted)

print pd.crosstab(y_true, y_pred, rownames=['True'], colnames=['Predicted'], margins=True)

