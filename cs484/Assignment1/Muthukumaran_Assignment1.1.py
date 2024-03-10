#!/usr/bin/env python
# coding: utf-8

# In[52]:


import pandas as pd
import numpy as np
from collections import Counter

data = pd.read_csv(r"C:\Users\lenin\Downloads\lab01_dataset_1.csv")
ds = pd.DataFrame(data)

sorted_data = ds.sort_values(by='Score')
print("Data Sorted by Score:")
print(sorted_data)

def handle_continuous_attributes(dataset):
    dataset['score_46.0'] = dataset['Score'] < (44+48)/2
    dataset['score_69.5'] = dataset['Score'] < (69+70)/2
    dataset['score_81.5'] = dataset['Score'] < (80+83)/2
    
    dataset['output'] = dataset['Output'] 
    dataset = dataset.drop(columns=['Score'])
    dataset = dataset.drop(columns=['Output'])
    return dataset

updated_ds = handle_continuous_attributes(sorted_data)
print("\nData after handling continous numerical data:")
print(updated_ds)


# In[61]:


def check_missing_values(dataset):
    missing_values = dataset.isna().any().any()
    if missing_values == 0:
        print("a. The dataset has no missing values.")
    else:
        print(f"a. The dataset has {missing_values} missing values.")

def check_redundant_samples(dataset):
    dropped_data = dataset.duplicated()
    if dropped_data.any():
        print("\nb. The redundant input samples have been removed.")
    else:
        print("\nb. The dataset has no redundant input samples.")
    return dataset.drop_duplicates()
    
def check_contradicting_pairs(dataset):
    contradictions = dataset.groupby(dataset.columns.tolist()[:-1])['output'].nunique() > 1
    print("\nc. Contradictory <input, output> pairs:\n", contradictions)


check_missing_values(updated_ds)
final_ds = check_redundant_samples(updated_ds)
print(final_ds)
check_contradicting_pairs(updated_ds)


# In[73]:


def entropy(data):
    label_column = data.iloc[:, -1]
    _, counts = np.unique(label_column, return_counts=True)
    probabilities = counts / counts.sum()
    return -sum(probabilities * np.log2(probabilities))

def gain(data, attribute):
    total_entropy = entropy(data)
    
    values, counts = np.unique(data[attribute], return_counts=True)
    weighted_entropy = sum((counts[i] / counts.sum()) * entropy(data[data[attribute] == values[i]]) for i in range(len(values)))
    
    return total_entropy - weighted_entropy

def my_ID3(data, features, parent_node_class=None):
    if len(np.unique(data['output'])) == 1:
        return data['output'].iloc[0]

    if len(features) == 0:
        print(f"No more features to split on. Choosing majority class: {parent_node_class}")
        return parent_node_class

    information_gains = [gain(data, feature) for feature in features]
    best_attribute_index = np.argmax(information_gains)
    best_attribute = features[best_attribute_index]
    best_gain = information_gains[best_attribute_index]

    print(f"Attribute {best_attribute} with Gain = {best_gain} is chosen as the decision attribute.")

    sub_features = [feature for feature in features if feature != best_attribute]

    tree = {best_attribute: {}}

    for value in np.unique(data[best_attribute]):
        value_subset = data[data[best_attribute] == value]
        subtree = my_ID3(value_subset, sub_features, parent_node_class=Counter(data['output']).most_common(1)[0][0])
        tree[best_attribute][value] = subtree

    return tree

features = list(updated_ds.columns[:-1])

decision_tree = my_ID3(final_ds, features)

print("\nDecision Tree:")
print(decision_tree)

