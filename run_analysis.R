#!/usr/bin/R
library(data.table)
print("reading all data into variables")
subjtst <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subjtrn<- read.table("./UCI HAR Dataset/train/subject_train.txt")

Xtst<- read.table("./UCI HAR Dataset/test/X_test.txt")
Xtrn<- read.table("./UCI HAR Dataset/train/X_train.txt")

Ytst<- read.table("./UCI HAR Dataset/test/y_test.txt")
Ytrn<- read.table("./UCI HAR Dataset/train/y_train.txt")

#act<- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
# Let's name the various activities
print("Naming variables")
Ytst$V1[Ytst$V1==1]<- "WALKING"
Ytst$V1[Ytst$V1==2]<- "WALKING_UPSTAIRS"
Ytst$V1[Ytst$V1==3]<- "WALKING_DOWNSTAIRS"
Ytst$V1[Ytst$V1==4]<- "SITTING"
Ytst$V1[Ytst$V1==5]<- "STANDING"
Ytst$V1[Ytst$V1==6]<- "LAYING"


Ytrn$V1[Ytrn$V1==1]<- "WALKING"
Ytrn$V1[Ytrn$V1==2]<- "WALKING_UPSTAIRS"
Ytrn$V1[Ytrn$V1==3]<- "WALKING_DOWNSTAIRS"
Ytrn$V1[Ytrn$V1==4]<- "SITTING"
Ytrn$V1[Ytrn$V1==5]<- "STANDING"
Ytrn$V1[Ytrn$V1==6]<- "LAYING"

print("creating full data set")
#Let's create a full data set now
Xdata<- rbind(Xtst, Xtrn)
names(Xdata)<- features$V2
Activity<- rbind(Ytst, Ytrn)
Subject<- rbind(subjtst, subjtrn)
Data<- cbind(Xdata, Activity, Subject)
names(Data)[562]<- paste("Activity")
names(Data)[563]<- paste("Subject")

# Since we combined the data sets we will have some duplicated column names:
#which(duplicated(names(Data)))
#length(which(duplicated(names(Data))))

# We should add a X Y or Z to the duplicatd columns to separate them from each other.
# Batch 1
for (n in 303:316) {
  colnames(Data)[n] <- paste(colnames(Data)[n], "X", sep="")
}
for (n in 317:330) {
  colnames(Data)[n] <- paste(colnames(Data)[n], "Y", sep="")
}
for (n in 331:344) {
  colnames(Data)[n] <- paste(colnames(Data)[n], "Z", sep="")
}

# Batch 2
for (n in 382:395) {
  colnames(Data)[n] <- paste(colnames(Data)[n], "X", sep="")
}
for (n in 396:409) {
  colnames(Data)[n] <- paste(colnames(Data)[n], "Y", sep="")
}
for (n in 410:423) {
  colnames(Data)[n] <- paste(colnames(Data)[n], "Z", sep="")
}
# Batch 3

for (n in 461:474) {
  colnames(Data)[n] <- paste(colnames(Data)[n], "X", sep="")
}
for (n in 475:488) {
  colnames(Data)[n] <- paste(colnames(Data)[n], "Y", sep="")
}
for (n in 489:502) {
  colnames(Data)[n] <- paste(colnames(Data)[n], "Z", sep="")
}

# The purpose is to tidy things up, lets make the names of the variables proper R names
colnames(Data) <- gsub('\\(|\\)',"",names(Data), perl = TRUE)
colnames(Data) <- gsub('\\-',"",names(Data), perl = TRUE)
colnames(Data) <- gsub('\\,',"",names(Data), perl = TRUE)

#Subsetting the full Data to obtain only the measurements on the mean and standard deviation for each measurement:
#meancols <- grep("[Mm]ean", colnames(Data), value=TRUE)
#stdcols <- grep("[Ss]td", colnames(Data), value=TRUE)
meanColNum<- grep("[Mm]ean", colnames(Data))
stdColNum<- grep("[Ss]td", colnames(Data))
subData<- Data[, c(meanColNum, stdColNum, 562, 563)]

#Obtaining the average of each variable for each subject and each activity:

dt<- data.table(subData)
meanData<- dt[, lapply(.SD, mean), by=c("Subject", "Activity")]
meanData<- meanData[order(meanData$Subject),]

#Exporting data into a .txt file:
write.table(meanData, "TidyaveData.txt", sep="\t")
