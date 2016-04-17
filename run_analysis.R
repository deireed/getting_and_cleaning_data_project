##Import data sets: features, y_test, X_test, y_train, X_train, activity_labels

##Label activity_labels columns

colnames(activity_labels) <- c("activity_id", "activity_name")

##Get dataframes' column names

features_names <- features[,2]

##Read and label test data

test_data <- X_test

colnames(test_data) <- features_names

##Read and label train data

train_data <- X_train

colnames(train_data) <- features_names

## Read the ids of the test subjects and label the columns
test_subject_id <- subject_test
colnames(test_subject_id) <- "subject_id"

## Read the activity id's of the test data and label the columns
test_activity_id <- y_test
colnames(test_activity_id) <- "activity_id"

## Read the ids of the test subjects and label the columns
train_subject_id <- subject_train
colnames(train_subject_id) <- "subject_id"

## Read the activity id's of the training data and label columns
train_activity_id <- y_train
colnames(train_activity_id) <- "activity_id"

##Combine the test subject id's, the test activity id's 
##and the test data into one dataframe
test_data <- cbind(test_subject_id , test_activity_id , test_data)

##Combine the train subject id's, the train activity id's 
##and the train data into one dataframe
train_data <- cbind(train_subject_id , train_activity_id , train_data)


##Combine the test data and the train data into one dataframe
all_data <- rbind(train_data,test_data)

##Keep only columns refering to mean() or std() values
mean_col_idx <- grep("mean",names(all_data),ignore.case=TRUE)
mean_col_names <- names(all_data)[mean_col_idx]
std_col_idx <- grep("std",names(all_data),ignore.case=TRUE)
std_col_names <- names(all_data)[std_col_idx]
meanstddata <-all_data[,c("subject_id","activity_id",mean_col_names,std_col_names)]

##Merge the activities datase with the mean/std values datase 
##to get one dataset with descriptive activity names
descrnames <- merge(activity_labels,meanstddata,by.x="activity_id",by.y="activity_id",all=TRUE)

##Melt the dataset with the descriptive activity names for better handling
data_melt <- melt(descrnames,id=c("activity_id","activity_name","subject_id"))

##Cast the melted dataset according to  the average of each variable 
##for each activity and each subjec
mean_data <- dcast(data_melt,activity_id + activity_name + subject_id ~ variable,mean)

## Create a file with the new tidy dataset
write.table(mean_data,"./tidy_data.txt")
