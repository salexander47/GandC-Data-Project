library(utils)
library(plyr)

subjectTest<-read.table("subject_test.txt")
subjectTrain<-read.table("subject_train.txt")
testFeatures<-read.table("X_test.txt")
testLabels<-read.table("y_test.txt")
trainFeatures<-read.table("X_train.txt")
trainLabels<-read.table("y_train.txt")
features<-read.table("features.txt")
activityLabels<-read.table("activity_labels.txt")

allSubjectIDs<-rbind(subjectTest, subjectTrain)
allFeatures<-rbind(testFeatures, trainFeatures)
allLabels<-rbind(testLabels, trainLabels)

oneDataSet<-cbind(allSubjectIDs, allLabels, allFeatures)

featureNames<-as.character(features$V2)
colnames(oneDataSet)<-c("SubjectIDs","ActivityLabels", featureNames)

colsToKeep<-c("1","2", grep("mean", colnames(oneDataSet), ignore.case=TRUE), grep("std", colnames(oneDataSet), ignore.case=TRUE))
colsToKeep<-as.numeric(colsToKeep)
colsToKeep<-sort(colsToKeep)

oneDataSet<-oneDataSet[, colsToKeep]

activityLabels$V2<-as.character(activityLabels$V2)
colnames(activityLabels)<-c("ActivityLabels","ActivityDescriptions")

activityDescriptions<-rep(NA, 10299)

oneDataSet<-cbind(oneDataSet, activityDescriptions)
oneDataSet$activityDescriptions<-activityLabels$ActivityDescriptions[match(oneDataSet$ActivityLabels,activityLabels$ActivityLabels)]
oneDataSet<-oneDataSet[c(1,2,89,3:88)]

oneDataSet<-oneDataSet[c(1,3:89)]

oneDataSetMean<-ddply(oneDataSet, .(SubjectIDs, activityDescriptions),numcolwise(mean))

write.table(oneDataSetMean,"oneDataSetMean.txt", row.name=FALSE)
