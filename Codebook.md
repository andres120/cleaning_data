# CodeBook
Andres Chacon  
May 8, 2016  

## The raw data:

It is spread among different files, in two data sets "test" and "train":

`subject_test.txt` and `subject_trainig.txt`: contrain the `id` of the subject in the observation, there are 30 subjects, so it goes from 1 to 30.

`X_test.txt` and `X_train.txt`: contain the variables per observation.

`features.txt` contains a description of each of the variables in the observations.

`y_test.txt` and `y_train.txt` contain a level (kind of activitie) per observation.

`activity_labels.txt` contains the observation levels and their respective labels.

## Cleaning the data:
We are asked to include only mean and standard deviation variables, to do so we filter the features with:
```
reduced_features <- features[grep("mean\\(|std\\(",features[,2]),2]
```
The raw data variables have two prefixes t for Time and f for Frequency, to improve readability we replace them:
```
reduced_features <- gsub("^t","Time-",reduced_features)
reduced_features <- gsub("^f","Frequency-",reduced_features)
```
Each variable name is composed of 4 elements separated by a hyphen:

* Domain: either Time or Frequency
* Sensor Measurement
    + BodyAcc = Body Linear Acceleration
    + GravityAcc = Gravity Linear Acceleration
    + BodyAccJerk = Jerk signal of body linear acceleration
    + BodyGyro = Body angular velocity
    + BodyGyroJerk = Jerk signal of body angular velocity
    + BodyAccMag = Magnitude of Body Linear Acceleration
    + BodyGyroMag = Magnitude of Body angular velocity
    + BodyAccJerkMag = Magnitude of Jerk signal of body linear acceleration
    + BodyGyroJerkMag = Magnitude of Jerk signal of body angular velocity
* Statistic of the measurement: either mean or standard deviation
* Axis of the measurement

Applied the same fitler from reduced_features to select only the mean and standard deviation from the X and Y data sets:
```
X_test <- select(X_test, grep("mean\\(|std\\(",features[,2]))
X_train <- select(X_train, grep("mean\\(|std\\(",features[,2]))
```
Used those name to replace the original variable names:
```
names(X_test) = reduced_features
names(X_train) = reduced_features
```
Using the activity labels we translate the activity levels into descriptive levels:
```
y_test$V1 <- factor(y_test$V1, levels = activity_labels[,1], 
                    labels = activity_labels[,2])
y_train$V1 <- factor(y_train$V1, levels = activity_labels[,1], 
                     labels = activity_labels[,2])
```                
Manually added a descriptive name to the columns of y_test, y_train and subject data:
```
names(y_test) = "Activity"
names(y_train) = "Activity"
names(subject_test) = "Subject"
names(subject_train) = "Subject"
```
Create test and train data sets by merging their respective subject, X and y sets:
```
test_set <- cbind(subject_test, X_test, y_test)
test_set <- mutate(test_set, "Data Set" = "TEST")
train_set <- cbind(subject_train, X_train, y_train)
train_set <- mutate(train_set, "Data Set" = "TRAIN")
```
And finally merge both train and test data sets:
```
full_data_set <- rbind(train_set, test_set)
```
Groups it by subject, activity type then summarizes it by calculating the mean of each variable:
```
tidy_data_set <- full_data_set %>% 
  group_by(Subject, Activity) %>% 
  summarise_each(funs(mean))
tidy_data_set <- select(tidy_data_set, -`Data Set`)
```
Write the tidy_data_set.txt and tidy_data_set.txt files:
```
write.table(tidy_data_set, "tidy_data_set.txt", row.name=FALSE)
```
