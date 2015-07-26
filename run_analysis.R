## You should create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data 
##    set with the average of each variable for each activity and each subject.


## Install required libraries if they're not present
if (!require("data.table")) {
    install.packages("data.table")
}
if (!require("dplyr")) {
    install.packages("dyplr")
}

## Load required libraries
library(data.table)
library(dplyr)

## Downloads the 'Dataset.zip' file and extract it
if (!file.exists("./UCI HAR Dataset")) {
    if (!file.exists("./Dataset.zip")) {
        fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl, destfile = "Dataset.zip")
        
    }
    unzip("Dataset.zip")
}


## Train data load
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
dataTrain <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)

## Test data load
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
dataTest <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)

## Metadata load
featureNames <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE, col.names = c("ID", "Name"))


################################################################################
## 1. Merges the training and the test sets to create one data set.
################################################################################

## Merge train and test data.
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
data <- rbind(dataTrain, dataTest)


################################################################################
## 4. Appropriately labels the data set with descriptive variable names.
################################################################################
## Names
colnames(data) <- featureNames[,2]
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"


## FINALLY: The Complete dataset
completeData <- cbind(subject, activity, data)



################################################################################
## 2. Extracts only the measurements on the mean and standard deviation for 
##    each measurement. 
################################################################################

meanStdIndex <- grep("mean|std", colnames(completeData), ignore.case = TRUE)
extractedData <- cbind(completeData[, 1:2], completeData[, meanStdIndex])


################################################################################
## 3. Uses descriptive activity names to name the activities in the data set.
################################################################################

extractedData$Activity <- factor(extractedData$Activity, levels = activityLabels$ID, labels = activityLabels$Name)


################################################################################
## 5. From the data set in step 4, creates a second, independent tidy data 
##    set with the average of each variable for each activity and each subject.
################################################################################

tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyData <- arrange(tidyData, Subject, Activity)
write.table(tidyData, file = "TidyData.txt", row.names = FALSE)