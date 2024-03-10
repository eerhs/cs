# In[54]:


import numpy as np
import pandas as pd

data = pd.read_csv(r"C:\Users\lenin\Downloads\lab02_dataset_1.csv")

X = data.iloc[:, :-1].values
y = np.where(data.iloc[:, -1].values == 'Positive', 1, -1)

def my_perceptron(X, y, threshold=0.01):
    weights = np.zeros(X.shape[1])
    converged = False
    
    while not converged:
        misclassified = 0
        for i in range(X.shape[0]):
            prediction = predict(X[i], weights)
            if prediction != y[i]:
                misclassified += 1
                weights += y[i] * X[i]
        misclassification_rate = misclassified / len(y)
        if misclassification_rate < threshold:
            converged = True
    return weights

weights = my_perceptron(X, y)
print("Weights:", weights)


# In[58]:


import matplotlib.pyplot as plt

def build3DPlot(data):
    plot3D = plt.figure()
    figure = plot3D.add_subplot(111, projection='3d')

    figure.scatter(
        data.loc[data['Class'] == 'Positive', 'X'],
        data.loc[data['Class'] == 'Positive', 'Y'],
        data.loc[data['Class'] == 'Positive', 'Z'],
        color='blue', 
        label='Positive'
    )
    figure.scatter(
        data.loc[data['Class'] == 'Negative', 'X'],
        data.loc[data['Class'] == 'Negative', 'Y'],
        data.loc[data['Class'] == 'Negative', 'Z'],
        color='red', 
        label='Negative'
    )

    x_axis, y_axis = np.meshgrid(range(-5, 5), range(-5, 5))
    z_axis = (-weights[0]* x_axis - weights[1] * y_axis) / weights[2]
    figure.plot_surface(x_axis, y_axis, z_axis, color='green', alpha=0.5, label='Linear Seperator')

    plt.legend()
    plt.show()

build3DPlot(data)