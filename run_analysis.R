download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile=".\\getdataproj.zip")

for (i in dir(pattern="\\.zip$"))
{  unzip(i) }

setwd("UCI HAR Dataset")

library(stringr)

# Read all data into separate variables

subject_test<-read.table(".\\test\\subject_test.txt")
x_test<-read.table(".\\test\\x_test.txt")
y_test<-read.table(".\\test\\y_test.txt")
body_acc_x_test<-read.table(".\\test\\Inertial Signals\\body_acc_x_test.txt")
body_acc_y_test<-read.table(".\\test\\Inertial Signals\\body_acc_y_test.txt")
body_acc_z_test<-read.table(".\\test\\Inertial Signals\\body_acc_z_test.txt")
body_gyro_x_test<-read.table(".\\test\\Inertial Signals\\body_gyro_x_test.txt")
body_gyro_y_test<-read.table(".\\test\\Inertial Signals\\body_gyro_y_test.txt")
body_gyro_z_test<-read.table(".\\test\\Inertial Signals\\body_gyro_z_test.txt")
total_acc_x_test<-read.table(".\\test\\Inertial Signals\\total_acc_x_test.txt")
total_acc_y_test<-read.table(".\\test\\Inertial Signals\\total_acc_y_test.txt")
total_acc_z_test<-read.table(".\\test\\Inertial Signals\\total_acc_z_test.txt")


subject_train<-read.table(".\\train\\subject_train.txt")
x_train<-read.table(".\\train\\x_train.txt")
y_train<-read.table(".\\train\\y_train.txt")
body_acc_x_train<-read.table(".\\train\\Inertial Signals\\body_acc_x_train.txt")
body_acc_y_train<-read.table(".\\train\\Inertial Signals\\body_acc_y_train.txt")
body_acc_z_train<-read.table(".\\train\\Inertial Signals\\body_acc_z_train.txt")
body_gyro_x_train<-read.table(".\\train\\Inertial Signals\\body_gyro_x_train.txt")
body_gyro_y_train<-read.table(".\\train\\Inertial Signals\\body_gyro_y_train.txt")
body_gyro_z_train<-read.table(".\\train\\Inertial Signals\\body_gyro_z_train.txt")
total_acc_x_train<-read.table(".\\train\\Inertial Signals\\total_acc_x_train.txt")
total_acc_y_train<-read.table(".\\train\\Inertial Signals\\total_acc_y_train.txt")
total_acc_z_train<-read.table(".\\train\\Inertial Signals\\total_acc_z_train.txt")

activity_labels <- read.table("activity_labels.txt")

features <- read.table("features.txt")

# Change column names
colnames(x_train) <- features[,2]
colnames(x_test) <- features[,2]

#Combine data

x_all<-rbind(x_test,x_train)
y_all <- rbind(y_test,y_train)
subject_all <- rbind(subject_test,subject_train)

#Select columns related to mean and std
meancols <- grepl("mean",features[,2])
stdcols<-grepl("std",features[,2])

meanstdcols <- meancols | stdcols

#Apply labels
Activity_Label<-activity_labels[y_all$V1,2]
al2<-cbind(Activity_Label,x_all[,meanstdcols])
al3 <-cbind(subject_all,al2)

#change column names to more readable/clean versions
colnames(al3)[1] <- "Subject"
alav<-with(al3,aggregate(al3,list(Subject,Activity_Label),mean))
colnames(alav)<-str_replace_all(tolower(colnames(alav)),"[[:punct:]]","")
alav1 <- subset(alav, select=-c(group1,activitylabel))
colnames(alav1)[1] <- "activitylabel"
alav2 <- alav1[,c(2,1,3:81)]

#Write output in wide format
write.table(alav2,file="Step5out.txt",sep='\t',quote=FALSE,row.names=FALSE)
