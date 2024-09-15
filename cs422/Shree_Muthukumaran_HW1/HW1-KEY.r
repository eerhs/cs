# Vijay K. Gurbani
# HW 1 Key

# DO NOT CHANGE THE NAMES OF THE FUNCTIONS.
# The plot title and x- and y-axis labels MUST BE LOWER CASED.

data(cars)

q_1_a <- function()  {
  
   # TODO: Add your code here
   selected_rows <- cars[c(1,5,8,20), ]
   # TODO: Return a data frame
   return(selected_rows)
}

q_1_b <- function()  {

   file_name <- "hw1-plot/plot-0001111-1-b.png"  # TODO: Replace ID with your A#
   png("hw1-plot/plot-key-1-b.png")
   plot(cars$speed, cars$dist, main="scatterplot of the cars dataset", 
        xlab="speed (mph)", ylab="distance (ft)")
   dev.off()
   return(file_name)
}

q_1_c <- function()  {

   file_name <- "hw1-plot/plot-0001111-1-c.png"  # TODO: Replace ID with your A#
   png("hw1-plot/plot-key-1-c.png")
   plot(cars$speed, cars$dist, main="line graph of the cars dataset", 
        xlab="speed (mph)", ylab="distance (ft)", type='l')
   dev.off()
   return(file_name)
}

q_1_d <- function()  {
  
   # TODO: Add your code here
   summary_data <- summary(cars)
   # Return the summary object
   return(summary_data)
}

q_1_e <- function() {
  
   # TODO: Add your code here
   max_speed <- max(cars$speed)
   min_dist <- min(cars$dist)
   # TODO: Return a list
   return(list(max_speed,min_dist))
}

q_1_f <- function() {
  
   # TODO: Add your code here
   ratio <- cars$speed / cars$dist
   cars$ratio <- ratio
   # TODO: Return a data frame
   return(cars)
}
