=====================================================================================================
Coursera Getting and Cleaning Data
James Neyland
pgm: run_analysis.R
=====================================================================================================

Data set supplied by 
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

full description available here
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

data for the project
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

=====================================================================================================

Program developed under OSX 10.8.5

Packages required:
- 'plyr':    tools for splitting, applying and combining data
- 'reshape': flexibly reshape data
- 'tidyr':   easily Tidy Data with spread() and gather() functions
- 'dplyr':   a grammer of data manipulation

Variables:
- 'temp': temporary file used to support the download and unzip of the data file
- 'url':  variable containing link to data file
- 'data': folder in working directory
          Program checks for existance of folder "data" in the working directory and creates 
          if not found.
- 'activity_label': activities measured
- 'features': types of measurements taken
- 'xTest':  test data
- 'yTest':  activities measured on xTest
- 'subjectTest':  subjects in test group, this data frame is also tagged with "test" in a
                  new column so we can easily identify test subjects

- 'xTrain': training data
- 'yTrain': activities measured on xTrain
- 'subjectTrain': subjects in training group, this data frame is also tagged with "train"
                  in a new column so we can easily identify training subjects

- 'test_DF':  build data frame using column binding with
              subjectTest, yTest, xTest
- 'train_DF': build data frame using column binding with
              subjectTrain, yTrain, xTrain

- 'merged_DF':  append test_DF and train_DF using row binding

- 'tidy': turn wide data set into a long data set, one observation per row

- 'mean_col': using grep, build data frame of columns representing a mean calculation
- 'std_col':  using grep, build data frame of columns representing a std calculation
- 'mean_std': append mean_col and std_col using row binding

- 'Data_mean_std':  tidy data set representing all mean and standard deviation calculations
- 'tidyDataSet':  tidy data set averaging measurements over subject, group, activity, variable

- 'tidyDataSet.txt':  tidyDataSet dataframe is written to a text file in the working directory

Process:
- install packages
- download zipped data file and unzip
- build data frames for test and training data, subjects
- assign nice column names to xTest and xTrain using the features data frame
- use column binding to connect subject, y, x for test and training
- combine test and training data with row binding
- use gather to turn data frame into tidy table
- using "features" data frame we can use grep to generate another data frame of column names
  that perform mean and standard deviation calcuations
- build new data frame selecting only mean and std measurements from "tidy" data set
- build tidy data set with the average of each variable for each activity and each subject.
- write this data set to a .txt file