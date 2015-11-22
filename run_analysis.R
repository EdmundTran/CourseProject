# Read in data (561 variables)
# sep = "" means use any amount of whitespace as the delimiter
training <- read.delim("train/X_train.txt", header = FALSE, sep = "")
test <- read.delim("test/X_test.txt", header = FALSE, sep = "")
variables <- read.delim("features.txt", header = FALSE, sep = " ", stringsAsFactors = FALSE)


# Read in training and test labels
# activity labels
# 1 Walking
# 2 Walking upstairs
# 3 Walking downstairs
# 4 Sitting
# 5 Standing
# 6 Laying
train_label <- read.delim("train/y_train.txt", header = FALSE)
test_label <- read.delim("test/y_test.txt", header = FALSE)


# Read in subject data
train_subject <- read.delim("train/subject_train.txt", header = FALSE)
test_subject <- read.delim("test/subject_test.txt", header = FALSE)


# Add flag for train/test
test_train_flag <- data.frame(c(rep("train", 7352), rep("test", 2947)))


# Combine everything
master <- rbind(training, test)
label <- rbind(train_label, test_label)
subject <- rbind(train_subject, test_subject)
master <- cbind(master, label, subject, test_train_flag)
colnames(master) <- make.names(c(variables$V2, "activity_level", "subject", "test_train_flag"), unique = TRUE)


# Mean for each measurement; verified no NAs with sum(is.na(master))
avg_measurement <- lapply(master, mean)

# Standard deviation for each measurement
sd_measurement <- lapply(master, sd)


# Create a 2nd tidy data set with the avg of each variable for each activity and each subject
# We expect 180 observations: 30 subjects x 6 activities
# Warnings are from attempting to take the mean of test_train_flag
master2 <- aggregate(master, list(Subject = master$subject, Activity = master$activity_level), mean)
write.table(master2, file = "CourseProject_ETran", row.names = FALSE)
