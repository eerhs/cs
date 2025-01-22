# Shree Ramachandran Muthukumaran
# A#20507651
# HW 7

rm(list=ls())
library(cluster)
library(factoextra)
library(dbscan)


# --- Q2.1 ------------------------------------------------------------------
q_2_1_a <- function()  { 
   file_path <- "file46.txt"
   data <- readLines(file_path)
   
   # Remove multiple spaces and use comma as the delimiter
   cleaned_data <- gsub(" +", " ", data)
   cleaned_data <- gsub(" ", ",", cleaned_data)
   cleaned_data <- sub(",+", ",", cleaned_data)

   # Read the cleaned data into a data frame
   col_names <- c("Country", "FI", "SW", "DA", "NO", "EN", "GE", "DU", "FL", 
                  "FR", "IT", "SP", "PO")

   dataset <- read.csv(text = paste(cleaned_data, collapse = "\n"), header = FALSE, skip = 1, col.names = col_names)
   dataset$Country <- gsub(",", " ", dataset$Country)

   # Standardize columns 2-13
   numeric_cols <- 2:13
   dataset[, numeric_cols] <- scale(dataset[, numeric_cols])
   return(dataset)
}

q_2_1_b_i <- function()  {
   file_name <- "hw7-plot/plot-20507651-2-1-b-i.png"  # TODO: Replace ID with your
                                                      # student ID number WITHOUT
                                                      # the 'A' prefix.
   # TODO: Add your code here
   # TODO: Return an un-named list object with two elements

   data <- read.table("cleaned_file46.txt", header = TRUE, sep = "\t")
   numeric_data <- data[, -1]    # Exclude the Country column
   
   hc <- hclust(dist(numeric_data), method = "complete")
   
   png(file_name)
   plot(hc, labels = data$Country, main = "Cluster Dendrogram", xlab = "complete linkage")
   dev.off()
   list(hc, file_name)
}

q_2_1_b_ii <- function()  {
   file_name <- "hw7-plot/plot-20507651-2-1-b-ii.png" # TODO: Replace ID with your
                                                      # student ID number WITHOUT
                                                      # the 'A' prefix.
   # TODO: Add your code here
   # TODO: Return an un-named list object with two elements

   data <- read.table("cleaned_file46.txt", header = TRUE, sep = "\t")
   numeric_data <- data[, -1]    # Exclude the Country column
   
   hc <- hclust(dist(numeric_data), method = "single")
   
   png(file_name)
   plot(hc, labels = data$Country, main = "Cluster Dendrogram", xlab = "single linkage")
   dev.off()
   list(hc, file_name)
}

q_2_1_b_iii <- function()  {
   file_name <- "hw7-plot/plot-20507651-2-1-b-iii.png"   # TODO: Replace ID with your
                                                         # student ID number WITHOUT
                                                         # the 'A' prefix.
   # TODO: Add your code here
   # TODO: Return an un-named list object with two elements

   data <- read.table("cleaned_file46.txt", header = TRUE, sep = "\t")
   numeric_data <- data[, -1]    # Exclude the Country column
   
   hc <- hclust(dist(numeric_data), method = "average")
   
   png(file_name)
   plot(hc, labels = data$Country, main = "Cluster Dendrogram", xlab = "average linkage")
   dev.off()
   list(hc, file_name)
}

q_2_1_b_iv <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}

# --- End of Q2.1 ------------------------------------------------------------

# --- Q2.2 ------------------------------------------------------------------
q_2_2_a <- function()  {
   # Return a string: "yes" or "no"

   # Standardization is necessary if features are on different scales or have 
   # different units. If the dataset contains features on similar scales, 
   # standardization is unnecessary.

   data <- read.csv("s1.csv")
   scaled <- apply(data, 2, sd)
   if (any(abs(scaled - mean(scaled)) > 0.1)) {
      return("yes")
   } else {
      return("no")
   }
}

q_2_2_b <- function()  {
   # Add your code here
   # Return a scalar

   data <- read.csv("s1.csv")
   data_scaled <- scale(data)
   
   sil_width <- numeric(10)
   for (k in 2:10) {
      km <- kmeans(data_scaled, centers = k, nstart = 25)
      sil <- silhouette(km$cluster, dist(data_scaled))
      sil_width[k] <- mean(sil[, 3])
   }
   
   optimal_k <- which.max(sil_width)
   return(optimal_k)
}

q_2_2_c <- function()  {
   # Add your code here
   # Return a scalar

   data <- read.csv("s1.csv")
   data_scaled <- scale(data)
   
   wss <- numeric(10)
   for (k in 1:10) {
      km <- kmeans(data_scaled, centers = k, nstart = 25)
      wss[k] <- km$tot.withinss
   }
   
   elbow <- which(diff(diff(wss)) > 0)[1] + 1
   return(elbow)
}

q_2_2_d <- function()  {
   # Add your code here
   # Return a k-means object

   data <- read.csv("s1.csv")
   data_scaled <- scale(data)
   
   optimal_k <- 8
   km <- kmeans(data_scaled, centers = optimal_k, nstart = 25)
   
   #plot(data, col = km$cluster, pch = 20, main = "K-Means Clustering")
   points(km$centers, col = 1:optimal_k, pch = 4, cex = 2)
   
   return(km)
}

q_2_2_e <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}
# --- End of Q2.2 ------------------------------------------------------------

# --- Q2.3 ------------------------------------------------------------------
q_2_3_a <- function()  {
   # Return a string: "yes" or "no"
   return("no")
}

q_2_3_b <- function()  {
   # Add your code here
   # Return a scalar
   
   return(4)  # Number of features*2
}

q_2_3_c <- function()  {
   # Add your code here
   # Return a scalar

   df <- read.csv("s1.csv")
   
   ##kNN_dist <- kNNdist(df, k = 4)
   ##plot(
      ##sort(kNN_dist),
      ##type = "l",
      ##main = "k-NN Distance Scree Plot",
      ##xlab = "Points (sorted by distance)",
      ##ylab = "k-NN Distance",
      ##col = "blue"
   ##)
   
   eps <- 25000
   return(eps)
}

q_2_3_d <- function()  {
   # Do nothing here, this is a placeholder.  DO NOT DELETE.
   # The answer for this will go into your PDF as explained in the homework
   # instructions.
}
# --- End of Q2.3 ------------------------------------------------------------