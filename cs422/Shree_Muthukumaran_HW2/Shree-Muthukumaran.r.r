# Shree Ramachandran Muthukumaran
# A20507651 
# HW 2

# DO NOT CHANGE THE NAMES OF THE FUNCTIONS.
# The plot title and x- and y-axis labels MUST BE LOWER CASED.
df <- read.csv("DelayedFlights-Small.csv")

q_2_a <- function()  {
   delayed_flights <- df
   na_count <- colSums(is.na(delayed_flights))  # Count the number of NAs in each column
   print(na_count)  # Display the table of NAs per column

   num_columns_with_na <- sum(na_count > 0)  # Count how many columns have more than 0 NAs
   return(num_columns_with_na)  # Return the scalar value
}

q_2_b_i <- function()  {
   most_delay <- "lateaircraftdelay"
   least_delay <- "nasdelay"
   
   return(paste("most=", most_delay, ",least=", least_delay, sep=""))
}

q_2_b_ii <- function()  {
   delayed_flights <- df
   # Extract relevant columns for delays
   delay_data <- delayed_flights[, c("CarrierDelay", "WeatherDelay", "NASDelay", "SecurityDelay", "LateAircraftDelay")]
   
   # Create a list of delay causes
   causes <- c("carrier", "weather", "nas", "security", "late_aircraft")
   
   # Calculate mean and median for each delay, rounding to 2 decimal places
   mean_delays <- sapply(delay_data, function(x) round(mean(x, na.rm=TRUE), 2))
   median_delays <- sapply(delay_data, function(x) round(median(x, na.rm=TRUE), 2))
   
   # Create a data frame with cause, mean, and median
   result_df <- data.frame(cause=causes, mean=mean_delays, median=median_delays)
   
   # Sort the data frame by the 'mean' column in descending order
   result_df <- result_df[order(-result_df$mean), ]
   
   # Return the sorted data frame
   return(result_df)
}

q_2_b_iii <- function()  {
   delayed_flights <- df 
   # Get the sorted data frame
   delay_df <- q_2_b_ii()
   
   # Extract the cause with the highest and lowest mean delays
   most_actual <- delay_df$cause[1]
   least_actual <- delay_df$cause[nrow(delay_df)]
   
   # Get the guessed values from q_2_b_i()
   guess <- q_2_b_i()
   most_guess <- sub(".*most=([a-z]+),.*", "\\1", guess)
   least_guess <- sub(".*,least=([a-z]+)", "\\1", guess)
   
   most_actual <- ifelse(most_actual == "late_aircraft", "lateaircraftdelay", paste0(most_actual, "delay"))
   least_actual <- ifelse(least_actual == "late_aircraft", "lateaircraftdelay", paste0(least_actual, "delay"))

   # Check if the guess matches the actual
   if (most_guess == most_actual && least_guess == least_actual) {
       return("yes")
   } else if (most_guess == most_actual || least_guess == least_actual) {
       return("half")
   } else {
       return("no")
   }
}

q_2_c_i <- function()  {
   delayed_flights <- df
   # Filter rows where departure delay is greater than 30 minutes
   delayed_over_30 <- delayed_flights[delayed_flights$DepDelay > 30, ]
   
   # Count the number of observations
   num_observations <- nrow(delayed_over_30)
   return(num_observations)
}

q_2_c_ii <- function()  {
   delayed_flights <- df

   delayed_over_30 <- delayed_flights[delayed_flights$DepDelay > 30, ]
   delays_by_airline <- aggregate(DepDelay ~ UniqueCarrier, data=delayed_over_30, FUN=sum)
   
   # airline with the least and most delays
   min_delay_airline <- delays_by_airline[which.min(delays_by_airline$DepDelay), ]
   max_delay_airline <- delays_by_airline[which.max(delays_by_airline$DepDelay), ]
   
   # Format result
   result <- paste(min_delay_airline$UniqueCarrier, "=", min_delay_airline$DepDelay, ",", max_delay_airline$UniqueCarrier, "=", max_delay_airline$DepDelay, sep="")
   return(result)
}

q_2_c_iii <- function()  {
   delayed_flights <- df

   delayed_flights_over_30 <- delayed_flights[delayed_flights$DepDelay > 30, ]
   delays_by_airline <- aggregate(DepDelay ~ UniqueCarrier, data = delayed_flights_over_30, sum)
   
   # Sort by total delays
   delays_by_airline <- delays_by_airline[order(delays_by_airline$DepDelay), ]
   
   # Plot the bar plot
   file_name <- "hw2-plot/plot-20507651-2-c_iii.png"
   png(file_name)
   barplot(delays_by_airline$DepDelay, names.arg = delays_by_airline$UniqueCarrier, 
           xlab = "carrier code", ylab = "delay (minutes)", 
           main = "delayed flights")
   dev.off()
   return(file_name)
}

q_2_d_i <- function()  {
   delayed_flights <- df
   # Create a new data frame with relevant delay columns
   delay_vars <- delayed_flights[, c("CarrierDelay", "WeatherDelay", "NASDelay", "SecurityDelay", "LateAircraftDelay", "DepDelay")]
   
   # Compute the correlation matrix while handling NA values
   corr_matrix <- cor(delay_vars, use = "pairwise.complete.obs")
   
   # Round the correlation matrix to two decimal points
   corr_matrix_rounded <- round(corr_matrix, 2)
   return(corr_matrix_rounded)
}

q_2_d_ii <- function()  {
   delayed_flights <- df
   library(corrplot)

   delay_vars <- delayed_flights[, c("CarrierDelay", "WeatherDelay", "NASDelay", "SecurityDelay", "LateAircraftDelay", "DepDelay")]
   corr_matrix <- cor(delay_vars, use = "pairwise.complete.obs")
   
   # Plot the correlation matrix
   file_name <- "hw2-plot/plot-20507651-2-d_ii.png"
   png(file_name)
   corrplot(corr_matrix)
   dev.off()
   
   # Return the name of the plot file
   return(file_name)
}

q_2_d_iii <- function()  {
   delayed_flights <- df
   library(corrplot)
   
   delay_vars <- delayed_flights[, c("CarrierDelay", "WeatherDelay", "NASDelay", "SecurityDelay", "LateAircraftDelay", "DepDelay")]
   corr_matrix <- cor(delay_vars, use = "pairwise.complete.obs")
   
   # Use corrplot to get the correlation matrix details
   corr_details <- corrplot(corr_matrix)
   
   # Extract correlation positions
   corr_pos <- corr_details$corrPos
   
   # Filter the rows where the correlation is with "DepDelay"
   dep_delay_corr <- corr_pos[corr_pos$xName == "DepDelay", ]
   
   # Sort the data frame by the "corr" column (correlation values)
   dep_delay_corr_sorted <- dep_delay_corr[order(dep_delay_corr$corr), ]
   
   # Return the sorted data frame
   return(dep_delay_corr_sorted)
}

q_2_d_iv <- function()  {
   # Get the sorted data frame from q_2_d_iii()
   dep_delay_corr_sorted <- q_2_d_iii()
   
   # Find the strongest positive and negative correlations
   strongest_positive <- dep_delay_corr_sorted[which.max(dep_delay_corr_sorted$corr), ]
   strongest_negative <- dep_delay_corr_sorted[which.min(dep_delay_corr_sorted$corr), ]
   
   # Format the result string
   result <- paste("strongest positive=", tolower(strongest_positive$yName), ",strongest negative=", tolower(strongest_negative$yName), sep="")
   return(result)
}