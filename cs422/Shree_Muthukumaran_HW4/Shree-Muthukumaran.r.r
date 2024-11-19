# Shree Ramachandran Muthukumaran
# A#20507651
# HW 4

# DO NOT CHANGE THE NAMES OF THE FUNCTIONS.
# The plot title and x- and y-axis labels MUST BE LOWER CASED.

library(rpart)
library(rpart.plot)
library(caret)
library(ISLR)
library(ggplot2)

rm(list=ls())
data("Auto")

set.seed(1121)  # DO NOT REMOVE THIS LINE

q_2_1_a <- function()  {
   # TODO: Add your code here
   # TODO: DO NOT USE ABSOLUTE PATH TO READ YOUR CSV FILE IN!!
   # TODO: Return a string
   df <- read.csv("HR-Employee-Attrition.csv")
   
   yes_count <- sum(df$Attrition == "Yes")
   no_count <- sum(df$Attrition == "No")
   
   return(paste0("yes=", yes_count, ",no=", no_count))
}

# TODO: Divide the data into train and test sets as shown in the homework 
# description.  Keep in mind that the train and test datasets will be 
# global variables if you do the division here.  Alternatively, you can
# do the division of train and test in the appropriate function, in which
# case, the train and test sets will be local variables.  Which strategy
# to use is up to you.

q_2_1_b_i <- function()  {
   # TODO: Add your code here
   # TODO: Return a confusion matrix object
   df <- read.csv("HR-Employee-Attrition.csv")
   
   set.seed(1121)
   
   df$Attrition <- as.factor(df$Attrition)
   trainIndex <- createDataPartition(df$Attrition, p = 0.8, list = FALSE)
   trainData <- df[trainIndex, ]
   testData <- df[-trainIndex, ]
   
   tree_model <- rpart(Attrition ~ ., data = trainData, method = "class")
   
   predictions <- predict(tree_model, testData, type = "class")
   
   cm <- confusionMatrix(predictions, testData$Attrition, positive = "Yes")
   return(cm)
}

q_2_1_b_ii <- function()  {
   file_name <- "hw4-plot/plot-20507651-2-1-b-ii.png"
   png(file_name)
   # TODO: Add your code to plot here
   df <- read.csv("HR-Employee-Attrition.csv")
   set.seed(1121)

   df$Attrition <- as.factor(df$Attrition)
   trainIndex <- createDataPartition(df$Attrition, p = 0.8, list = FALSE)
   trainData <- df[trainIndex, ]
   tree_model <- rpart(Attrition ~ ., data = trainData, method = "class")
   
   rpart.plot(tree_model, extra=104, fallen.leaves = TRUE, type=4, main="hr employee attrition tree")
   
   dev.off()
   return(file_name)
}

q_2_1_b_iii <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE THIS FUNCTION.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}

q_2_1_b_iv <- function()  {
   file_name <- "hw4-plot/plot-20507651-2-1-b-iv.png"
   png(file_name)
   # TODO: Add your code to plot here
   
   df <- read.csv("HR-Employee-Attrition.csv")
   set.seed(1121)
   
   df$Attrition <- as.factor(df$Attrition)
   trainIndex <- createDataPartition(df$Attrition, p = 0.8, list = FALSE)
   trainData <- df[trainIndex, ]
   testData <- df[-trainIndex, ]
   
   # Predict probabilities on the test set
   tree_model <- rpart(Attrition ~ ., data = trainData, method = "class")
   prob_predictions <- predict(tree_model, testData, type = "prob")[, "Yes"]
   
   # Plot ROC curve
   roc_curve <- roc(testData$Attrition, prob_predictions, levels = c("No", "Yes"))
   plot(roc_curve, main="ROC Curve for Attrition") 
   
   dev.off()
   # TODO: Add your code to get AUC
   # Return a list with two elements as described in the homework instructions
   
   # Calculate AUC
   auc_value <- auc(roc_curve)
   return(list(file_name, round(auc_value, 2)))
}

q_2_1_b_v <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE THIS FUNCTION.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}

# Q2.2 ---------------

q_2_2_a <- function()  {
   # TODO: Add your code here
   # TODO: Return a data frame object
   df <- read.csv("HR-Employee-Attrition.csv")
   set.seed(1121)
   
   # Extract all "Yes" instances
   yes_df <- df[df$Attrition == "Yes", ]
   
   # Randomly sample 250 "No" instances
   no_df <- df[df$Attrition == "No", ]
   no_sample <- no_df[sample(1:nrow(no_df), 250), ]
   
   # Combine them into balanced.df
   balanced_df <- rbind(yes_df, no_sample)
   
   # Shuffle the rows of balanced.df
   balanced_df <- balanced_df[sample(1:nrow(balanced_df)), ]
   return(balanced_df)
}

q_2_2_b <- function()  {
   # TODO: Add your code here
   # TODO: Return a confusion matrix object
   # Get the balanced data
   balanced_df <- q_2_2_a()
   
   # Train-test split (80% training, 20% testing)
   set.seed(1121)
   balanced_df$Attrition <- as.factor(balanced_df$Attrition)
   trainIndex <- createDataPartition(balanced_df$Attrition, p = 0.8, list = FALSE)
   balanced_train_df <- balanced_df[trainIndex, ]
   balanced_test_df <- balanced_df[-trainIndex, ]
   
   # Train the decision tree
   tree_model <- rpart(Attrition ~ ., data = balanced_train_df, method = "class")
   
   # Predict on test set
   predictions <- predict(tree_model, balanced_test_df, type = "class")
   
   # Create confusion matrix with 'Yes' as the positive class
   cm <- confusionMatrix(predictions, balanced_test_df$Attrition, positive = "Yes")
   return(cm)
}

q_2_2_b_i <- function()  {
   file_name <- "hw4-plot/plot-20507651-2-2-b-i.png"
   png(file_name)
   # TODO: Add your code to plot here
      
   # Use the balanced dataset and split it again
   balanced_df <- q_2_2_a()
   set.seed(1121)
   balanced_df$Attrition <- as.factor(balanced_df$Attrition)
   trainIndex <- createDataPartition(balanced_df$Attrition, p = 0.8, list = FALSE)
   balanced_train_df <- balanced_df[trainIndex, ]
   balanced_test_df <- balanced_df[-trainIndex, ]
   
   # Train the decision tree
   tree_model <- rpart(Attrition ~ ., data = balanced_train_df, method = "class")
   
   # Predict probabilities on the test set
   prob_predictions <- predict(tree_model, balanced_test_df, type = "prob")[, "Yes"]
   
   # Plot ROC curve
   roc_curve <- roc(balanced_test_df$Attrition, prob_predictions, levels = c("No", "Yes"))
   plot(roc_curve, main="ROC Curve for Balanced Attrition Data")
   
   dev.off()
   # TODO: Add your code to get AUC
   # Return a list with two elements as described in the homework instructions
   
   # Calculate AUC
   auc_value <- auc(roc_curve)
   return(list(file_name, round(auc_value, 2)))
}

q_2_2_b_ii <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE THIS FUNCTION.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}

# Q2.3 -------------------------

q_2_3_a <- function()  {
   # TODO: Add your code here
   # TODO: Return a floating point numeric type rounded up to two decimal digits
  
   balanced_df <- q_2_2_a()
   
   # Train-test split (80% training, 20% testing)
   set.seed(1121)
   balanced_df$Attrition <- as.factor(balanced_df$Attrition)
   trainIndex <- createDataPartition(balanced_df$Attrition, p = 0.8, list = FALSE)
   balanced_train_df <- balanced_df[trainIndex, ]
   
   # Train the decision tree
   tree_model <- rpart(Attrition ~ ., data = balanced_train_df, method = "class")
   
   # Get complexity table
   cp_table <- tree_model$cptable
   
   # Choose the CP value to prune at (usually the one with the minimum xerror)
   optimal_cp <- cp_table[which.min(cp_table[, "xerror"]), "CP"]
   
   # Prune the tree
   pruned_tree <- prune(tree_model, cp = optimal_cp)

   return(round(optimal_cp, 2))
}

q_2_3_b <- function()  {
   # TODO: Add your code here
   # TODO: Return a confusion matrix object
   
   balanced_df <- q_2_2_a()
   
   # Train-test split (80% training, 20% testing)
   set.seed(1121)
   balanced_df$Attrition <- as.factor(balanced_df$Attrition)
   trainIndex <- createDataPartition(balanced_df$Attrition, p = 0.8, list = FALSE)
   balanced_train_df <- balanced_df[trainIndex, ]
   balanced_test_df <- balanced_df[-trainIndex, ]
   
   # Train the decision tree
   tree_model <- rpart(Attrition ~ ., data = balanced_train_df, method = "class")
   
   # Get optimal CP value and prune the tree
   cp_table <- tree_model$cptable
   optimal_cp <- cp_table[which.min(cp_table[, "xerror"]), "CP"]
   pruned_tree <- prune(tree_model, cp = optimal_cp)
   
   # Predict on test set
   predictions <- predict(pruned_tree, balanced_test_df, type = "class")
   
   # Create confusion matrix with 'Yes' as the positive class
   cm <- confusionMatrix(predictions, balanced_test_df$Attrition, positive = "Yes")
   return(cm)
}

q_2_3_c <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE THIS FUNCTION.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}