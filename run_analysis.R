## run_analysis.R
##
## Matthew Gast, May 2015
##
## Course: "Getting and Cleaning Data" at the JHU Bloomberg School of
## Health (Coursera Data Science Specialization).
##
## This file analyzes the smartphone activity data for the second
## course project in the class.

readData <- function (directory) {
# This function reads the smartphone data, spread across several
# files, into a set of global variables.  These variables are treated
# as a constant by subsequent functions.
#
# Input:  A directory to read the two data files from.
# Output: None, but all data in the specified subdirectory is available to
#         the following routines.

    if (missing(directory)) {
        directory <- "/Users/mgast/Dropbox/data-science-specialization/3-getting-cleaning-data/GetData-FitnessProject"
    }
    # Save working directory before changing
    cwd <- getwd()
    setwd(directory)

    # Read training files.  As these are quite large, check to see if they
    # exist before reading them into the global environment.
    if (!exists("x.train",where=globalenv())) {
        message("Reading training data")
        x.train <<- read.table("UCI HAR Dataset/train/X_train.txt")
    }
    if (!exists("y.train",where=globalenv())) {
        message("Reading training activities")
        y.train <<- read.table("UCI HAR Dataset/train/y_train.txt")
    }
    if (!exists("sub.train",where=globalenv())) {
        message("Reading training subjects")
        sub.train <<- read.table("UCI HAR Dataset/train/subject_train.txt")
    }

    # Read test files.  For the purpose of this exercise, they are identical
    # in form to the training files.
    if (!exists("x.test",where=globalenv())) {
        message("Reading test data")
        x.test <<- read.table("UCI HAR Dataset/test/X_test.txt")
    }
    if (!exists("y.test",where=globalenv())) {
        message("Reading test activities")
        y.test <<- read.table("UCI HAR Dataset/test/y_test.txt")
    }
    if (!exists("sub.test",where=globalenv())) {
        message("Reading test subjects")
        sub.test <<- read.table("UCI HAR Dataset/test/subject_test.txt")
    }

    # Finally, read metadata.  There are 561 variables in the data set,
    # and names should appear automatically.
    message("Reading features and activity metadata")
    features <<- read.table("UCI HAR Dataset/features.txt")
    activities <<- read.table("UCI HAR Dataset/activity_labels.txt")
    names(activities) <<- c("number","name")
    
    setwd(cwd)
    message("Read complete")
    # No return required because variables are global
}

mergeData <- function () {
# This function merges test and training data into one data set.
#
# Input:  There is no explicit input, as the function reads from the
#         global environment.  (If implemented on a computer with low
#         resources, the global variables should be deallocated in this
#         function.
# Output: A data frame containing both test and training data, identified
#         by test subject and the activity the test subject was taking.
    
    # Merge test & training data sets.  Always put training before test
    # to preserve order
    mdf.x <- rbind(x.train,x.test)
    mdf.activities <- rbind(y.train,y.test)
    mdf.sub <- rbind(sub.train,sub.test)

    # Now, put all of the data in columns.  Start with test subject and
    # add activity (but rewrite activity from number to name).  Finally,
    # add all 561 variables.
    mdf <- cbind(mdf.sub,
                 factor(mdf.activities[[1]],
                        activities$number,
                        labels=activities$name),
                 mdf.x)
    names(mdf) <- c("subject","activity",as.character(features[,2]))

    return(mdf)
}

reduceData <- function (mdf) {
# This function eliminates extraneous data that is not of interest.  In
# this assignment, only measurements that are means or standard deviations
# are of interest.
#
# Input:  A data frame containing many types of smartphone activity
#         observations.
# Output: A data frame containing only activity measurements that are either
#         means or standard deviations.
    
    # Find columns with names containing either "mean" or "std"
    mean.cols <- grepl("mean",names(mdf),ignore.case=TRUE)
    std.cols <- grepl("std",names(mdf),ignore.case=TRUE)

    # Retain subject and activity columns because we pivot on those
    sub.col <- grepl("subject",names(mdf),ignore.case=TRUE)
    act.col <- grepl("activity",names(mdf),ignore.case=TRUE)

    cols.to.get <- mean.cols | std.cols | sub.col | act.col
    rdf <- mdf[,cols.to.get]
    rdf
}

analyzeData <- function (df) {
# This function calculates the desired measurements of the data.  For each
# subject and activity, it returns the average of all measurements for the
# subject/activity pair.
#
# Input:  A data frame containing a series of measurements to be averaged.
# Output: A data frame with the average of all measurements for the activity/
#         subject pair.
    
    adf <- aggregate(. ~ activity+subject,data=df,FUN="mean")
    adf
}

writeData <- function(df, filename, directory) {
# This function writes a data frame in the required format for the assignment.
#
# Input:  A data frame, filename, and an optional directory to write the
#         data to.
# Output: There is no output from the function, but it writes the data to
#         the specified location.

    if (missing(directory)) {
        directory <- "/Users/mgast/Dropbox/data-science-specialization/3-getting-cleaning-data/GetData-FitnessProject"
    }
    cwd <- getwd()
    setwd(directory)

    write.table(df,filename,row.names=FALSE)

    setwd(cwd)
}

runAnalysis <- function () {
# This function runs the assignment.
#
# Input:  The data files in the same directory.
# Output: A text file with averages computed as required by the assignment.

    readData()
    merged <- mergeData()

    reduced <- reduceData(merged)
    analyzed <- analyzeData(reduced)

    writeData(analyzed,"uci.tidy.txt")
}





