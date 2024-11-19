# Shree Ramachandran Muthukumaran
# A#2050761
# HW 3 

# DO NOT CHANGE THE NAMES OF THE FUNCTIONS.
# The plot title and x- and y-axis labels MUST BE LOWER CASED.

rm(list=ls())
library(ISLR)
library('dplyr')
data("Auto")

set.seed(1122)  # DO NOT REMOVE THIS LINE
index <- sample(1:nrow(Auto), 0.95*dim(Auto)[1])
train.df <- Auto[index, ]           # Training set
test.df <- Auto[-index, ]           # Test set
# TODO: Divide the data into train and test sets as shown in the homework 
# description.  Keep in mind that the train and test datasets will be 
# global variables if you do the division here.  Alternatively, you can
# do the division of train and test in the appropriate function, in which
# case, the train and test sets will be local variables.  Which strategy
# to use is up to you.

q_2_a_i <- function()  {  # Model 1
   # TODO: Add your code here
   # TODO: Return a model object.  You do not need to round up anything here.
   model <- lm(mpg ~ . -name, data = train.df)
   return(model)
}

q_2_a_ii <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}

q_2_a_iii <- function()  {
   # TODO Add your code here
   # TODO Return a string
   model <- q_2_a_i()  # Use the function from earlier to get the model

   # Get summary details
   model_summary <- summary(model)
   
   # Extract R-squared and adjusted R-squared
   r_sq <- model_summary$r.squared
   adjusted_r_sq <- model_summary$adj.r.squared
   
   # Calculate RSE
   rse <- model_summary$sigma
   
   # Calculate RMSE
   residuals <- model$residuals
   rmse <- sqrt(mean(residuals^2))
   
   # Return the formatted string
   return(sprintf("r-sq=%.2f,adjusted-r-sq=%.2f,rse=%.2f,rmse=%.2f", r_sq, adjusted_r_sq, rse, rmse))
}

q_2_a_iv <- function()  {  # Residuals for Model 1
   file_name <- "hw3-plot/plot-20507651-2-a-iv.png"  # TODO: Replace ID with your
                                               # student ID number WITHOUT
                                               # the 'A' prefix.
   png(file_name)
   # TODO: Add your code to plot here
   model <- q_2_a_i()
   residuals <- model$residuals

   plot(residuals,
        main = "Residuals vs Fitted",
        xlab = "Fitted Values",
        ylab = "Residuals")
   dev.off()
   # TODO: Return the name of your plot file
   return(file_name)
}


q_2_a_v <- function() {  # Histogram for Model 1
   file_name <- "hw3-plot/plot-20507651-2-a-v.png"   # TODO: Replace ID with your
                                               # student ID number WITHOUT
                                               # the 'A' prefix.
   png(file_name)
   # TODO: Add your code to plot here
   model <- q_2_a_i()
   residuals <- model$residuals

   hist(residuals, 
        main = "residual histogram (model 1)",
        xlab = "residuals")
   dev.off()
   # TODO: Return the name of your plot file
   return(file_name)
}

q_2_a_vi <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE THIS FUNCTION.
   # The answer for this will go into your PDF as explained in the homework instructions.
}

# Q 2b -------------

q_2_b_i <- function()  {  # Model 2
   # TODO: Add your code here
   # TODO: Return a model object.  You do not need to round up anything here.
   model_a <- q_2_a_i()
   
   # Identify top three statistically significant predictors by p-value
   summary_model <- summary(model_a)
   coef_df <- as.data.frame(summary_model$coefficients)
   coef_df <- coef_df[rownames(coef_df) != "(Intercept)", ]  # Remove Intercept
   significant_vars <- rownames(coef_df[order(coef_df[, "Pr(>|t|)"]), ])[1:3]  # Select top 3

   # Build new model with top three predictors
   model_b <- lm(as.formula(paste("mpg ~", paste(significant_vars, collapse = " + "))), data = train.df)
   return(model_b)
}

q_2_b_ii <- function()  {
   # TODO: Add your code here
   # TODO: Return a string
   model <- q_2_b_i()
   model_summary <- summary(model)
   
   # Extract R-squared and adjusted R-squared
   r_sq <- model_summary$r.squared
   adjusted_r_sq <- model_summary$adj.r.squared
   
   # Calculate RSE
   rse <- model_summary$sigma
   
   # Calculate RMSE
   residuals <- model$residuals
   rmse <- sqrt(mean(residuals^2))
   
   return(sprintf("r-sq=%.2f,adjusted-r-sq=%.2f,rse=%.2f,rmse=%.2f", r_sq, adjusted_r_sq, rse, rmse))
}

q_2_b_iii <- function()  {   
   # TODO: Add your code here.
   # TODO: Return a string
   model_a_values <- q_2_a_iii()
   model_b_values <- q_2_b_ii()
   
   # Compare R^2 and RMSE to decide which model fits better (higher R^2, lower RMSE)
   if (model_b_values > model_a_values) {
       return("model in 2(b)(i)")
   } else {
       return("model in 2(a)(i)")
   }
}

q_2_b_iv <- function() {  
   # Do nothing here, this is a placeholder.  DO NOT DELETE THIS FUNCTION.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}

# Q 2c -------------

q_2_c <- function()  {
   # TODO: Add your code here.
   # TODO: Return a data frame.  DO NOT round any values in the data frame.
   train.df %>% select(-name) -> train
   test.df %>% select(-name) -> test

   model <- lm(mpg ~ ., train)

   # Predict on the test set with a 95% confidence level for prediction interval
   predictions <- predict(model, newdata = test, interval = "prediction", level = 0.95)

   # Create the data frame with required columns
   prediction_df <- data.frame(
     prediction = predictions[, 1],
     response = test$mpg,
     lower = predictions[, 2],
     upper = predictions[, 3]
   )
   
   # Calculate 'matches' column
   prediction_df$matches <- ifelse(prediction_df$response >= prediction_df$lower & 
                                   prediction_df$response <= prediction_df$upper, 1, 0)
   
   return(prediction_df)
}