# Shree Ramachandran Muthukumaran
# A#20507651
# HW 5 

# DO NOT CHANGE THE NAMES OF THE FUNCTIONS.
# The plot title and x- and y-axis labels MUST BE LOWER CASED.
library(rpart)
library(caret)
library(keras)
rm(list=ls())

set.seed(1122)  # DO NOT REMOVE THIS LINE

# TODO: Divide the data into train and test sets as shown in the homework 
# description.  Keep in mind that the train and test datasets will be 
# global variables if you do the division here.  Alternatively, you can
# do the division of train and test in the appropriate function, in which
# case, the train and test sets will be local variables.  Which strategy
# to use is up to you.

data <- read.csv("wifi_localization.csv")
train_index <- createDataPartition(data$room, p = 0.8, list = FALSE)
train <- data[train_index, ]
test <- data[-train_index, ]

# Predictors and response variables for the neural network
x_train <- as.matrix(train[, -8])
y_train <- to_categorical(train$room - 1)
x_test <- as.matrix(test[, -8])
y_test <- to_categorical(test$room - 1)

q_2_a <- function()  {
   # TODO: Add your code here
   # TODO: DO NOT USE ABSOLUTE PATH TO READ YOUR CSV FILE IN!!
   # TODO: Return a confusion matrix object
   
   train$room <- factor(train$room)
   test$room <- factor(test$room)

   model <- rpart(room ~ ., data = train, method = "class")
   predictions <- predict(model, test, type = "class")

   confusion_matrix <- confusionMatrix(predictions, test$room)
   print(confusion_matrix)
}

q_2_b_i <- function()  {
   # TODO: Add your code here
   # TODO: Return a neural network model object

   model <- keras_model_sequential() %>%
     layer_dense(units = 1, activation = 'relu', input_shape = ncol(x_train)) %>%
     layer_dense(units = 4, activation = 'softmax')  # Output layer for 4 classes

   # Compile the model
   model %>% compile(
     loss = 'categorical_crossentropy',
     optimizer = 'adam',
     metrics = c('accuracy')
   )

   # Train the model
   model %>% fit(
     x_train, y_train,
     epochs = 100,
     batch_size = 32,
     validation_split = 0.20
   )
   return(model)
}

q_2_b_ii <- function()  {
   # TODO: Add your code to plot here
   # TODO: Return a confusion matrix object
   model <- q_2_b_i()

   # Predict on the test set
   predictions <- model %>% predict(x_test)
   predicted_classes <- predictions %>% k_argmax(axis = -1)

   actual <- as.numeric(test$room) - 1
   predicted_classes <- as.integer(predicted_classes)

   confusion_matrix <- confusionMatrix(factor(predicted_classes), factor(actual))
   return(confusion_matrix)
}

q_2_b_iii <- function() {
   # TODO: Add your code here
   # TODO: Return a vector as explained in the homework instructions
   model <- q_2_b_i()

   # Evaluate the model on the test set
   results <- model %>% evaluate(x_test, y_test)
   loss <- round(results[1], 2)
   accuracy <- round(results[2], 2)

   # Return loss and accuracy as a vector
   return(c(loss, accuracy))
}

q_2_b_iv <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE THIS FUNCTION.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}

q_2_b_v <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE THIS FUNCTION.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}

q_2_b_vi <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE THIS FUNCTION.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}

q_2_c_i <- function()  {
   # TODO: Add your code here
   # TODO: Return a neural network model object

   model <- keras_model_sequential() %>%
    layer_dense(units = 16, activation = 'relu', input_shape = ncol(x_train)) %>%  # Hidden layer with 16 neurons
    layer_dense(units = 4, activation = 'softmax')  # Output layer for 4 classes

   # Compile the model
   model %>% compile(
    loss = 'categorical_crossentropy',
    optimizer = 'adam',
    metrics = c('accuracy')
   )

   # Train the model
   model %>% fit(
    x_train, y_train,
    epochs = 100,
    batch_size = 32,
    validation_split = 0.20
   )

   return(model)
}

q_2_c_ii <- function()  {
   # TODO: Add your code here
   # TODO: Return a confusion matrix object
   model <- q_2_c_i()

   predictions <- model %>% predict(x_test)
   predicted_classes <- predictions %>% k_argmax(axis = -1)

   actual <- as.numeric(test$room) - 1
   predicted_classes <- as.integer(predicted_classes)

   confusion_matrix <- confusionMatrix(factor(predicted_classes), factor(actual))
   return(confusion_matrix)
}

q_2_c_iii <- function() {
   # TODO: Add your code here
   # TODO: Return a vector as explained in the homework instructions
   model <- q_2_c_i()

   # Evaluate the model on the test set
   results <- model %>% evaluate(x_test, y_test)
   loss <- round(results[1], 2)
   accuracy <- round(results[2], 2)

   return(c(loss, accuracy))
}

q_2_c_iv <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE THIS FUNCTION.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}

q_2_c_v <- function()  {
   # TODO: Add your code here
   # TODO: Return a numeric value
   model <- q_2_c_i()
   
   history <- model$history$history  
   val_accuracy <- history$val_accuracy
   
   # Find the epoch where the validation accuracy is highest (early stopping point)
   epoch_to_stop <- which.max(val_accuracy)
   
   return(epoch_to_stop)
}
q_2_c_vi <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE THIS FUNCTION.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}