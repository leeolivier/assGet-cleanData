#download data
filename<- "getAndCleanData"
if(!file.exists(filename)){#check if data set exists
  fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method = "curl")
}
if(!file.exists("UCI HAR Dataset")){#check if folder exists
  unzip(filename)
}
# labels for data set, col and rows
features<-read.table("UCI HAR Dataset/features.txt", col.names= c("n", "functions"))
activities<-read.table("UCI HAR Dataset/activity_labels.txt", col.names= c("code", "activity"))
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test<-read.table("UCI HAR Dataset/test/X_test.txt", col.names= features$functions)
y_test<-read.table("UCI HAR Dataset/test/y_test.txt", col.names= "code")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt", col.names= "subject")
x_train<-read.table("UCI HAR Dataset/train/X_train.txt", col.names= features$functions)
y_train<-read.table("UCI HAR Dataset/train/y_train.txt", col.names= "code")
#merge training & test data sets to create one data set
X<-rbind(x_train, x_test)
Y<-rbind(y_train, y_test)
Subject<-rbind(subject_train, subject_test)
Merged_Data<-cbind(Subject, Y, X)
#extract value for mean and standard deviation 
TidyData<-Merged_Data%>%select(subject, code, contains("mean"),contains("std"))
#label activities in data set
TidyData$code<-activities[TidyData$code, 2]
#substitute variable names
names(TidyData)[2]="activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tbody", "Body Time", names(TidyData))
names(TidyData)<-gsub("-mean()", "Average", names(TidyData), ignore.case=TRUE)
names(TidyData)<-gsub("-std()", "Standard Deviation", names(TidyData), ignore.case=TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case=TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))
#second tidy data set with mean of each variable activity and subject
AveActivitySubject<-TidyData%>%group_by(subject, activity)%>%
  summarize_all(list(mean))
write.table(AveActivitySubject, "AveActivitySubject.txt", row.names = FALSE)
str(AveActivitySubject)
write.table(AveActivitySubject, row.names = FALSE)
