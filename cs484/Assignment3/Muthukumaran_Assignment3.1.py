#!/usr/bin/env python
# coding: utf-8

# In[24]:


import pandas as pd
import numpy as np
import seaborn as sb
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error

data = pd.read_csv(r"C:\Users\lenin\Downloads\lab03_dataset_1.csv")


# In[25]:


# 1.
plt.figure()
sb.heatmap(data.corr(), annot=True, cmap='coolwarm', fmt=".2f")
plt.title('Correlation Heatmap')
plt.show()


# In[26]:


# 2.
scaler = MinMaxScaler()
scaled_features = scaler.fit_transform(data.iloc[:, 0:-1])


# In[27]:


# 3.
X_train, X_test, y_train, y_test = train_test_split(scaled_features, data['Unemployment'], test_size=0.1)


# In[28]:


# 4.
model = LinearRegression()
model.fit(X_train, y_train)

print("Regression Score:", model.score(X_test, y_test))
print("Coefficients:", model.coef_)
print("Intercept:", model.intercept_)
print("Mean Squared Error:", mean_squared_error(y_test, model.predict(X_test)))


# In[29]:


# 5.
plt.figure()
plt.scatter(range(len(y_test)), model.predict(X_test), color='blue', label='Predictions')
plt.scatter(range(len(y_test)), y_test, color='red', label='True Output')
plt.title('True Output vs. Predicted Output')
plt.xlabel('Data Points')
plt.ylabel('Output')
plt.legend()
plt.show()