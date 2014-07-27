# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# Data Set Information:
  
# The experiments have been carried out with a group of 30 volunteers within an
# age bracket of 19-48 years. Each person performed six activities 
# (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
# wearing a smartphone (Samsung Galaxy S II) on the waist. 
# Using its embedded accelerometer and gyroscope, we captured 3-axial linear 
# acceleration and 3-axial angular velocity at a constant rate of 50Hz. 
# The experiments have been video-recorded to label the data manually. 
# The obtained dataset has been randomly partitioned into two sets, 
# where 70% of the volunteers was selected for generating the training data 
# and 30% the test data. 

# The sensor signals (accelerometer and gyroscope) were pre-processed by 
# applying noise filters and then sampled in fixed-width sliding windows of 
# 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration 
# signal, which has gravitational and body motion components, was separated 
# using a Butterworth low-pass filter into body acceleration and gravity. 
# The gravitational force is assumed to have only low frequency components, 
# therefore a filter with 0.3 Hz cutoff frequency was used. 
# From each window, a vector of features was obtained by calculating 
# variables from the time and frequency domain.

#################################################################################

# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for
#    each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. Creates a second, independent tidy data set with the average of each variable 
#    for each activity and each subject. 

##############################################################################
# 0. Initialization/preparation
# tidy dataset uploaded to coursera can be loaded with 
# x_tidy <- read.table(file = "C:/per/X_tidy.txt", header = TRUE, sep = " ")
# Clear memory
rm(list=ls())

# set working directory
setwd("./UCI HAR Dataset")

##############################################################################
# 1. Merges the training and the test sets to create one data set: X_tot
# read features
features        <- read.table("./features.txt", 
                              stringsAsFactors = FALSE)

# read Test Set
X_test          <- read.table("./test/X_test.txt")
y_test          <- read.table("./test/y_test.txt")
subject_test    <- read.table("./test/subject_test.txt")

# Rename variables 
names(X_test)                                    <- features[, 2]
names(y_test)      [names(y_test)       == "V1"] <- "activity"
names(subject_test)[names(subject_test) == "V1"] <- "subject"

# Add additional column indicating whether it is training data (not requested)
# and Combine the all columns
X_test <- cbind(train = FALSE, subject_test, y_test, X_test)

# Delete obsolete objects
rm(subject_test, y_test)

# read train Set
X_train          <- read.table("./train/X_train.txt")
y_train          <- read.table("./train/y_train.txt")
subject_train    <- read.table("./train/subject_train.txt")

# Rename variables 
names(X_train)                                     <- features[, 2]
names(y_train)      [names(y_train)       == "V1"] <- "activity"
names(subject_train)[names(subject_train) == "V1"] <- "subject"

# Add additional column indicating whether it is training data (not requested)
# and Combine the all columns
X_train <- cbind(train = TRUE, subject_train, y_train, X_train)

# Delete obsolete objects
rm(subject_train, y_train, features)

# Create one data set by row binding Test & Train
X_tot <- rbind(X_test, X_train)

# Delete obsolete objects
rm(X_test, X_train)

# add order Column (not requested)
# Merges the training and the test sets to create one data set: X_tot
X_tot <- cbind(order = seq_along(X_tot[, 1]), X_tot)


###############################################################################
# 2. Extracts only the measurements on the mean and standard deviation for
#    each measurement.
# keep first 4 columns and append all mean/std columns
X_tot <- cbind(X_tot[, 1:4],
               X_tot[, grepl(".*[Mm][Ee][Aa][Nn]|[Ss][Tt][Dd].*", 
                             names(X_tot))]
               )

###############################################################################
# 3. Uses descriptive activity names to name the activities in the data set
# read activity labels
activity_labels <- read.table("./activity_labels.txt", 
                              stringsAsFactors = FALSE)
# rename variables
names(activity_labels) <- c("activity", "activitylabel") 

# merge activitylabels and X_tot for 
X_tot <- merge(activity_labels, X_tot, by = "activity")

# Delete obsolete objects
rm(activity_labels)

###############################################################################
# 4. Appropriately labels the data set with descriptive variable names. 
# Keep only letters in lowercase
names(X_tot) <- gsub("-*\\(*\\)*\\,*", "", names(X_tot))
names(X_tot) <- tolower(names(X_tot))

###############################################################################
# 5. Creates a second, independent tidy data set with the average of each 
#    variable for each activity and each subject. 
X_agg <- aggregate(X_tot[,-(1:5)], 
                   by = list(activitylabel = X_tot$activitylabel,
                              subject      = X_tot$subject),
                   FUN = mean)

###############################################################################
# 6. Write file to upload
write.table(X_agg, file = "C:/per/X_tidy.txt", sep = " ", 
            row.names = FALSE)

codebook        <- as.data.frame(sapply(X_agg, class), stringsAsFactors = FALSE)
names(codebook) <- c("type")

write.table(codebook, file = "C:/per/codebook.txt", sep = " ", 
            row.names = TRUE)
