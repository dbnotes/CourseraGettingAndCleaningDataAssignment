# Getting and Cleaning Data Project Code Book

The purpose of this project is to collect, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

This document describes the variables, the data, and any transformations done to clean up the data.

## Study design and data processing

The steps taken in the project were as follows:

There is one R script called run_analysis.R that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


### Collection of the raw data

The data set was retreived from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The original data set can be found at:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The first steps in the run_analysis.R are to download the file into a directory called 'data'
and unzip it.

### Notes on the original (raw) data 

There is an overview in the README.txt included in the zipped data which explains the content of the raw data files, and is referred to in the section below.


## Creating the tidy datafile

### Guide to create the tidy data file 

1. Down load the files and unzip to a folder called "UCI HAR Dataset"

2. Read in the test and training files:

    * test/X_test.txt - test measurement data (dimensions: 2947 * 561)
    * test/y_test.txt - test labels (the Activity IDs that correspond to the test measurements) (dimensions: 2947 * 1)
    * test/subject_test.txt - test subject IDs (dimensions: 2947 * 1)
    * train/X_train.txt - training measurement data (dimensions: 7352 * 561)
    * train/y_train.txt - training labels (the Activity IDs that correspond to the test measurements) (dimensions: 7352 * 1)
    * train/subject_train.txt - training subject IDs (dimensions: 7352 * 1)

3. Read in the activity labels

This is the activity ID and corresponding activity name

* activity_labels.txt (dimensions: 6 *2)

4. Read in the features

This is the description given for the different measurements

* features.txt  (dimensions: 561 * 2)


### Cleaning of the data 

The script run_analysis.R tidies the data in the following ways:

1. Add column Names for the Activity ID and Subject ID
2. Merge the files for subjects (test and training); Activity IDs (test and training); measurement Data (test and training)
3. Merge the above 3 files into one Data Set (variable DataSet)
4. Rename the columns for the measurements with the names in the features file because there are 561 feature names and 561 "V" columns 
5. Filter the columns to only include ActivityID, SubjectID and those columns related to mean() and std() (mean and standard deviation) - I excluded meanFreq and the angle variables
6. Add the Activity Names to the file (WALKING, RUNNING etc)
7. Write a second data set to a file tidy_data.txt with the average of each variable for each activity and each subject


## Description of the variables in the tiny_data.txt file 

The file contains the average of each measurement for each activity and each subject

Dimensions of the dataset:

There are 6 activities and 30 subject IDs, and 66 measurements columns relating to mean and standard deviation data.

The average then is 180 (6*30) by 68 columns in total (66+2)

### Summary of the tidy data

This section details the variables in the tidy_data.txt. 

1.   activity
```
   Storage mode: integer
   Factor with 6 levels

        Values and labels    N    Percent 
                                          
   1 'LAYING'               30   16.7     
   2 'SITTING'              30   16.7     
   3 'STANDING'             30   16.7     
   4 'WALKING'              30   16.7     
   5 'WALKING_DOWNSTAIRS'   30   16.7     
   6 'WALKING_UPSTAIRS'     30   16.7  
```

2.   subject
```
   Storage mode: integer

          Min.:   1.000
       1st Qu.:   8.000
        Median:  15.500
          Mean:  15.500
       3rd Qu.:  23.000
          Max.:  30.000
```
          
The rest of the variables relate to the measurements taken during the experiment. For full details of the interpretation of the column headers, see the features_info.txt file included in the zipped data set. The data set only includes the subset of mean and standard deviation measurements as per the project instructions, with an average taken for each of these sets.

All measurements are in storage format of double.

The column names were tidied in the following way:

* headers converted to camel case
* special characters such as brackets and hyphens removed
* t extrapolated to time
* f extrapolated to frequency
* acc extrapolated to Acceleration
* duplicate BodyBody converted to Body

## Sources 
Extensive reading was done of the course discussion forums.

For notes on subsetting the columns, see:
https://stackoverflow.com/questions/24176448/subset-data-based-on-partial-match-of-column-names

Luis A Sandino's help guide:
https://drive.google.com/file/d/0B1r70tGT37UxYzhNQWdXS19CN1U/view
