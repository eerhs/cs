# Shree Ramachandran Muthukumaran
# A#20507651
# HW 6 

rm(list=ls())
library(arules)
library(arulesViz)

# --- Q2(b) ------------------------------------------------------------------

q_2_b_i <- function()  { 
   # TODO: Add your code here
   # TODO: Return a scalar
   transactions <- read.transactions("tr-20k-canonical.csv", format = "basket", sep = ",")
  
   # Count # of unique items
   num_unique_items <- length(itemLabels(transactions))
   return(num_unique_items)
}

q_2_b_ii <- function()  {
   # TODO: Add your code here
   # TODO: Return a named vector
   transactions <- read.transactions("tr-20k-canonical.csv", format = "basket", sep = ",")
   
   # Sort frequencies in descending order to get most frequent items
   item_freq <- itemFrequency(transactions, type = "absolute")
   sorted_freq <- sort(item_freq, decreasing = TRUE)
   most_frequent_items <- head(sorted_freq, 2)
   return(most_frequent_items)
}

q_2_b_iii <- function()  {
   # TODO: Add your code here
   # TODO: Return a named vector
   transactions <- read.transactions("tr-20k-canonical.csv", format = "basket", sep = ",")
   
   # Sort frequencies in ascending order to get least frequent items
   item_freq <- itemFrequency(transactions, type = "absolute")
   sorted_freq <- sort(item_freq, decreasing = FALSE)
   least_frequent_items <- head(sorted_freq, 2)
   return(least_frequent_items)
}

q_2_b_iv <- function()  {
   # TODO: Add your code here
   # TODO: Return an object of class itemset
   transactions <- read.transactions("tr-20k-canonical.csv", format = "basket", sep = ",")
   
   frequent_itemsets <- apriori(transactions, parameter = list(supp = 0.01, target = "frequent itemsets"))
   return(frequent_itemsets)
}

q_2_b_v <- function()  {
   # TODO: Add your code here
   # TODO: Return an object of class itemset
   transactions <- read.transactions("tr-20k-canonical.csv", format = "basket", sep = ",")

   frequent_itemsets <- apriori(transactions, parameter = list(supp = 0.10, target = "frequent itemsets"))
   return(frequent_itemsets)
}

q_2_b_vi <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}

q_2_b_vii <- function()  {
   # TODO: Add your code here
   # TODO: Return an object of class itemset
   transactions <- read.transactions("tr-20k-canonical.csv", format = "basket", sep = ",")

   frequent_itemsets <- apriori(transactions, parameter = list(supp = 0.001, target = "frequent itemsets"))
   return(frequent_itemsets)
}

# --- End of Q2(b) -----------------------------------------------------------
# --- Q2(c) ------------------------------------------------------------------

q_2_c_i <- function()  {
   # TODO: Add your code here
   # TODO: Return an object of class rules
   transactions <- read.transactions("tr-20k-canonical.csv", format = "basket", sep = ",")
   
   rules <- apriori(transactions, parameter = list(supp = 0.001, target = "rules"))
   return(rules)
}

q_2_c_ii <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}

q_2_c_iii <- function()  {
   # TODO: Add your code here
   # TODO: Return an object of class rules
   rules_result <- q_2_c_i()

   most_frequent_items <- c("Coffee Eclair", "Hot Coffee")
   filtered_rules <- subset(rules_result, items %in% most_frequent_items)
   
   percentage <- length(filtered_rules) / length(rules_result) * 100
   return(filtered_rules)
}

q_2_c_iv <- function()  {
   # TODO: Add your code here
   # TODO: Return an object of class rules
   rules_result <- q_2_c_i()
   
   least_frequent_items <- c("Almond Tart", "Blueberry Danish")
   filtered_rules <- subset(rules_result, items %in% least_frequent_items)
   
   percentage <- length(filtered_rules) / length(rules_result) * 100
   return(filtered_rules)
}