#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import accuracy_score
from sklearn.preprocessing import StandardScaler
from sklearn.neural_network import MLPRegressor
from sklearn.metrics import mean_squared_error
from math import sqrt
import seaborn as sns
import matplotlib.pylab as plt

data3 = pd.read_csv(r"C:\Users\lenin\Downloads\lab04_dataset_3.csv")


X = data3[['alcohol', 'citric_acid', 'free_sulfur_dioxide', 'residual_sugar', 'sulphates']]
y = data3['quality_grp']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

activation_functions = ['logistic', 'relu', 'tanh']
hidden_layers = [1, 2, 3, 4, 5]
neurons_per_layer = [2, 4, 6, 8]
results = []

for activations in activation_functions:
    for layers in hidden_layers:
        for neurons in neurons_per_layer:
            mlp = MLPClassifier(hidden_layer_sizes=tuple(neurons for _ in range(layers)),
                                activation=activations,
                                max_iter=10000,
                                random_state=2023484)
            mlp.fit(X_train, y_train)
            y_pred = mlp.predict(X_test)
            misclassification_rate = 1 - accuracy_score(y_test, y_pred)
            
            result = {
                'Activation function': activations,
                'Hidden layers': layers,
                'Neurons per layer': neurons,
                'Misclassification Rate': misclassification_rate
            }
            results.append(result)

results_df = pd.DataFrame(results)

print(results_df)


# In[2]:


plt.figure(figsize=(10, 6))
sns.scatterplot(data=results_df, x=range(len(results_df)), y='Misclassification Rate', hue='Activation function', palette='Set1', s=100)
plt.title('Misclassification Rate Graph')
plt.xlabel('Index')
plt.ylabel('Misclassification Rate')
plt.legend(title='Activation function')
plt.show()


# In[3]:


sorted_results = results_df.sort_values(by='Misclassification Rate')
best_model_params = sorted_results.iloc[0]

print("Best neural network parameters:")
print("Activation function:", best_model_params['Activation function'])
print("Hidden layers:", best_model_params['Hidden layers'])
print("Neurons per layer:", best_model_params['Neurons per layer'])
print("Misclassification Rate:", best_model_params['Misclassification Rate'])


# In[7]:


data4 = pd.read_csv(r"C:\Users\lenin\Downloads\lab04_dataset_4.csv")

X = data4[['housing_median_age', 'total_rooms', 'households', 'median_income']]
y = data4['median_house_value']

scaler = StandardScaler()
X_normalized = scaler.fit_transform(X)
y_normalized = scaler.fit_transform(y.values.reshape(-1, 1)).flatten()

X_train, X_test, y_train, y_test = train_test_split(X_normalized, y_normalized, test_size=0.2, random_state=42)

activation_functions = ['relu', 'tanh']
hidden_layers = [2, 3, 4]
neurons_per_layer = [4, 6, 8]

results_regression = []

for activation_func in activation_functions:
    for num_layers in hidden_layers:
        for num_neurons in neurons_per_layer:
            mlp_regressor = MLPRegressor(hidden_layer_sizes=tuple(num_neurons for _ in range(num_layers)),
                                         activation=activation_func,
                                         random_state=2023484)
            mlp_regressor.fit(X_train, y_train)
            y_pred = mlp_regressor.predict(X_test)
            
            rmse = sqrt(mean_squared_error(y_test, y_pred))
            
            result = {
                'Activation function': activation_func,
                'Hidden layers': num_layers,
                'Neurons per layer': num_neurons,
                'RMSE': rmse
            }
            results_regression.append(result)

results_df_regression = pd.DataFrame(results_regression)

print(results_df_regression)


# In[8]:


plt.figure(figsize=(10, 6))
sns.scatterplot(data=results_df_regression, x=range(len(results_df_regression)), y='RMSE', hue='Activation function', palette='Set1', s=100)
plt.title('Root Mean Square Error Graph')
plt.xlabel('Index')
plt.ylabel('Root Mean Square Error')
plt.legend(title='Activation function')
plt.show()


# In[9]:


sorted_results_regression = results_df_regression.sort_values(by='RMSE')
best_model_params_regression = sorted_results_regression.iloc[0]

print("Best neural network parameters for regression:")
print("Activation function:", best_model_params_regression['Activation function'])
print("Hidden layers:", best_model_params_regression['Hidden layers'])
print("Neurons per layer:", best_model_params_regression['Neurons per layer'])
print("Root Mean Square Error (RMSE):", best_model_params_regression['RMSE'])


# In[ ]:




