#Load all datasets into R
subject_train <- read.table(file = "train/subject_train.txt", header = FALSE, sep = "")
X_train <- read.table(file = "train/X_train.txt", header = FALSE, sep = "")
y_train <- read.table(file = "train/y_train.txt", header = FALSE, sep = "")
features <- read.table(file = "features.txt", header = FALSE, sep = "")
activity_labels <- read.table(file = "activity_labels.txt", header = FALSE, sep = "")
subject_test <- read.table(file = "test/subject_test.txt", header = FALSE, sep = "")
X_test <- read.table(file = "test/X_test.txt", header = FALSE, sep = "")
y_test <- read.table(file = "test/y_test.txt", header = FALSE, sep = "")

#Transpose variable names
features1 <- data.frame(t(features))
#Convert variable names into character
features1[] <- lapply(features1, as.character)
#Relabel column names in two datasets from an existing dataset which meets requirement #4 of HW assignment
colnames(X_train) <- features1[2, ]
colnames(X_test) <- features1[2, ]
#Relabel column names in two datasets
names(y_train)[names(y_train) == 'V1'] <- 'Activity_Code'
names(y_test)[names(y_test) == 'V1'] <- 'Activity_Code'
#Merge datasets column-wise
merged_data_train <- cbind(subject_train, y_train, X_train)
merged_data_test <- cbind(subject_test, y_test, X_test)
#Relabel column names in two datasets
names(merged_data_train)[names(merged_data_train) == 'V1'] <- 'Subject_Number'
names(merged_data_test)[names(merged_data_test) == 'V1'] <- 'Subject_Number'
#Relabel column names
names(activity_labels)[names(activity_labels) == 'V1'] <- 'Activity_Code'
names(activity_labels)[names(activity_labels) == 'V2'] <- 'Activity'
#Merge two datasets by a common column name which meets requirement #3 of HW assignment
merged_data_train <- merge(merged_data_train, activity_labels, by = 'Activity_Code')
merged_data_test <- merge(merged_data_test, activity_labels, by = 'Activity_Code')
#Drop columns
merged_data_train$Activity_Code <- NULL
merged_data_test$Activity_Code <- NULL
#Add a new column to identify whether the subject was of train or test dataset
merged_data_train$Train_Test <- 'TRAIN'
merged_data_test$Train_Test <- 'TEST'
#Merge datasets row-wise
merged_data <- rbind(merged_data_train, merged_data_test)
#Reorder dataset by columns
merged_data <- merged_data[ , c(1, 563:564, 2:562)]
#Sort dataset by Subject Number
merged_data <- merged_data[order(merged_data$Subject_Number), ]
#Get rid of row names
rownames(merged_data) <- c()
#Final result of the merged dataset which meets requirement #1 of HW assignment
merged_data

#Gets the average of each variable for each activity and each subject which meets requirement #5 of HW assignment
agg_values <- aggregate(merged_data[, 4:564], list(merged_data$Subject_Number, merged_data$Activity), mean)
#Relabels the columns
names(agg_values)[names(agg_values) == 'Group.1'] <- 'Subject_Number'
names(agg_values)[names(agg_values) == 'Group.2'] <- 'Activity'
agg_values

#Create an output of the results as previously shown:
write.table(x = agg_values, file = "aggregate.txt", sep = ",", na = "@", quote = FALSE, row.names = FALSE)
