# Import the data set
iris_training <- read.table("iris-training-data.txt", header = TRUE, sep = " ")

# Set up the plotting layout to display two plots side by side
par(mfrow = c(1, 2))

# Adjust the margins of the plots
par(mar = c(4, 4, 3, 1))

# Plot Petal Width vs. Petal Length
plot(iris_training$Petal.Width ~ iris_training$Petal.Length,
     xlab = "Petal Length (cm)",
     ylab = "Petal Width (cm)",
     pch = c(16, 17)[as.numeric(as.factor(iris_training$population))],
     col = c("magenta", "blue")[as.numeric(as.factor(iris_training$population))],
     main = "Petal Width vs. Petal Length")

# Add a legend to the first plot
legend("bottomright",
       legend = c("Population A", "Population B"),
       pch = c(16, 17),
       col = c("magenta", "blue"), 
       cex = 0.8)

# Plot Sepal Width vs. Sepal Length
plot(iris_training$Sepal.Width ~ iris_training$Sepal.Length,
     xlab = "Sepal Length (cm)",
     ylab = "Sepal Width (cm)",
     pch = c(16, 17)[as.numeric(as.factor(iris_training$population))],
     col = c("magenta", "blue")[as.numeric(as.factor(iris_training$population))],
     main = "Sepal Width vs. Sepal Length")
# Add a legend to the second plot
legend("bottomright", 
       legend = c("Population A", "Population B"), 
       pch = c(16, 17), 
       col = c("magenta", "blue"),
       cex = 0.8)


# Define the training_est function
training_est <- function(training_data) {
  p <- ncol(training_data) - 1  # Number of dimensions of the observations
  n <- nrow(training_data)  # Number of observations
  
  # Subset the observations into the two populations:
  data_A <- training_data[training_data$population == "A", 1:p]
  data_B <- training_data[training_data$population == "B", 1:p]
  
  # Estimate the required quantities:
  n_A <- nrow(data_A)
  n_B <- nrow(data_B)
  
  pi_A <- n_A / n  # Proportion of population A
  pi_B <- n_B / n  # Proportion of population B
  
  mean_A <- colMeans(data_A)  # Mean vector for population A
  mean_B <- colMeans(data_B)  # Mean vector for population B
  
  # Pooled covariance estimate
  cov_est <- ((n_A - 1) * cov(data_A) + (n_B - 1) * cov(data_B)) / (n - 2)
  
  # Return the estimated quantities in a list:
  training_ests <- list(mean_A = mean_A, 
                        mean_B = mean_B,
                        pi_A = pi_A, 
                        pi_B = pi_B, 
                        cov_est = cov_est)
  
  return(training_ests)
}    

# Define function to compute the linear discriminant vector
compute_discriminant_vector <- function(cov_est, mean_A, mean_B) {
  l_hat <- solve(cov_est) %*% (mean_A - mean_B)
  return(as.vector(l_hat))
}

# Define calc_decision_point function
calculate_decision_boundary <- function(l_hat, mean_A, mean_B, pi_A, pi_B) {
  decision_point <- 0.5 * sum(l_hat * (mean_A + mean_B)) - log(pi_A / pi_B)
  return(decision_point)
}

# Define classify_observation function
classify_observation <- function(obs, l_hat, decision_point) {
  if(sum(l_hat * obs) > decision_point) {
    population_estimate <- "A"
  } else {
    population_estimate <- "B"
  }
  return(population_estimate)
}

# Define classify_data function
classify_data <- function(training_data, test_data) {
  # Estimate parameters from the training data
  train_ests <- training_est(training_data)
  
  # Calculate the linear discriminant vector
  l_hat <- compute_discriminant_vector(cov_est = train_ests$cov_est, 
                      mean_A = train_ests$mean_A, 
                      mean_B = train_ests$mean_B)
  
  # Calculate the decision point
  decision_point <- calculate_decision_boundary(l_hat = l_hat, 
                                        mean_A = train_ests$mean_A,
                                        mean_B = train_ests$mean_B,
                                        pi_A = train_ests$pi_A, 
                                        pi_B = train_ests$pi_B)
  
  # Classify each observation in the test data
  population_estimates <- apply(X = test_data, MARGIN = 1, FUN = classify_observation,
                           l_hat = l_hat, decision_point = decision_point)
  
  return(population_estimates)
}

# Import the test data
test_data <- read.table("iris-test-data.txt", header = TRUE, sep = " ")  # Import the test data set

# Classify the test data using the training data
iris_results <- classify_data(training_data = iris_training, test_data = test_data)

# Add the classification results to the test data
test_data$population_est <- iris_results

# Create the vector of known populations for test_data:
test_data$population <- c(rep("A", 10), rep("B", 15))

# Calculate the proportion of correctly classified points
accuracy  <- mean(test_data$population == test_data$population_est)
print(paste0(round(accuracy  * 100), "% of the observations were correctly classified."))

# Introduce a new variable 'class', that indicates whether the observation was correctly classified
test_data$class <- factor(as.numeric(test_data$population == test_data$population_est))

# Plot the data, using the class variable to set point types
plot(Petal.Width ~ Petal.Length,
     xlab = "Petal Length (cm)",
     ylab = "Petal Width (cm)", 
     main = "Classification Results",
     pch = ifelse(test_data$class == 1, c(16, 17)[as.numeric(as.factor(test_data$population))], 4),  # Circle for A, Triangle for B, Crosses for misclassified
     col = ifelse(test_data$class == 1, c("magenta", "blue")[as.numeric(as.factor(test_data$population))], "black"),
     data = test_data)

# Add a legend to the plot
legend("topleft",
       legend = c("Population A", "Population B", "Misclassified"),
       pch = c(16, 17, 4),  # Circle for A, Triangle for B, Crosses for misclassified
       col = c("magenta", "blue", "black"), 
       cex = 1)