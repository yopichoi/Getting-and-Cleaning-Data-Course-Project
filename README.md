## Introduction

This repository hosts the R code for the Course Project of the Data Science course "Getting and Cleaning Data". The purpose of this project is to demonstrate the ability to collect, work with, and clean a data to produce a tidy dataset.

## Course Project Instructions

You should create one R script called `run_analysis.R` that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Data Set

The data set "Human Activity Recognition Using Smartphones" represents data collected from the accelerometers from the Samsung Galaxy S smartphone. It has been taken from the UCI Repository and it's available in: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Execution

To execute the script, just run the `run_analysis.R` file. If the script is placed in a directory containing the `UCI HAR Dataset/` directory it will automatically perform the cleaning and processing of the files required.

If no `UCI HAR Dataset/` is present it will check if a `Dataset.zip` file is present on the directory and proceed to unzip it. If no zip file is present it will attemp to download it from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip , provided that there's an Internet connection.

The result of the script is a `TidyData.txt` file that stores the mean and standard deviation of each measurement per Subject & Activity.

## Files

* This `README.md` file.

* The `run_analysis.R` file containing the script to process the dataset.

* The `CodeBook.md` describing the variables, the data, and the work that has been performed to clean up the data.


## Dependencies

The `run_analysis.R` script will install the `data.table` and `dplyr` packages automatically if they're not already installed.