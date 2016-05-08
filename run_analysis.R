# Load of the required library:
library(dplyr)

# Read of the files containing the data:
subject_test <- read.table("subject_test.txt")
subject_train <- read.table("subject_train.txt")
X_test <- read.table("X_test.txt")
X_train <- read.table("X_train.txt")
y_test <- read.table("y_test.txt")
y_train <- read.table("y_train.txt")
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

# Filter the features to only include mean and standard deviation variables:
reduced_features <- features[grep("mean\\(|std\\(",features[,2]),2]

# Replaces t and f for Time and Frequency respectively:
reduced_features <- gsub("^t","Time-",reduced_features)
reduced_features <- gsub("^f","Frequency-",reduced_features)

# Applying the same filter from the features, we filter only the columns we need:
X_test <- select(X_test, grep("mean\\(|std\\(",features[,2]))
X_train <- select(X_train, grep("mean\\(|std\\(",features[,2]))

# Apply the variable names to the data sets:
names(X_test) = reduced_features
names(X_train) = reduced_features

# Translate the activities from a numbers into labels:
y_test$V1 <- factor(y_test$V1, levels = activity_labels[,1], 
                    labels = activity_labels[,2])
y_train$V1 <- factor(y_train$V1, levels = activity_labels[,1], 
                     labels = activity_labels[,2])

# Add descriptive variable names to the activities and subjects data sets:
names(y_test) = "Activity"
names(y_train) = "Activity"
names(subject_test) = "Subject"
names(subject_train) = "Subject"

# Unify the test and train data set parts then merge them into a single tidy data set:
test_set <- cbind(subject_test, X_test, y_test)
test_set <- mutate(test_set, "Data Set" = "TEST")
train_set <- cbind(subject_train, X_train, y_train)
train_set <- mutate(train_set, "Data Set" = "TRAIN")
full_data_set <- rbind(train_set, test_set)

tidy_data_set <- full_data_set %>% 
  group_by(Subject, Activity) %>% 
  summarise_each(funs(mean))
tidy_data_set <- select(tidy_data_set, -`Data Set`)

# Write the tidy_data_set.txt file:
write.table(tidy_data_set, "tidy_data_set.txt", row.names=FALSE)