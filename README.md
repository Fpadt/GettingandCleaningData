GettingandCleaningData
======================

Course Project
##############################################################################
# 01. Merges the training and the test sets to create one data set: X_tot
# 02. read features
# 03. read Test Set
# 04. rename variables 
# 05. Add additional column indicating whether it is training data (not requested)
# 06. and Combine the all columns
# 07. Delete obsolete objects
# 08. Repeat the steps 3-7 for the train data set
# 09. read Train Set
# 10. Rename variables 
# 11. Add additional column indicating whether it is training data (not requested)
# 12. and Combine the all columns
# 13. Delete obsolete objects
# 14. Create one data set by row binding Test & Train
# 15. Delete obsolete objects
# 16. add order Column (not requested), can be used to order the file in the original order
# 17. Merges the training and the test sets to create one data set: X_tot

###############################################################################
# 21. Extracts only the measurements on the mean and standard deviation for
#     each measurement from the X_tot data.frame
# 22. keep first 4 columns created in former coding and append all mean/std columns

###############################################################################
# 31. Uses descriptive activity names to name the activities in the data set
# 32. read activity labels
# rename variables
# merge activitylabels and X_tot for 
# Delete obsolete objects

###############################################################################
# 41. Appropriately labels the data set with descriptive variable names. 
# 42. Keep only letters in lowercase
names(X_tot) <- gsub("-*\\(*\\)*\\,*", "", names(X_tot))
names(X_tot) <- tolower(names(X_tot))

###############################################################################
# 51. Creates a second, independent tidy data set with the average of each 
#     variable for each activity and each subject. 

###############################################################################
