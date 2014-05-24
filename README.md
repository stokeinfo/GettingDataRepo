#GettingDataRepo
===============

##Repo for Getting and Cleaning Data 

run_analysis.R is a file for taking raw data from accelerometer sensors on Samsung Galaxy smartphones and formatting the data so that it is in a tidy format fit for later analysis. It performs the following, as per the instructions on the Getting and Cleaning Data coursera website.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

The code, along with descriptive comments are show below:

###Part 1: Merges the training and the test sets to create one data set.
###loading test files
```S
x_test <- read.table("./UCI_HAR_Dataset/test/X_test.txt")
y_test <- read.table("./UCI_HAR_Dataset/test/y_test.txt")
subject_test <- read.table("./UCI_HAR_Dataset/test/subject_test.txt")
```
###loading train files
```S
x_train <- read.table("./UCI_HAR_Dataset/train/X_train.txt")
y_train <- read.table("./UCI_HAR_Dataset/train/y_train.txt")
subject_train <- read.table("./UCI_HAR_Dataset/train/subject_train.txt")
```
###loading features
features <- read.table("./UCI_HAR_Dataset/features.txt")

###Now use rbind to combine x_train and x_test
```S
x <- rbind(x_train, x_test)
```

###Name the columns with the names in features
```S
colnames(x) <- features$V2
```

###Now use rbind to combine y_train and y_test and change the column name to activity
```S
y <- rbind(y_train, y_test)
colnames(y) <- "activity"
```

###Now use rbind to combine subject_train and subject_test and change the column name to subject
```S
subject <- rbind(subject_train, subject_test)
colnames(subject) <- "subject"
```

###Now cbind all the data (x, y, and subject) together
```S
df <- cbind(x,y,subject)
```

###Part 2: Extracts only the measurements on the mean and standard deviation for each measurement. 

###We can now use grep to extract all the column names that have mean and std in them...
```S
meanindex <- grep("mean\\(",names(df))
stdindex <- grep("std", names(df))
```
###Then combine the column names into one index and subset the data based on the index
```S
colindex <- c(meanindex, stdindex)
df2 <- df[, colindex]
```
###However df2 is now missing the subject and activity columns so cbind again...
```S
df2 <- cbind(df2,y,subject)
str(df2)
```
###Part 3: Uses descriptive activity names to name the activities in the data set
###Load the activity_labels.txt document
```S
activity <- read.table("./UCI_HAR_Dataset/activity_labels.txt")
```
###Add in a empty column to later fill via logical indexing with the labels based on the numerical values in df2$activity.
```S
df2$activity.labels <- NA
df2$activity.labels[df2$activity == 1] <- as.character(activity[1,2])
df2$activity.labels[df2$activity == 2] <- as.character(activity[2,2])
df2$activity.labels[df2$activity == 3] <- as.character(activity[3,2])
df2$activity.labels[df2$activity == 4] <- as.character(activity[4,2])
df2$activity.labels[df2$activity == 5] <- as.character(activity[5,2])
df2$activity.labels[df2$activity == 6] <- as.character(activity[6,2])
```

###Part 4 was alread completed above

###Part 5: Creates a second, independent tidy data set with the average of each variable for each activity and subject

###We can use a combination of melt from the Reshape2 package along with ddply from the plyr package to produce the final tidy data set

###First we use melt() which takes column wise variables in df2 and creates a row wise melted dataframe. 
```S
library(Reshape2)
melted <- melt(df2, id=c("subject", "activity.labels"))
```
###Next use ddply to compute the mean for each variable and return a new dataframe that is our final tidy data set.
```S
library(plyr)
df3 <- ddply(melted, .(subject, activity.labels, variable), summarise, mean = mean(value))
```
### Final step! Writting df3 to TidyData.txt for upload.
```S
write.table(df3, "TidyData.txt", sep="\t", row.names=FALSE)
```
