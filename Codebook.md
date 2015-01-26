---
title: "Codebook for Tidy Data"
author: "VJ"
date: "Sunday, January 25, 2015"
output: word_document
---

## Codebook for the Tidy Data of Averages of the Means & Standard deviations of Each Activities By each Subject from the experiment done to study Human Activity Recognition Using Smartphones Data Set

1.  A full description of the experiement is available at : 
    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

2.  The original data for this project: 
    +https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
    +The Codebook is named features.txt
    +The Additional info on the measurements are given in features_info.txt
    +The Data contains set of files from Training and Test



## Objectives of this task

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Input Data and Observations

1. X_Test and X_train.txt have the measurements & functions performed on them. There are 561 variables and its definition are description are given in features.txt
2. The subject_test.txt and subject_train.txt have the Identifier Code assigned to the Volunteer subjects and corresponds 1-1 to the measurement rows in the X_Test.txt and X_train.txt respectively.
3. The y_Test.txt and y_train.txt files have the records for the Activities performed by the Volunteers during the experiment and corresponds 1-1 to the measurement rows in the X_Test.txt and X_train.txt respectively. The Activity is in Code and their decodes (or labels) are given in activity_labels.txt.
4. There are 2947 rows each in X_test.txt, subject_test.txt and y_test.txt. The rows corresponds one to one between these two files (as-is. ie. unsorted)
5. There are 7352 rows each in X_train.txt, subject_train.txt and y_train.txt. The rows corresponds one to one between these two files (as-is. ie. unsorted) 


## Approach to Tidy the data and meet the Project Objectives

### 1. Merges the training and the test sets to create one data set.
1. Download the Files and Place the data folder UCI HAR Dataset in the Working Directory
2. Read the Test data into R (3 Files specified above)
3. Read the Training data into R (3 Files specified above)
4. Using Column Bind, Combine the Test data (X), the Test labels (Y) and the Test Subject info into one table. Since the number of rows in each of these individual tables are same - 2947 data rows.ie., These files are stacked horizontally to one another. The Result will be 2947 rows but it will have the columns (561+1+1 = 563) from all three files.
5. Using the R, Column Bind function (CBind), Combine the Training data (X), the Training labels (Y) and the Training Subject info into a different table. Since the number of rows in each of these individual tables are same - 7352 data rows. ie., These files are stacked horizontally to one another. The Result will be 7352 rows but it will have the columns (561+1+1 = 563) from all three files.
6. Now append the Files created in step 4. to step.5, ie., stack vertically using Row Bind function (RBind). The resulting file will have 2947 + 7352 = 10299 data rows. The Columns remain same at 563.
7. Read the Column Names Description as a list from the Features.Txt. Change the Column Name of the Combined data (from step #6) to these Desscriptions using LAPPLY R-Function. Also give a descriptive name to the Activity ID & Subject ID.
Example Code -
        features <- read.table("./UCI HAR Dataset/features.txt")
        names(SmartPhActivityData)[1:561]  <- lapply (features$V2, as.character) 
       
        ## Replace the last 2 Column Names (positions 562 & 563) in the Combined    
           SmartPhone Activity Dataset. It is Activity & Subject

        names(SmartPhActivityData)[562:563] <- c("Activity_ID", "Subject_ID")

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
1. Select the Column Names from the Combined SmartPhone Activity Data set having text "Mean()", "std()" and "meanFreq()". These all are direct result of Mean or Standard Deviation application.
2. Use the grep function to scan and find the Column Numbers having the expressions "Mean()", "std()" or "meanFreq()" from the column Names in the Combined SmartPhone Activity Dataset (Step # 1-7)
3. Then extract only those column Numbers from the Combined SmartPhone Activity Data set having text "Mean()","std()"  or "meanFreq()".

###3. Uses descriptive activity names to name the activities in the data set
1. Add a Column Activity to the Extracted Dataset to include the Descriptive activity lable names (like WALKING, SITTING etc) latter to the Combined dataset.
2. Import the Activity Description from the Activity Labels

###4. Appropriately labels the data set with descriptive variable names. 
1. Dump the Column names in the new extracted file from Step #3.
2. Manually Edit and Modify the Variables dumped to Descriptive Variable Names
3. Import the Modified Descriptive Variable Names and Rename the Column Names in the DataFrame with only Mean(), Std() and meanFreq()

###5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

1. Install the "qdapTools" package. The Package has a collection of tools useful outside of the context of text analysis.
2. Use the lookup function in the "qdapTools" library and loookup the matching Activity Labels that matches to the Activity_ID. Populate the match into column Activity in the Extracted Combined dataset from Step#4.
3. Install the "plyr" package. The Package has a collection of tools useful for splitting, applying and combining data.
4. Using the ddply function in plyr library, Summarize the columns in the Extracted Combined dataset (from Step#5-2). The Average is performed on all Numeric Columns. Ie. the Columns with Mean(), Std() and meanFreq() all are Numeric. Find average for for each activity and each subject. 
     Example Code - Extracted_SmartPhActivityData_Summarized <-ddply(Extracted_SmartPhActivityData, .(Activity, Subject_ID), numcolwise(mean))
5. Drop the Activity_ID column.
6. Create a TEXT file of the Summarized data for each activity and each subject.



## Codebook for the SmartPhActivityData_Summarized.txt File

**Field Label:  Activity	**
Variable Description:	Name of the Activity performed by Training or Testing Volunteer	
Variable type:	Factor	
Values or Explanation:	"WALKING
WALKING_UPSTAIRS
WALKING_DOWNSTAIRS
SITTING
STANDING
LAYING"	
		
**Field Label:	Subject_ID	**
Variable Description:	A Number ID assigned to uniquely identify the Volunteer	
Variable type:	Integer	
Values or Explanation:	1 to 30	
		
**Field Label:	TimeDomain_Body_Acceleration_Signal_mean_X	**
Variable Description:	The Average of the Mean of X axis Body Linear Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Body_Acceleration_Signal_mean_Y	**
Variable Description:	The Average of the Mean of Y axis Body Linear Acceleration in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Body_Acceleration_Signal_mean_Z	**
Variable Description:	The Average of the Mean of Z axis Body Linear Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Gravity_Acceleration_Signal_mean_X	**
Variable Description:	The Average of the Mean of X axis Gravity Acceleration in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Gravity_Acceleration_Signal_mean_Y	**
Variable Description:	The Average of the Mean of Y axis Gravity Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Gravity_Acceleration_Signal_mean_Z	**
Variable Description:	The Average of the Mean of Z axis Gravity Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Body_Acceleration_SignalJerk_mean_X	**
Variable Description:	The Average of the Mean of Jerk Signals from X axis Body Linear Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Body_Acceleration_SignalJerk_mean_Y	**
Variable Description:	The Average of the Mean of Jerk Signals from Y axis Body Linear Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Body_Acceleration_SignalJerk_mean_Z	**
Variable Description:	The Average of the Mean of Jerk Signals from Z axis Body Linear Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_Velocity_mean_X	**
Variable Description:	The Average of the Mean of X axis Gyro Angular Velocity in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_Velocity_mean_Y	**
Variable Description:	The Average of the Mean of Y axis Gyro Angular Velocity in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_Velocity_mean_Z	**
Variable Description:	The Average of the Mean of Z axis Gyro Angular Velocity in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_VelocityJerk_mean_X	**
Variable Description:	The Average of the Mean of Jerk Signals from X axis Gyro Angular Velocity in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_VelocityJerk_mean_Y	**
Variable Description:	The Average of the Mean of Jerk Signals from Y axis Gyro Angular Velocity in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_VelocityJerk_mean_Z	**
Variable Description:	The Average of the Mean of Jerk Signals from Z axis Gyro Angular Velocity in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Body_Acceleration_SignalMag_mean	**
Variable Description:	The Average of the Mean of Signal Magnitude from the Body Linear Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Gravity_Acceleration_SignalMag_mean	**
Variable Description:	The Average of the Mean of Signal Magnitude from the Gravity Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Body_Acceleration_SignalJerkMag_mean	**
Variable Description:	The Average of the Mean of Signal Jerk Magnitude from Body Linear Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_VelocityMag_mean	**
Variable Description:	The Average of the Mean of the Angular Velocity from Gyroscope in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_VelocityJerkMag_mean	**
Variable Description:	The Average of the Mean of the Angular Velocity Jerk Magnitude from Gyroscope in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_Signal_mean_X	**
Variable Description:	The Average of the Mean of X axis Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_Signal_mean_Y	**
Variable Description:	The Average of the Mean of Y axis Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_Signal_mean_Z	**
Variable Description:	The Average of the Mean of Z axis Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_SignalJerk_mean_X	**
Variable Description:	The Average of the Mean of Jerk Signals from X axis Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_SignalJerk_mean_Y	**
Variable Description:	The Average of the Mean of Jerk Signals from Y axis Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_SignalJerk_mean_Z	**
Variable Description:	The Average of the Mean of Jerk Signals from Z axis Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_BodyGyro_Angular_Velocity_mean_X	**
Variable Description:	The Average of the Mean of X axis Gyro Angular Velocity in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_BodyGyro_Angular_Velocity_mean_Y	**
Variable Description:	The Average of the Mean of Y axis Gyro Angular Velocity in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_BodyGyro_Angular_Velocity_mean_Z	**
Variable Description:	The Average of the Mean of Z axis Gyro Angular Velocity in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_SignalMag_mean	**
Variable Description:	The Average of the Mean of Signal Magnitude from the Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_SignalJerkMag_mean	**
Variable Description:	The Average of the Mean of Signal Jerk Magnitude from Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_BodyGyro_Angular_VelocityMag_mean	**
Variable Description:	The Average of the Mean of the Angular Velocity from Gyroscope in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_BodyGyro_Angular_VelocityJerkMag_mean	**
Variable Description:	The Average of the Mean of the Angular Velocity Jerk Magnitude from Gyroscope in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Body_Acceleration_Signal_std_X	**
Variable Description:	The Average of the Standard Deviation of X axis Body Linear Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Body_Acceleration_Signal_std_Y	**
Variable Description:	The Average of the Standard Deviation of Y axis Body Linear Acceleration in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Body_Acceleration_Signal_std_Z	**
Variable Description:	The Average of the Standard Deviation of Z axis Body Linear Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Gravity_Acceleration_Signal_std_X	**
Variable Description:	The Average of the Standard Deviation of X axis Gravity Acceleration in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Gravity_Acceleration_Signal_std_Y	**
Variable Description:	The Average of the Standard Deviation of Y axis Gravity Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Gravity_Acceleration_Signal_std_Z	**
Variable Description:	The Average of the Standard Deviation of Z axis Gravity Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Body_Acceleration_SignalJerk_std_X	**
Variable Description:	The Average of the Standard Deviation of Jerk Signals from X axis Body Linear Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Body_Acceleration_SignalJerk_std_Y	**
Variable Description:	The Average of the Standard Deviation of Jerk Signals from Y axis Body Linear Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Body_Acceleration_SignalJerk_std_Z	**
Variable Description:	The Average of the Standard Deviation of Jerk Signals from Z axis Body Linear Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_Velocity_std_X	**
Variable Description:	The Average of the Standard Deviation of X axis Gyro Angular Velocity in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_Velocity_std_Y	**
Variable Description:	The Average of the Standard Deviation of Y axis Gyro Angular Velocity in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_Velocity_std_Z	**
Variable Description:	The Average of the Standard Deviation of Z axis Gyro Angular Velocity in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_VelocityJerk_std_X	**
Variable Description:	The Average of the Standard Deviation of Jerk Signals from X axis Gyro Angular Velocity in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_VelocityJerk_std_Y	**
Variable Description:	The Average of the Standard Deviation of Jerk Signals from Y axis Gyro Angular Velocity in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_VelocityJerk_std_Z	**
Variable Description:	The Average of the Standard Deviation of Jerk Signals from Z axis Gyro Angular Velocity in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Body_Acceleration_SignalMag_std	**
Variable Description:	The Average of the Standard Deviation of Signal Magnitude from the Body Linear Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Gravity_Acceleration_SignalMag-std	**
Variable Description:	The Average of the Standard Deviation of Signal Magnitude from the Gravity Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_Body_Acceleration_SignalJerkMag-std	**
Variable Description:	The Average of the Standard Deviation of Signal Jerk Magnitude from Body Linear Acceleration in Time Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_VelocityMag-std	**
Variable Description:	The Average of the Standard Deviation of the Angular Velocity from Gyroscope in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	TimeDomain_BodyGyro_Angular_VelocityJerkMag-std	**
Variable Description:	The Average of the Standard Deviation of the Angular Velocity Jerk Magnitude from Gyroscope in Time Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_Signal-std-X	**
Variable Description:	The Average of the Standard Deviation of Jerk Signals from X axis Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_Signal-std-Y	**
Variable Description:	The Average of the Standard Deviation of Jerk Signals from Y axis Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_Signal-std-Z	**
Variable Description:	The Average of the Standard Deviation of Jerk Signals from Z axis Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_SignalJerk-std-X	**
Variable Description:	The Average of the Standard Deviation of X axis Gyro Angular Velocity in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_SignalJerk-std-Y	**
Variable Description:	The Average of the Standard Deviation of Y axis Gyro Angular Velocity in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_SignalJerk-std-Z	**
Variable Description:	The Average of the Standard Deviation of Z axis Gyro Angular Velocity in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_BodyGyro_Angular_Velocity-std-X	**
Variable Description:	The Average of the Standard Deviation of X axis Gyro Angular Velocity in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_BodyGyro_Angular_Velocity-std-Y	**
Variable Description:	The Average of the Standard Deviation of Y axis Gyro Angular Velocity in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_BodyGyro_Angular_Velocity-std-Z	**
Variable Description:	The Average of the Standard Deviation of Z axis Gyro Angular Velocity in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_SignalMag-std	**
Variable Description:	The Average of the Standard Deviation of Signal Magnitude from the Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_SignalJerkMag-std	**
Variable Description:	The Average of the Standard Deviation of Signal Jerk Magnitude from Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_BodyGyro_Angular_VelocityMag-std	**
Variable Description:	The Average of the Standard Deviation of the Angular Velocity from Gyroscope in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_BodyGyro_Angular_VelocityJerkMag-std	**
Variable Description:	The Average of the Standard Deviation of the Angular Velocity Jerk Magnitude from Gyroscope in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_Signal-meanFreq-X	**
Variable Description:	The Average of the Mean Frequency of Jerk Signals from X axis Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_Signal-meanFreq-Y	**
Variable Description:	The Average of the Mean Frequency of Jerk Signals from Y axis Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_Signal-meanFreq-Z	**
Variable Description:	The Average of the Mean Frequency of Jerk Signals from Z axis Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_SignalJerk-meanFreq-X	**
Variable Description:	The Average of the Mean Frequency of X axis Gyro Angular Velocity in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_SignalJerk-meanFreq-Y	**
Variable Description:	The Average of the Mean Frequency of Y axis Gyro Angular Velocity in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_SignalJerk-meanFreq-Z	**
Variable Description:	The Average of the Mean Frequency of Z axis Gyro Angular Velocity in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_BodyGyro_Angular_Velocity-meanFreq-X	**
Variable Description:	The Average of the Mean Frequency of the X axis Angular Velocity from Gyroscope in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_BodyGyro_Angular_Velocity-meanFreq-Y	**
Variable Description:	The Average of the Mean Frequency of the Y axis Angular Velocity from Gyroscope in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_BodyGyro_Angular_Velocity-meanFreq-Z	**
Variable Description:	The Average of the Mean Frequency of the Z axis Angular Velocity from Gyroscope in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_SignalMag-meanFreq	**
Variable Description:	The Average of the Mean Frequency of Signal Magnitude from the Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_Body_Acceleration_SignalJerkMag-meanFreq	**
Variable Description:	The Average of the Mean Frequency of Signal Jerk Magnitude from Body Linear Acceleration in Frequency Domain for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_BodyGyro_Angular_VelocityMag-meanFreq	**
Variable Description:	The Average of the Mean Frequency of the Angular Velocity from Gyroscope in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	
		
**Field Label:	FreqDomain_BodyGyro_Angular_VelocityJerkMag-meanFreq	**
Variable Description:	The Average of the Mean Frequency of the Angular Velocity Jerk Magnitude from Gyroscope in Frequency Domain  for Each Activity Performed by the Subject	
Variable type:	Numeric	
Values or Explanation:	Range -1 to +1	



