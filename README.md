If you open this inside Github, click the "Raw" button for the intended format.

<*> GandC-Data-Project
<*>repository for the project in the getting and cleaning data class

<*>My comments will always have a <*> as the first character on the line. Code will not.
<*>I'm using comments to explain each block or line of code, followed by the code itself.

<*>Thanks to David Hood and my classmates for the information posted on the blog
<*>for this project. I used it extensively to help me generate this script.
<*>Also thanks to Google and StackOverflow for helping me find answers to questions
<*>that had me stuck numerous times along the way while developing this solution.

<*>Here's how my script works:

<*>First, I load the required libraries
library(utils)
library(plyr)

<*>Next, read in all of the text files needed for the script
<*>and put them into variables with descriptive names
subjectTest<-read.table("subject_test.txt")
subjectTrain<-read.table("subject_train.txt")
testFeatures<-read.table("X_test.txt")
testLabels<-read.table("y_test.txt")
trainFeatures<-read.table("X_train.txt")
trainLabels<-read.table("y_train.txt")
features<-read.table("features.txt")
activityLabels<-read.table("activity_labels.txt")

<*>Now put the test and train data together to make 3 data frames, all with the 
<*>same number of rows as each other
allSubjectIDs<-rbind(subjectTest, subjectTrain)
allFeatures<-rbind(testFeatures, trainFeatures)
allLabels<-rbind(testLabels, trainLabels)

<*>Put the three data frames together with subject IDs in first column,
<*>activity labels in the second column, and the 561 features in the rest of the columns
<*>so all the data is together in "oneDataSet"
oneDataSet<-cbind(allSubjectIDs, allLabels, allFeatures)

<*>Create a new vector called featureNames that contains all the names of the 561 features
featureNames<-as.character(features$V2)

<*>Change the column names in oneDataSet from V1, V2,...V563 to 
<*>descriptive variable names.
colnames(oneDataSet)<-c("SubjectIDs","ActivityLabels", featureNames)

<*>Create a variable colsToKeep that is a vector of the column numbers from oneDataSet
<*>that we wish to keep. These are the first two columns "SubjectIDs" and "ActivityLabels"
<*>plus all of the columns that contain the words "mean" and/or "std" regardless of case.
colsToKeep<-c("1","2", grep("mean", colnames(oneDataSet), ignore.case=TRUE), grep("std", colnames(oneDataSet), ignore.case=TRUE))

<*>change the type of the values in colsToKeep from factor to numeric
colsToKeep<-as.numeric(colsToKeep)

<*>Sort the column numbers in ascending order, so they will be in the same order
<*>as the columns in oneDataSet
colsToKeep<-sort(colsToKeep)

<*>Subset the main data set to keep only the columns identified in colsToKeep,
<*>which are the subjectIDs column, ActivityLabels column and all feature
<*>columns with mean or std in the column names (case ignored).
oneDataSet<-oneDataSet[, colsToKeep]

<*>Swap out the numbers in oneDataSet$ActivityLabels for descriptive names,
<*>by first changing activityLabels descriptions from factors to characters
activityLabels$V2<-as.character(activityLabels$V2)

<*>Then change the headers of activityLabels data frame so the activity numbers are called
<*>ActivityLabels (matches the appropriate column name in oneDataSet)
<*>and ActivityDescriptions is the new name for the activity descriptions, e.g. "WALKING"
colnames(activityLabels)<-c("ActivityLabels","ActivityDescriptions")

<*>Now add a column of NA's to oneDataSet to be a placeholder for the 
<*>activity descriptions, which will replace the ActivityLabels column in oneDataSet.
<*>First create the activityDescriptions vector
activityDescriptions<-rep(NA, 10299)

<*>Next bind it to the end of oneDataSet
oneDataSet<-cbind(oneDataSet, activityDescriptions)

<*>Now replace the NA's in oneDataSet$activityDescriptions with Activity Descriptions
<*>that match up horizontally with the corresponding ActivityLabels values.
<*>So for example, if record number 47 has a 5 in the ActivityLabels column, then it will say "STANDING"
<*>in the same record in the activityDescriptions column.
oneDataSet$activityDescriptions<-activityLabels$ActivityDescriptions[match(oneDataSet$ActivityLabels,activityLabels$ActivityLabels)]

<*>Subset to rearrange the columns so that the activityDescriptions column is the 3rd column from the left.
oneDataSet<-oneDataSet[c(1,2,89,3:88)]

<*>Subset again to remove the ActivityLabels column
oneDataSet<-oneDataSet[c(1,3:89)]

<*>Create a new data frame "oneDataSetMeans" that has the means of each variable for each
<*>combination of SubjectIDs and activityDescriptions
oneDataSetMean<-ddply(oneDataSet, .(SubjectIDs, activityDescriptions),numcolwise(mean))

<*>Write the oneDataSetMean data frame to a file in the local directory.
write.table(oneDataSetMean,"oneDataSetMean.txt", row.name=FALSE)
