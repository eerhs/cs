#!/usr/bin/env python
# coding: utf-8

# In[26]:


import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.neighbors import KDTree
from sklearn.metrics import accuracy_score

# Load the dataset
data = pd.read_csv(r"C:\Users\lenin\Downloads\lab03_dataset_2.csv")


# In[27]:


# 1. Feature scaling using Min-Max scaling
X = data.drop(columns=['FRAUD'])
Y = data['FRAUD']

scaler = MinMaxScaler()
X_scaled = scaler.fit_transform(X)

test_size = int(0.2 * len(data))
X_train, X_test = X_scaled[:-test_size], X_scaled[-test_size:]
Y_train, Y_test = Y[:-test_size], Y[-test_size:]


# In[28]:


# 2. K-Nearest Neighbors classification
for i in range(2, 6):
    knn = KNeighborsClassifier(n_neighbors=i, metric='euclidean')
    knn.fit(X_train, Y_train)
    predictions = knn.predict(X_test)
    misclassification_rate = 1 - accuracy_score(Y_test, predictions)
    print(f"K = {i}, Misclassification Rate = {misclassification_rate:.4f}")


# In[29]:


# 3. K-d Tree classification
for i in range(2, 6):
    kdtree = KDTree(X_train, leaf_size=30, metric='manhattan')
    distances, indices = kdtree.query(X_test, k=i)
    predictions = [1 if Y_train.iloc[idx].mean() > 0.5 else 0 for idx in indices]
    misclassification_rate = 1 - accuracy_score(Y_test, predictions)
    print(f"K = {i}, Misclassification Rate = {misclassification_rate:.4f}")