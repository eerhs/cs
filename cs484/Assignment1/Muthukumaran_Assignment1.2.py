#!/usr/bin/env python
# coding: utf-8

# In[93]:


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn import tree
from sklearn import preprocessing
from sklearn.model_selection import train_test_split


data = pd.read_csv(r"C:\Users\lenin\Downloads\lab01_dataset_2.csv")

X = data[['Age','Sex','BP','Cholesterol','Na_to_K']].values
Y = data[['Output']].values

encoded_sex = preprocessing.LabelEncoder()
encoded_sex.fit(['F','M'])
X[:,1] = encoded_sex.transform(X[:,1])

encoded_BP = preprocessing.LabelEncoder()
encoded_BP.fit(['LOW','NORMAL','HIGH'])
X[:,2] = encoded_BP.transform(X[:,2])

encoded_Chol = preprocessing.LabelEncoder()
encoded_Chol.fit([ 'NORMAL', 'HIGH'])
X[:,3] = encoded_Chol.transform(X[:,3])


# In[94]:


X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.3, random_state=0)

dt = DecisionTreeClassifier(criterion="entropy", max_depth = 4)

dt.fit(X_train,Y_train)

predTree = dt.predict(X_test)
Y_test = np.concatenate(Y_test, axis=0)

predictions = pd.DataFrame({'Actual':Y_test, 'Predicted':predTree})
print("Prediction Results:\n", predictions)


# In[95]:


featureNames = data.columns.tolist()
featureNames.pop()
tree.plot_tree(dt, feature_names = featureNames, class_names = data["Output"].unique().tolist(), filled=True)

