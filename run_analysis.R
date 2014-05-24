#Getting and Cleaning Data Project Script
setwd("C:/Users/Jonathan/Desktop/R Files/GettingData/project")

###Part 1 Merges the training and the test sets to create one data set.
#loading test files
x_test <- read.table("./UCI_HAR_Dataset/test/X_test.txt")
y_test <- read.table("./UCI_HAR_Dataset/test/y_test.txt")
subject_test <- read.table("./UCI_HAR_Dataset/test/subject_test.txt")

##loading train files
x_train <- read.table("./UCI_HAR_Dataset/train/X_train.txt")
y_train <- read.table("./UCI_HAR_Dataset/train/y_train.txt")
subject_train <- read.table("./UCI_HAR_Dataset/train/subject_train.txt")
#loading features
features <- read.table("./UCI_HAR_Dataset/features.txt")

#inspecting
str(x_test)
str(y_test)
str(subject_test)
str(x_train)
str(y_train)
str(subject_train)
str(features)

#rbind x_train and x_test
x <- rbind(x_train, x_test)
dim(x)
head(x)

#naming columns by features as in Davids diagram on the forums
colnames(x) <- features$V2
names(x[1:5])
#rbind y_train and y_test
y <- rbind(y_train, y_test)
colnames(y) <- "activity"
dim(y)

#rbind subject
subject <- rbind(subject_train, subject_test)
colnames(subject) <- "subject"
dim(subject)

#now cbind all the data together
df <- cbind(x,y,subject)
head(df)

###Part 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
names(df)
#use grep to extract col names that have mean and std in them...
meanindex <- grep("mean\\(",names(df))
stdindex <- grep("std", names(df))
length(meanindex)
length(stdindex)

colindex <- c(meanindex, stdindex)

df2 <- df[, colindex]
dim(df2)
#however df2 is now missing the subject and activity columns so cbind again
df2 <- cbind(df2,y,subject)
str(df2)

###Part 3 Uses descriptive activity names to name the activities in the data set
activity <- read.table("./UCI_HAR_Dataset/activity_labels.txt")
df2$activity.labels <- NA
df2$activity.labels[df2$activity == 1] <- as.character(activity[1,2])
df2$activity.labels[df2$activity == 2] <- as.character(activity[2,2])
df2$activity.labels[df2$activity == 3] <- as.character(activity[3,2])
df2$activity.labels[df2$activity == 4] <- as.character(activity[4,2])
df2$activity.labels[df2$activity == 5] <- as.character(activity[5,2])
df2$activity.labels[df2$activity == 6] <- as.character(activity[6,2])

###Part 4: already completed in Part 1 and 3 above

###Part 5: use ddply...

melted <- melt(df2, id=c("subject", "activity.labels"))
library(plyr)
df3 <- ddply(melted, .(subject, activity.labels, variable), summarise, mean = mean(value))
#write df3 to TidyData.txt
write.table(df3, "TidyData.txt", sep="\t", row.names=FALSE)
