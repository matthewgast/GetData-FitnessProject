# Code Book for Smartphone Activity Assignment

## Introduction

This is the story...

...of a script named `run_analysis.R`

...and its very lovely input and output

a code book that describes the variables, the data, and any
transformations or work that you performed to clean up the data called
CodeBook.md. 

## The Variables


## The Data

This data was collected by the [UC Irvine Human Activity Recognition
dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
It is split into two parts: a "training" set and a "test" set, each
comprising a part of the data, with 71% of the data in the "training"
set.

The data itself spans three files.

- One file (the "X" file) contains measurements from the phone sensors
  (accelerometer and gyroscope).
- A second file (the "y" file) contains the activity label, describing
  the activity, which may be one of six activities such as walking,
  sitting, standing...
- A third file (the "subject" file) that describes the test subject
  who collected the measurements.

The analysis script assumes the data is stored in a subdirectory
called `UCI HAR Dataset`.  The script user must download the data and
place it in the same directory as the script, or pass the `directory`
argument to the `readData()` function to enable the script to locate
the data.

## Cleaning the Data

1. Data is read
   + Training and test measurement data (561 variables!)
   + Training and test activity type (one of six states)
   + Training and test subject (number between 1 & 30)
   + Metadata also read.  This is the mapping of activity type number to activity, such as the number "1" to "WALKING".  The names of the 561 features are also read.
2. Data is merged
   + Test data (gyro/accel + activity + subject) is appended to training data
   + Activity numbers are replaced with words
   + The 561 measurements are replaced with names
   + In total, there are over 10,000 measurements
3. Data is filtered as directed by the assignment.  Only measurements that are means or standard deviations are retained.  Others are discarded.
4.  The analysis is carried out.  The data are grouped by both activity and subject, and a mean of all measurements is saved.  With 30 subjects and 6 activities, this reduces the measurements to only 180.
5.  The tidy data from step 4 is written to disk.
