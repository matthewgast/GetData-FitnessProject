## run_analysis.R
##
## Matthew Gast, May 2015
##
## Course: "Getting and Cleaning Data" at the JHU Bloomberg School of
## Health (Coursera Data Science Specialization).

# Read raw data
training_x <- read.table("UCI HAR Dataset/train/X_train.txt")
training_y <- read.table("UCI HAR Dataset/train/y_train.txt")
training_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
test_x <- read.table("UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Read features
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# Merge test & training data sets
merge_x <- rbind(training_x,test_x)
merge_y <- rbind(training_y,test_y)
merge_subject <- rbind(training_subject,test_subject)

# Making sense of data
names(merge_x) <- features_raw[,2]

# put whole data set together
#  step 1: add subject column
df <- cbind(merge_x,merge_subject)
names(df)[562] <- "subject"
#  step 2: add activity column
df2 <- cbind(df,factor(merge_y[[1]],activities$V1,labels=activities$V2))
names(df2)[563] <- "activity"

# find columns with mean and standard deviation
meanCols <- grepl("mean",names(df2),ignore.case=TRUE)
stdCols <- grepl("std",names(df2),ignore.case=TRUE)
colsToGet <- meanCols | stdCols
#  but also get activity & subject
colsToGet[562] <- TRUE
colsToGet[563] <- TRUE

# reduce data set to only the cols I want
df3 <- df2[,colsToGet]

# This almost works, but it produces two new columns I don't understand
agg.df3 <- aggregate(x=df3,by=list(df3$activity,df3$subject),FUN="mean")


