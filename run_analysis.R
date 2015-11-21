#Open row names from features.txt
feas <- read.table("UCI HAR Dataset/features.txt",colClasses = "character")

#Open train files
trainSub<-read.table("UCI HAR Dataset/train/subject_train.txt")
trainLab<-read.table("UCI HAR Dataset/train/Y_train.txt")
trainDat<-read.table("UCI HAR Dataset/train/X_train.txt", col.names = feas$V2)

#add subject and activity label columns to training set
#as I understand, the variables are kept in order across tables so 
#there is no need for more complicated merges.
trainDat$subID <- trainSub$V1
trainDat$Activ <- trainLab$V1

#Open test files
testSub<-read.table("UCI HAR Dataset/test/subject_test.txt")
testLab<-read.table("UCI HAR Dataset/test/Y_test.txt")
testDat<-read.table("UCI HAR Dataset/test/X_test.txt",col.names = feas$V2)

#add subject ID and activity label columns to training set
#see comment above regarding row order
testDat$subID <- testSub$V1
testDat$Activ <- testLab$V1

#combine training and test sets
#training and test sets are separate, so a simple rbind will work.
allDat <- rbind(trainDat, testDat)

#load library
library(dplyr)

#extract just the mean and StdDev variables
#is there something better than brute force?
#allMeanStd <- select(allDat,c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,
#                              227:228,240:241,253:254,266:271,345:350,424:429,
#                              503:504,516:517,529:530,542:543))
#yes, use select with "contains"
#using "mean.." and matching case gets just the mean columns and skips
#variables with Mean in their name.
allMeanStd <- select(allDat, subID, Activ,
                     contains("mean..",ignore.case=FALSE),
                     contains("std..",ignore.case=FALSE))

#Give a descriptive name to each activity (already stored in Activ)
#use the mutate function to make a new variable with text corresponding to 
#the levels.
allMeanStd <- mutate(allMeanStd, actName = factor(allMeanStd$Activ, 
                     labels=c("Walking","Walking_Upstairs","Walking_Downstairs",
                              "Sitting","Standing","Laying")))

#use pipelined group_by and summarize_each to get the mean 
#for each activity/subject pair
final <- allMeanStd %>% group_by(actName,subID) %>% summarize_each(funs(mean))

#write out the table
write.table(final,file="TidyAssign.txt",row.names=FALSE)
