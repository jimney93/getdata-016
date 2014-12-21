# Coursera Course Project 
# Getting and Cleaning Data
# project data Human Activity Recognition Using SmartPhones Data set
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# description of data set
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
#######################################################################################
# run_analysis.R
# Operating system OSX 10.8.5

# install required packages
  install.packages("plyr")
  library(plyr)
  install.packages("reshape")
  library(reshape)
  install.packages("tidyr")
  library(tidyr)
  install.packages("dplyr")
  library(dplyr)

# link to data set
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# create temporary file to hold zip
temp <- tempfile(fileext = ".zip")

# download to temp temporary file
download.file(url, temp, method = "curl")

# unz to data folder
if(!file.exists("data")){
  dir.create("data")
}
unzip(temp, list=F, exdir = "data")

# unlink temp
unlink(temp)

# setup activity table
activity_label = read.table("data/UCI HAR Dataset/activity_labels.txt", sep = "\t")
activity <- cbind(activity_label, colsplit(activity_label$V1, " ", c("id", "activity")))
activity <- subset(activity, select = -c(V1))

# setup features table
features = read.table("data/UCI HAR Dataset/features.txt", sep = "")

# setup test data 
xTest = read.table("data/UCI HAR Dataset/test/X_test.txt", sep = "")
yTest = read.table("data/UCI HAR Dataset/test/Y_test.txt", sep = "")
subjectTest = read.table("data/UCI HAR Dataset/test/subject_test.txt")

# setup training data
xTrain = read.table("data/UCI HAR Dataset/train/X_train.txt", sep = "")
yTrain = read.table("data/UCI HAR Dataset/train/Y_train.txt", sep = "")
subjectTrain = read.table("data/UCI HAR Dataset/train/subject_train.txt")

# assign nice column names? 
colnames(xTest) <- features[,2]
colnames(xTrain) <- features[,2]
yTest <- rename(yTest, c("V1" = "id"))
yTrain <- rename(yTrain, c("V1" = "id"))
subjectTest <- rename(subjectTest, c("V1" = "subjectID"))
subjectTest <- mutate(subjectTest, group = "test")
#subjectTest <- rename(subjectTest, c("V1" = "group"))
subjectTrain <- rename(subjectTrain, c("V1" = "subjectID"))
subjectTrain <- mutate(subjectTrain, group = "train")
#subjectTrain <- rename(subjectTrain, c("V1" = "group"))

# add activity to the subjects and preserve order
yTest <- join(yTest, activity, type = "inner")    #joining on id
yTrain <- join(yTrain, activity, type = "inner")  #joining on id

# bind three test data sets
test_DF <- cbind(subjectTest, yTest, xTest)
test_DF <- subset(test_DF, select = -c(id))     # remove extraneous column
train_DF <- cbind(subjectTrain, yTrain, xTrain)
train_DF <- subset(train_DF, select = -c(id))   # remove extraneous column

# satisfies requirements 
#   1 merge test and train datasets, use row binding
# merge the test and training data sets
merged_DF <- rbind(test_DF, train_DF)

# pivot merged_DF change to "long table"
tidy <- merged_DF %>%
  gather(feature, value, -subjectID, -group, -activity)

# build list of mean and standard deviation column names to support subsequent filtering of columns
mean_col <- features[grep("mean", features$V2),]
std_col <- features[grep("std", features$V2),]
mean_std <- rbind(mean_col, std_col)

# satisfies requirements
#   2 extracts only the measurements on the mean and standard deviations for each subject, group, activity
# filter only the mean and std variables, this is at the detail level
Data_mean_std <- tidy[tidy$variable %in% mean_std$V2,]

# satisfies requirements
#   5 create second, independent tidy data set
#     average values over subject, group, activity, variable
#     added column to easily identify a test group from a training group
# average values
tidyDataSet <- ddply(tidy, c("subjectID", "group", "activity", "variable"), function(x) c(average=mean(x$value)))


# check for file existance and delete if found, then write
if(file.exists("tidyDataSet.txt")){
  file.remove("tidyDataSet.txt")
}
write.table(tidyDataSet, "tidyDataSet.txt", sep = " ", row.names = F)
