install.packages("reshape2")
library(reshape2)

##

activityLabels <- read.table("C:/Users/usuario/Downloads/curso3-final/UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")
activityLabels[,2] <- as.character(activityLabels[,2])



features <- read.table("C:/Users/usuario/Downloads/curso3-final/UCI HAR Dataset/features.txt", quote="\"", comment.char="")
features[,2] <- as.character(features[,2])



featuresgrep <- grep(".*mean.*|.*std.*", features[,2])
featuresgrep.nombre <- features[featuresgrep,2]
featuresgrep.nombre = gsub('-mean', 'Mean', featuresgrep.nombre)
featuresgrep.nombre = gsub('-std', 'Std', featuresgrep.nombre)
featuresgrep.nombre <- gsub('[-()]', '', featuresgrep.nombre)




### 



x_train <- read.table("C:/Users/usuario/Downloads/curso3-final/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
y_train <- read.table("C:/Users/usuario/Downloads/curso3-final/UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")
subject_train <- read.table("C:/Users/usuario/Downloads/curso3-final/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")
train <- cbind(subject_train , y_train, x_train)


X_test <- read.table("C:/Users/usuario/Downloads/curso3-final/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
y_test <- read.table("C:/Users/usuario/Downloads/curso3-final/UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")
subject_test <- read.table("C:/Users/usuario/Downloads/curso3-final/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")

test<-cbind(subject_test, y_test, X_test)

allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity",featuresgrep.nombre)


###

allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
