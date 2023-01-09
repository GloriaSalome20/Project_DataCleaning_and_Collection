# LOADING LIBRARIES
library(dplyr) 


setwd("C:/Users/user_1/Desktop/Glorias_folder/coursera/getting_cleaning_data/UCI HAR Dataset")
#reading the data set
X_test <- read.table("test/X_test.txt", header = FALSE)
y_test <- read.table("test/y_test.txt", header = FALSE)
X_train <- read.table("train/X_train.txt", header = FALSE)
y_train <- read.table("train/y_train.txt", header = FALSE)
sub_Train <- read.table("train/subject_train.txt", header = FALSE)
sub_Test <- read.table("test/subject_test.txt", header = FALSE)

# combining the test for X and Y and train for X and Y
dataY<- rbind(y_train, y_test)
dataX<- rbind(X_train, X_test)
sub_data <- rbind(sub_Train,sub_Test)

#setting the feature names
names<- read.table("features.txt", header = FALSE)
names(dataX)<- names$V2
colnames(sub_data) <- "Subject"
colnames(dataY) <- "Activity"
## combine to form one data set with both train and test
df <- cbind(sub_data,dataY,dataX)



#########################################################################
##QUESTION TWO##################
# sapply(dataX, mean, na.rm=TRUE)  
# sapply(dataX, sd, na.rm=TRUE)  
# sapply(dataY, mean, na.rm=TRUE)  
# sapply(dataY, sd, na.rm=TRUE) 
# 
# ##alternatively
# columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(df), ignore.case=TRUE)

columnsWithMeanSTD <- df %>%
  select(Subject,Activity,contains("mean"),contains("std"))
#######################################################################
######QUESTION THREE#########################

#Read the activity file
act_df <- read.table("activity_labels.txt", header = FALSE)
act_df

df$Activity[df$Activity==1] <- "WALKING"
df$Activity[df$Activity==2] <- "WALKING_UPSTAIRS"
df$Activity[df$Activity==3] <- "WALKING_DOWNSTAIRS"
df$Activity[df$Activity==4] <- "SITTING"
df$Activity[df$Activity==5] <- "STANDING"
df$Activity[df$Activity==6] <- "LAYING"


#########################################################################
###########QUESTION FOUR#########################

#renaming the variables
names(df)<-gsub("^t", "time", names(df), ignore.case = TRUE)
names(df)<-gsub("^f", "frequency", names(df), ignore.case = TRUE)
names(df)<-gsub("Acc", "Accelerometer", names(df), ignore.case = TRUE)
names(df)<-gsub("Gyro", "Gyroscope", names(df), ignore.case = TRUE)
names(df)<-gsub("Mag", "Magnitude", names(df), ignore.case = TRUE)
names(df)<-gsub("BodyBody", "Body", names(df), ignore.case = TRUE)
names(df)<-gsub("tBody", "TimeBody", names(df), ignore.case = TRUE)
names(df)<-gsub("-mean()", "Mean", names(df), ignore.case = TRUE)
names(df)<-gsub("-std()", "STD", names(df), ignore.case = TRUE)
names(df)<-gsub("-freq()", "Frequency", names(df), ignore.case = TRUE)
names(df)<-gsub("angle", "Angle", names(df))
names(df)<-gsub("gravity", "Gravity", names(df))



###############################################################################
#####QUESTION FIVE######################
tidyData<-aggregate(. ~Subject + Activity, columnsWithMeanSTD, mean)
tidyData<-tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "tidydata.txt",row.name=FALSE)
