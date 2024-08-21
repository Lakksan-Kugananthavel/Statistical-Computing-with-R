# Statistical-Computing-with-R

This repository contains a variety of R projects demonstrating my ability and proficiency with R across a range of different statistical problems.

## Classification Using Linear Discriminant Analysis (LDA)

This project involves developing a Linear Discriminant Analysis (LDA) model to classify iris flowers into one of two populations (A or B) based on their morphological features, specifically the lengths and widths of their sepals and petals. 

The classification problem is framed mathematically under the assumption that the feature vectors for each population follow a multivariate Normal distribution with a shared covariance matrix. The goal is to estimate the necessary parameters—mean vectors, covariance matrix, and population proportions—from the training data, and then use these estimates to classify new observations into one of the two populations.

Training data visualisation:

<img src="LDA Classification/IrisTrainingDataset.png" alt="IrisTrainingDataset" width="90%">

## Outcomes
- Estimated the mean vectors for each population based on the training data.
- Computed the pooled covariance matrix using the within-population covariances.
- Calculated the prior probabilities based on the proportion of samples in each population.
- Implemented the LDA decision rule to classify a new observation by calculating the linear discriminant score and comparing it to a decision boundary.
- Evaluated the model accuracy by predicting an existing test set; identifying a classification accuracy on 92%

Results:

<img src="LDA Classification/LDA_Classification.png" alt="LDA Classification" width="50%">
