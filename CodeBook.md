# Code Book for Smartphone Activity Assignment

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

## Global Environment Variables

1.  Global variables holding the raw data.  These variables are instantiated in the `readData()` function, and are treated as global constants during the processing stage.
    + `x.train` and `x.test`: these are data frames holding the training and test data, respectively, for the 561 measurements collected by smartphones in the experiment.
    + `y.train` and `y.test`: these are coded numbers representing the activity for each measurement (walking, walking up stairs, lying down, and so on).
    + `sub.train` and `sub.test`: these hold the subject number who performed the activity resulting in the measurements in the previous two variables.
    + `features` contains the names of the 561 different measurements in the data set
    + `activities` maps the number of the activity in the `y.train` and `y.test` into text labels.
2.  Global variables containing processed data
    + `merged` is a single data frame containing all observations from both the test and training set, and associates each measurement with a subject number and an activity label.
    + `reduced` is a data frame containing merged data, but only contains the columns with measurements that are either means or standard deviations.  It has 86 columns of measurements, plus the identification of subject and activity.
    + `analyzed` is a data frame which further processes the reduced data by taking the mean of all measurements from each unique (subject+activity) pair.  If, for example, there were five measurements by subject #1 on the activity of walking, the `analyzed` frame would take the mean of each column in all five measurements.  Because there are 30 subjects and 6 activities, the `analyzed` frame has 180 rows (30 * 6).
3.  Additional local variables are used in each of the utility functions, but they are not directly accessed from the global environment.

## Processing the Data

1. In the `readData()` function, all data is read from the disk.  Data is expected to be in the same directory as the function resides, though the directory location can be passed as an argument to the function.
   + Training and test measurement data, in the "x" variables is read, obtaining all measurements across  561 points.
   + Training and test activity type, representing one of six states, is read into the "y" variables
   + Training and test subject data, a number between 1 and 30, is read
   + Metadata also read.  This is the mapping of activity type number to activity, such as the number "1" to "WALKING".  The names of the 561 features are also read.
2. In the `mergeData()` function, the test and training data are merged
   + Test data (gyro/accel + activity + subject) is appended to training data
   + Activity numbers are replaced with words
   + The columns containing the 561 measurements are labeled with words
   + In total, there are over 10,000 measurements
3. In the `reduceData()` function, the data are filtered as directed by the assignment and saved into the `reduced` data frame.  Only measurements that are means or standard deviations are retained, by using the `grepl` function to search for columns containing the text "mean" or "std".  Other measurements are discarded.  Only 86 columns match the description.
4.  The analysis is carried out.  The data are grouped by both activity and subject, and a mean of all measurements is saved in the `analyzed` data frame.  With 30 subjects and 6 activities, this reduces the measurements to only 180.
5.  The tidy data in the `analyzed` data frame is written to disk.
