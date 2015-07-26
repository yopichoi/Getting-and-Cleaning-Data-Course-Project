# CodeBook

This is a code book that describes the variables, the data, and any transformations or work performed to clean up the data.

## The Data

* Original data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

* Original description of the dataset: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Dataset description

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (`WALKING`, `WALKING_UPSTAIRS`, `WALKING_DOWNSTAIRS`, `SITTING`, `STANDING`, `LAYING`) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

#### For each record it is provided:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

#### The dataset includes the following files:

* 'README.txt'

* 'features_info.txt': Shows information about the variables used on the feature vector.

* 'features.txt': List of all features.

* 'activity_labels.txt': Links the class labels with their activity name.

* 'train/X_train.txt': Training set.

* 'train/y_train.txt': Training labels.

* 'test/X_test.txt': Test set.

* 'test/y_test.txt': Test labels.

#### The following files are available for the train and test data. Their descriptions are equivalent.

* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

* 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.

* 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration.

* 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

## Variables

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals `tAcc-XYZ` and `tGyro-XYZ`. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz.

Similarly, the acceleration signal was then separated into body and gravity acceleration signals `tBodyAcc-XYZ` and `tGravityAcc-XYZ` (again, prefix 't' to denote time) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals `tBodyAccJerk-XYZ` and `tBodyGyroJerk-XYZ`.

The magnitude of these three-dimensional signals were calculated using the Euclidean norm (`tBodyAccMag`, `tGravityAccMag`, `tBodyAccJerkMag`, `tBodyGyroMag`, `tBodyGyroJerkMag`). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing `fBodyAcc-XYZ`, `fBodyAccJerk-XYZ`, `fBodyGyro-XYZ`, `fBodyAccJerkMag`, `fBodyGyroMag`, `fBodyGyroJerkMag`. (The 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
`'-XYZ'` is used to denote 3-axial signals in the `X`, `Y` and `Z` directions.



## Data transformation

If the script is placed in a directory containing the `UCI HAR Dataset/` directory it will automatically perform the cleaning and processing of the files required. Otherwise, it will attemp to download it. The `unzip` function is used to extract the files from the downloaded `Dataset.zip` file.

```
if (!file.exists("./UCI HAR Dataset")) {
    if (!file.exists("./Dataset.zip")) {
        fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl, destfile = "Dataset.zip") }
    unzip("Dataset.zip")}
```

The `read.table` package is used for it's effiency to load the data on the activities, the subjects and the measures of both test and training datasets. The metadata is loaded as well.

```
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
```

#### Merge test and training sets into one data set, including the activities

```
## Merge train and test data.
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
data <- rbind(dataTrain, dataTest)
completeData <- cbind(subject, activity, data)
```

#### Extract only the measurements on the mean and standard deviation for each measurement

The `grep` function is used to extract the indices of the the columns with mean and std measures. The indices are used to subset the data:

```
meanStdIndex <- grep("mean|std", colnames(completeData), ignore.case = TRUE)
extractedData <- cbind(completeData[, 1:2], completeData[, meanStdIndex])
```

#### Descriptive activity names to name the activities in the dataset

The class labels linked with their activity names are loaded from the `activity_labels.txt` file onto `activityLabels`. The activity names in the dataset replace the corresponding number using the `factor` function:

```
extractedData$Activity <- factor(extractedData$Activity, levels = activityLabels$ID, labels = activityLabels$Name)
```

#### Appropriately labels the data set with descriptive activity names

Each column of the dataset is labeled using `featureNames` (loaded from `features.txt` file). The `Subject` and `Activity` columns are also properly labeled before merging them to the test and train dataset.

```
colnames(data) <- featureNames[,2]
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
```

#### Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

We create tidyData as a data set with the average for each activity and subject using the `aggregate` function. Then, it's enties are ordered with `arrange` and the result is writen to a file named `TidyData.txt` that contains the processed data.

```
tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyData <- arrange(tidyData, Subject, Activity)
write.table(tidyData, file = "TidyData.txt", row.names = FALSE)
```