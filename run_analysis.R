## run_analysis.R
##
## Matthew Gast, May 2015
##
## Course: "Getting and Cleaning Data" at the JHU Bloomberg School of
## Health (Coursera Data Science Specialization).

readData <- function (directory) {
    cwd <- getwd()

    if (missing(directory)) {
        directory <- "/Users/mgast/Dropbox/data-science-specialization/3-getting-cleaning-data/GetData-FitnessProject"
    }
    setwd(directory)

    # TODO: test that all these exist before reading
    
    # Read raw data - training
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

    # Read raw data - test
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

    #Read column names and feature number-to-name mapping
    message("Reading features and activity metadata")
    features <<- read.table("UCI HAR Dataset/features.txt")
    activities <<- read.table("UCI HAR Dataset/activity_labels.txt")
    names(activities) <<- c("number","name")
    
    setwd(cwd)
    message("Read complete")
    # No return required because variables are global
}

mergeData <- function () {
    # Merge test & training data sets
    mdf.x <- rbind(x.train,x.test)
    mdf.activities <- rbind(y.train,y.test)
    mdf.sub <- rbind(sub.train,sub.test)

    # Add subject & activity columns to merged data set
    #    - Note: rewrite activity number with named factor
    mdf <- cbind(mdf.sub,
                 factor(mdf.activities[[1]],
                        activities$number,
                        labels=activities$name),
                 mdf.x)
    names(mdf) <- c("subject","activity",as.character(features[,2]))

    return(mdf)
}

reduceData <- function (mdf) {
    # Step 1: reduce data: find cols w/ "mean" or "std"
    mean.cols <- grepl("mean",names(mdf),ignore.case=TRUE)
    std.cols <- grepl("std",names(mdf),ignore.case=TRUE)

    # For reduction purposes, we also need subject and activity
    sub.col <- grepl("subject",names(mdf),ignore.case=TRUE)
    act.col <- grepl("activity",names(mdf),ignore.case=TRUE)

    cols.to.get <- mean.cols | std.cols | sub.col | act.col

    # reduce data set to only the cols I want
    rdf <- mdf[,cols.to.get]
    rdf
}

analyzeData <- function (df) {
    # This almost works, but it produces two new columns I don't understand
    adf <- aggregate(. ~ activity+subject,data=reduced,FUN="mean")
    adf
}

runAnalysis <- function () {
    readData()
    merged <- mergeData()

    reduced <- reduceData(merged)
    analyzed <- analyzeData(reduced)
}





