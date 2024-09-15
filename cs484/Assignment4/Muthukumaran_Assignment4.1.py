#!/usr/bin/env python
# coding: utf-8

# In[2]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.cluster import SpectralClustering
from sklearn.cluster import DBSCAN
from sklearn.metrics import silhouette_score

data1 = pd.read_csv(r"C:\Users\lenin\Downloads\lab04_dataset_1.csv")


fig, axs = plt.subplots(2, 3, figsize=(15, 10))
axs = axs.ravel()

silhouette_scores = []

for i, k in enumerate(range(2, 7)):
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(data1)
    
    score = silhouette_score(data1, kmeans.labels_)
    silhouette_scores.append(score)
    
    axs[i].scatter(data1['x1'], data1['x2'], c=kmeans.labels_, cmap='viridis')
    axs[i].set_title(f'Clusters with K={k}')
    axs[i].set_xlabel('x1')
    axs[i].set_ylabel('x2')
    axs[i].legend()
    
    print(f"Silhouette score for K={k}: {score}")
    
plt.tight_layout()
plt.show()

plt.figure(figsize=(8, 5))
plt.plot(range(2, 7), silhouette_scores)
plt.title('Silhouette Score vs. Number of Clusters')
plt.xlabel('Number of Clusters (K)')
plt.ylabel('Silhouette Score')
plt.xticks(range(2, 7))
plt.grid(True)
plt.show()


# In[3]:


data2 = pd.read_csv(r"C:\Users\lenin\Downloads\lab04_dataset_2.csv")

fig, axs = plt.subplots(1, len(range(2, 5)), figsize=(15, 5))

for i, k in enumerate(range(2, 5)):
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(data2)
    
    axs[i].scatter(data2['x1'], data2['x2'], c=kmeans.labels_, cmap='viridis')
    axs[i].set_title(f'Clusters with K={k}')
    axs[i].set_xlabel('x1')
    axs[i].set_ylabel('x2')
    axs[i].legend()

plt.tight_layout()
plt.show()


# In[5]:


fig, axs = plt.subplots(1, len(range(2, 5)), figsize=(15, 5))

for i, k in enumerate(range(2, 5)):
    spectral_clustering = SpectralClustering(n_clusters=k, random_state=42)
    labels = spectral_clustering.fit_predict(data2)
    
    axs[i].scatter(data2['x1'], data2['x2'], c=labels, cmap='viridis')
    axs[i].set_title(f'Clusters with K={k}')
    axs[i].set_xlabel('x1')
    axs[i].set_ylabel('x2')

plt.tight_layout()
plt.show()


# In[6]:


dbscan = DBSCAN(eps=1, min_samples=1)
labels = dbscan.fit_predict(data2)


plt.figure(figsize=(8, 6))
plt.scatter(data2['x1'], data2['x2'], c=labels, cmap='viridis')
plt.title('DBSCAN Clustering')
plt.xlabel('x1')
plt.ylabel('x2')
plt.show()


# In[ ]:




