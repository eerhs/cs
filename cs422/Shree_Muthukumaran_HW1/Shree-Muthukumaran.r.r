# Shree Ramachandran Muthukumaran
# A#20507651
# HW 1 

# DO NOT CHANGE THE NAMES OF THE FUNCTIONS.
# The plot title and x- and y-axis labels MUST BE LOWER CASED.

data(cars)

q_1_a <- function()  {
   selected_rows <- cars[c(1,5,8,20),]
   return(selected_rows)
}

q_1_b <- function()  {
   file_name <- "hw1-plot/plot-A20507651-1-b.png"
   png(file_name)
   plot(cars$speed, cars$dist,
       xlab = "speed (mph)",   # Label for the X-axis
       ylab = "distance (ft)", # Label for the Y-axis
       main = "scatterplot of the cars dataset") # Title of the plot
   dev.off()
   return(file_name)
}

q_1_c <- function()  {
   file_name <- "hw1-plot/plot-A20507651-1-c.png"
   png(file_name)
   plot(cars$speed, cars$dist,
        type = "l",             # 'l' for line graph
        xlab = "speed (mph)",   # Label for the X-axis
        ylab = "distance (ft)", # Label for the Y-axis
        main = "line graph of the cars dataset") # Title of the plot
   dev.off()
   return(file_name)
}

q_1_d <- function()  {
   cars_summary <- summary(cars)	# Generate the summary of the cars dataset
   
   # Return the summary
   return(cars_summary)
}

q_1_e <- function() {
   cars_summary <- summary(cars)	# Generate the summary of the cars dataset
   
   # Extract the maximum speed and minimum distance
   max_speed <- cars_summary["Max.", "speed"]
   min_dist  <- cars_summary["Min.", "dist"]
   
   # Create a list containing the maximum speed and minimum distance
   result <- list(maximum_speed = max_speed, minimum_distance = min_dist)
   
   return(result)
}

q_1_f <- function() {
  
   # Calculate the ratio of speed to distance using vectorization
   ratio <- cars$speed / cars$dist

   # Add the ratio as a new column to the cars dataframe
   cars$ratio <- ratio
   
   # Return the modified dataframe
   return(cars)
}