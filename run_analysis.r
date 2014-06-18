# merge training and test sets to create one data set

features <- read.table("features.txt")
xtest <- read.table("./test/X_test.txt", col.names = features[,2])
xtrain <- read.table("./train/X_train.txt", col.names = features[,2])
fullsetx <- rbind(xtest, xtrain)

#extract mean and std dev for each measurement
mean.stddev <- features[grep("(mean|std) \\(", features[,2]),]
mean.stddev2 <- fullsetx[, mean.stddev[,1]] 

# name activities with descriptive names
ytest <- read.table("./test/y_test.txt", col.names = c("activity"))
ytrain <- read.table("./train/y_train.txt", col.names = c("activity"))
fullsety <- rbind(ytest, ytrain)
labels <- read.table("activity_labels.txt")
	for (i in 1:nrow(labels)) {
	code <- as.numeric(labels[i, 1])
	name <- as.character(labels[i, 2])
	fullsety[fullsety$activity == code, ] <- name
	}

#label dataset with variable names
xlabels <- cbind(fullsety, fullsetx)
mean.stddev.labels <- cbind(fullsety, mean.stddev2)

#create a new tidy dataset with average for each variable for each activity and subject
subjecttest <- read.table("./test/subject_test.txt", col.names = c('subject'))
subjecttrain <- read.table("./train/subject_train.txt", col.names = c('subject'))
subject <- rbind(subjecttest, subjecttrain)
average <- aggregate(fullsetx, by = list(activity = fullsety[,1], subject = subject[,1]), mean)
write.csv(average, file="submission.txt", row.names = FALSE)
