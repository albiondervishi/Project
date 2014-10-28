#set working directory to the location where the UCI HAR Dataset was unzipped
##require(plyr)
setwd("C:/Users/Albion/Desktop/PROJECT/UCI HAR Dataset")
if(!file.exists("a")){file.create("a")}
a="UCI HAR Dataset"
write.table(a, file = "a.txt")
feature_file <- paste(a, "/features.txt", sep = "")
activity_labels_file <- paste(a, "/activity_labels.txt", sep = "") 
x_train_file <- paste(a, "/train/X_train.txt", sep = "") 
y_train_file <- paste(a, "/train/y_train.txt", sep = "") 
subject_train_file <- paste(a, "/train/subject_train.txt", sep = "") 
x_test_file <- paste(a, "/test/X_test.txt", sep = "") 
y_test_file <- paste(a, "/test/y_test.txt", sep = "") 
subject_test_file <- paste(a, "/test/subject_test.txt", sep = "")
# Load raw data

features <- read.table(feature_file, colClasses = c("character")) 
activity_labels <- read.table(activity_labels_file, col.names = c("ActivityId", "Activity")) 
x_train <- read.table(x_train_file) 
y_train <- read.table(y_train_file) 
subject_train <- read.table(subject_train_file) 
x_test <- read.table(x_test_file) 
y_test <- read.table(y_test_file) 
subject_test <- read.table(subject_test_file) 
##################################################################
# Merge the finalData set
A<- cbind(cbind(x_train, subject_train), y_train)
B <- cbind(cbind(x_test, subject_test), y_test)
alldata <- rbind(A,B)
alldata_labels <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2] 
names(alldata) <- alldata_labels
# mean and standard deviation for each measurement.
alldata_mean_std <- alldata[,grepl("mean|std|Subject|ActivityId", names(alldata))]
#Name the activities in the data set
alldata_mean_std <- join(alldata_mean_std, activity_labels, by = "ActivityId", match = "first")
alldata_mean_std <- alldata_mean_std [,-1]


####################################################
# Cleaning up the variable names
##########################################
# Remove parentheses
names(alldata_mean_std) <- gsub('\\(|\\)',"",names(alldata_mean_std), perl = TRUE)
# Make syntactically valid names
names(alldata_mean_std) <- make.names(names(alldata_mean_std))
# Make clearer names
names(alldata_mean_std) <- gsub('Acc',"Acceleration",names(alldata_mean_std))
names(alldata_mean_std) <- gsub('GyroJerk',"AngularAcceleration",names(alldata_mean_std))
names(alldata_mean_std) <- gsub('Gyro',"AngularSpeed",names(alldata_mean_std))
names(alldata_mean_std) <- gsub('Mag',"Magnitude",names(alldata_mean_std))
names(alldata_mean_std) <- gsub('^t',"TimeDomain.",names(alldata_mean_std))
names(alldata_mean_std) <- gsub('^f',"FrequencyDomain.",names(alldata_mean_std))
names(alldata_mean_std) <- gsub('\\.mean',".Mean",names(alldata_mean_std))
names(alldata_mean_std) <- gsub('\\.std',".StandardDeviation",names(alldata_mean_std))
names(alldata_mean_std) <- gsub('Freq\\.',"Frequency.",names(alldata_mean_std))
names(alldata_mean_std) <- gsub('Freq$',"Frequency",names(alldata_mean_std))

tidydata= ddply(alldata_mean_std, c("Subject","Activity"), numcolwise(mean))
write.table(tidydata, file = " tidydata.txt")
