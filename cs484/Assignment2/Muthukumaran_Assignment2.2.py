# In[77]:


import pandas as pd
import numpy as np
from sklearn.metrics import accuracy_score
from sklearn.naive_bayes import CategoricalNB
import matplotlib.pyplot as plt

data = pd.read_excel(r"C:\Users\lenin\Downloads\lab02_dataset_2.xlsx")
data_cleaned = data.dropna(subset=['CAR_USE', 'CAR_TYPE', 'OCCUPATION', 'EDUCATION'])

data['CAR_USE'] = data['CAR_USE'].map({'Commercial': 0, 'Private': 1})
data['CAR_TYPE'] = data['CAR_TYPE'].astype('category').cat.codes
data['OCCUPATION'] = data['OCCUPATION'].astype('category').cat.codes
data['EDUCATION'] =data['EDUCATION'].astype('category').cat.codes

X = data[['CAR_TYPE', 'OCCUPATION', 'EDUCATION']]
Y = data['CAR_USE']


# In[78]:


X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2, random_state=42)

naiveBayes = CategoricalNB(alpha=0.01)
naiveBayes.fit(X_train, Y_train)

class_counts = data['CAR_USE'].value_counts()
class_probs = (class_counts / len(data))

print("Class counts:")
print("Commercial:", class_counts[0])
print("Private:", class_counts[1])
print("\nClass probabilities:")
print("P(Commercial):", class_probs[0])
print("P(Private):", class_probs[1])


# In[79]:


for column in X.columns:
    print("-------------------------------------------")
    print(column)
    for class_val in Y.unique():
        feature_counts = X[Y == class_val][column].value_counts()
        total_count = len(X[Y == class_val])
        probs = (feature_counts + 1) / (total_count + len(X[column].unique()))
        class_data = pd.DataFrame({
            'Class': [class_val] * len(feature_counts),
            'Feature': feature_counts.index,
            'Feature_count': feature_counts.values,
            'Probability': probs.values
        })
        print(class_data)


# In[80]:


person1 = {'CAR_TYPE': 'SUV', 'OCCUPATION': 'Blue Collar', 'EDUCATION': 'PhD'}
person2 = {'CAR_TYPE': 'Sports Car', 'OCCUPATION': 'Manager', 'EDUCATION': 'Below High Sc'}

person1['CAR_TYPE'] = df['CAR_TYPE'].astype('category').cat.codes[df['CAR_TYPE'] == person1['CAR_TYPE']].values[0]
person1['OCCUPATION'] = df['OCCUPATION'].astype('category').cat.codes[df['OCCUPATION'] == person1['OCCUPATION']].values[0]
person1['EDUCATION'] = df['EDUCATION'].astype('category').cat.codes[df['EDUCATION'] == person1['EDUCATION']].values[0]

person2['CAR_TYPE'] = df['CAR_TYPE'].astype('category').cat.codes[df['CAR_TYPE'] == person2['CAR_TYPE']].values[0]
person2['OCCUPATION'] = df['OCCUPATION'].astype('category').cat.codes[df['OCCUPATION'] == person2['OCCUPATION']].values[0]
person2['EDUCATION'] = df['EDUCATION'].astype('category').cat.codes[df['EDUCATION'] == person2['EDUCATION']].values[0]

person1_prob = naiveBayes.predict_proba([list(person1.values())])[0]
person2_prob = naiveBayes.predict_proba([list(person2.values())])[0]

print("Person 1 Car Usage Probabilities:")
print("Commercial:", person1_prob[0])
print("Private:", person1_prob[1])

print("\nPerson 2 Car Usage Probabilities:")
print("Commercial:", person2_prob[0])
print("Private:", person2_prob[1])


# In[81]:


pred_probs = naiveBayes.predict_proba(X)[:, 1]

bins = [i * 0.05 for i in range(int(max(pred_probs) / 0.05) + 2)]
plt.hist(pred_probs, bins=bins, color='pink')

plt.xlabel('Predicted Probability of CAR_USE = Private')
plt.ylabel('Proportion of Observations')
plt.title('Histogram of Predicted Probabilities of CAR_USE = Private')

plt.show()


# In[82]:


Y_pred = naiveBayes.predict(X_test)
misclassification_rate = 1 - accuracy_score(Y_test, Y_pred)

print("Misclassification rate:", misclassification_rate)

