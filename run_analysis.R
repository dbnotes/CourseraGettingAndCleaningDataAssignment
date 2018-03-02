library(dplyr)

# Download the files to a newly created directory called 'data'
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to the data directory - a subfolder will be created called 'UCI HAR Dataset'
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Test Data
# read in the test data set
testData <- read.csv("./data/UCI HAR Dataset/test/X_test.txt",sep = "",header = FALSE)
dim(testData)
# read in the test labels
testLabels <- read.csv("./data/UCI HAR Dataset/test/y_test.txt",sep = "",header = FALSE)
# read in the test subjects
testSubjects <- read.csv("./data/UCI HAR Dataset/test/subject_test.txt",sep = "",header = FALSE)

# Training Data
# read in the training data set
trainingData <- read.csv("./data/UCI HAR Dataset/train/X_train.txt",sep = "",header = FALSE)
dim(trainingData)
# read in the test labels
trainingLabels <- read.csv("./data/UCI HAR Dataset/train/y_train.txt",sep = "",header = FALSE)
# read in the test subjects
trainingSubjects <- read.csv("./data/UCI HAR Dataset/train/subject_train.txt",sep = "",header = FALSE)

# read the activity labels
activityLables <- read.csv("./data/UCI HAR Dataset/activity_labels.txt",sep = "",header = FALSE)

colnames(activityLables) <- c("ActivityID","ActivityName")
head(activityLables)

# read in the features and get only the mean and standard deviation rows
features <- read.csv("./data/UCI HAR Dataset/features.txt",sep = " ",header = FALSE)
colnames(features) <- c("FeatureID", "FeatureNames")

# merge the data
subjects <- rbind(trainingSubjects, testSubjects)
activities <- rbind(trainingLabels, testLabels)
data <- rbind(trainingData, testData)
dim(data)

# Set column headers for the training and test sets:
colnames(activities) <- "ActivityID"
colnames(subjects) <- "SubjectID"

# Combine all of the different columns together into one table
DataSet <- cbind(subjects, activities, data)

# Rename the columns for the measurements with the names in the features file 
# because there are 561 feature names and 561 "V" columns
# Note the names need to be characters and not factors, hence the use of as.character
head(features)
#renamedFeatures <- paste0(features$FeatureID,'_',features$FeatureNames)
renamedFeatures <- as.character(features$FeatureNames)
str(renamedFeatures)
#renamedFeatures <- features$FeatureNames
colnames(DataSet)<-c(c('SubjectID', 'ActivityID'), renamedFeatures)

# Select columns related to mean and standard
# Notes: This stack overflow example helped me a lot!!
# https://stackoverflow.com/questions/24176448/subset-data-based-on-partial-match-of-column-names
filteredColumns <- DataSet[,c("SubjectID","ActivityID",colnames(DataSet)[grep("mean\\(|std", colnames(DataSet))])]

# remove brackets from the column names and convert to camel case
colnames(filteredColumns)<- gsub("\\(\\)", "", colnames(filteredColumns))
colnames(filteredColumns)<- gsub("-", "", colnames(filteredColumns))
colnames(filteredColumns)<- gsub("^t","time", colnames(filteredColumns))
colnames(filteredColumns)<- gsub("^f", "frequency", colnames(filteredColumns))
colnames(filteredColumns)<- gsub("std", "Std", colnames(filteredColumns))
colnames(filteredColumns)<- gsub("mean", "Mean", colnames(filteredColumns))
colnames(filteredColumns)<- gsub("BodyBody", "Body", colnames(filteredColumns))
colnames(filteredColumns)<- gsub("Acc", "Acceleration", colnames(filteredColumns))
colnames(filteredColumns)<- gsub("Mag", "Magnitude", colnames(filteredColumns))

head(filteredColumns)
dim(filteredColumns)

# Add Activity Data Names by merging the activity data frame and the filtered data set.
mergedData = merge(activityLables,filteredColumns,by = "ActivityID")
head(mergedData)
dim(mergedData)

# Create a second, independent tidy data set with the average of each variable for each activity and each subject
meanData = aggregate(mergedData[4:69], by=list(activity=mergedData$ActivityName, subject=mergedData$SubjectID), mean)
head(meanData)
dim(meanData)
# Write the data set to a file
write.table(meanData,file='./data/tidy_data.txt',row.names=FALSE)

# optional auto-production of a secondary codebook listing all variables
# install.packages("memisc")
# library(memisc)
# Write(codebook(meanData), file='./data/codebook.txt')
