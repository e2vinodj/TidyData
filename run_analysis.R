
#####################################################################################
## 1. Merges the training and the test sets to create one data set.
######################################################################################

## Ensure the Samsung data folder "UCI HAR Dataset" is in the Working Directory
## Read the data from Tests into a table 
   
TestXdata <- read.table("UCI HAR Dataset/test/X_test.txt",header = FALSE,sep ="")
TestYdata <- read.table("UCI HAR Dataset/test/y_test.txt",header = FALSE,sep ="")
TestSubdata <- read.table("UCI HAR Dataset/test/subject_test.txt",header = FALSE,sep ="")

## Combine the Test data (X), the Test labels (Y) and the Subject info into one table. 
## Note that the number of rows in each of these individual tables are same - 2947 data rows

CombTestdata <- cbind(TestXdata, TestYdata,TestSubdata)

## Read the data from Training into a table 

TrainXdata <- read.table("UCI HAR Dataset/Train/X_Train.txt",header = FALSE,sep ="")
TrainYdata <- read.table("UCI HAR Dataset/Train/y_Train.txt",header = FALSE,sep ="")
TrainSubdata <- read.table("UCI HAR Dataset/Train/subject_Train.txt",header = FALSE,sep ="")

## Combine the Training data (X), the Training labels (Y) and the Training Subject info into one table. 
## Note that the number of rows in each of these individual tables are same - 7352 data rows

CombTraindata <- cbind(TrainXdata, TrainYdata,TrainSubdata)

## Join the Test & Training data into one table - Combined SmartPhone Activity dataset
## Note that the number of rows will be now  2947 + 7352 = 10299 data rows

SmartPhActivityData <- rbind(CombTestdata, CombTraindata)


## Replace Column Names in the Combined SmartPhone Activity dataset. 
## The First 561 columns are of the Xdata as defined in Features.txt
## Apply the Column Names described in Features to add to the Combined SmartPhone Activity Dataset

features <- read.table("./UCI HAR Dataset/features.txt")
names(SmartPhActivityData)[1:561]  <- lapply (features$V2, as.character) 

## Replace the last 2 Column Names (positions 562 & 563) in the Combined SmartPhone Activity Dataset. It is Activity & Subject

names(SmartPhActivityData)[562:563] <- c("Activity_ID", "Subject_ID")

######################################################################################
##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#####################################################################################


## Select the Column Names from the Combined SmartPhone Activity Data set having text "Mean()","std()" and "meanFreq()"
## Use the grep function to scan and find them from column Names in the Combined SmartPhone Activity Dataset

Select_Mean_Std_cols <- c(grep("mean()",names(SmartPhActivityData), fixed = TRUE),grep("std()", names(SmartPhActivityData), fixed = TRUE),grep("meanFreq()", names(SmartPhActivityData), fixed = TRUE))

## Extract only the columns from the Combined SmartPhone Activity Data set having text "Mean()" and "std()"

Extracted_SmartPhActivityData <- SmartPhActivityData[,c(Select_Mean_Std_cols,562,563,562)]




######################################################################################
##3. Uses descriptive activity names to name the activities in the Combined SmartPhone Activity data set
######################################################################################

## Add a Column Activity to the Extracted Dataset to include the Descriptive activity names
## Import the Activity Description from the Activity Labels

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activity_labels)[1:2] <- c("Activity_ID", "Activity_Description")
names(Extracted_SmartPhActivityData)[82] <- "Activity"

######################################################################################
##4. Appropriately labels the data set with descriptive variable names. 
######################################################################################

# write.table(Extracted_SmartPhActivityData[0,], "Extracted_SmartPhActivityData.txt",row.name=FALSE)

# Edit and Modify the Variables dumped to Descriptive Variable Names
# Import the Modified Descriptive Variable Names and Rename the Column Names in the DataFrame with only Mean() & Std()

Modified_features <- read.table("Modified_features.txt")
names(Extracted_SmartPhActivityData)[1:82]  <- lapply (Modified_features$V1, as.character) 



######################################################################################
##5. From the data set in step 4, creates a second, independent tidy data set with 
##   the average of each variable for each activity and each subject.
######################################################################################


## Need to install Package only once.
## The Package has a collection of tools useful outside of the context of text analysis.

# install.packages("qdapTools")
library('qdapTools') ###---- Install the qdapTools package if not already. Uncomment and Run the above Install lines.

Extracted_SmartPhActivityData$Activity <- lookup(Extracted_SmartPhActivityData$Activity_ID, activity_labels[, 1:2])


## Need to install Package only once.
## The Package has tools for splitting, applying and combining data

#install.packages('plyr')
library('plyr') ###---- Install the plyr package if not already.  Uncomment and Run the above Install lines.

## Average of each variable for each activity and each subject.
Extracted_SmartPhActivityData_Summarized <-ddply(Extracted_SmartPhActivityData, .(Activity, Subject_ID), numcolwise(mean))

## Drop the Activity_ID. The Activity Description is Present
Extracted_SmartPhActivityData_Summarized$Activity_ID <- NULL

## Create a TEXT file of the Summarized data for each activity and each subject
write.table(Extracted_SmartPhActivityData_Summarized,"SmartPhActivityData_Summarized.txt",row.name=FALSE)

