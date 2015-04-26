Code Book for the course project from Getting and Cleaning Data
by Steven Alexander 4/26/2015

Variables used in my script:

subjectTest - data frame that holds the data from subject_test.txt. List of volunteer numbers from test group.
subjectTrain - data frame that holds the data from subject_train.txt. List of volunteer numbers from train group.
testFeatures - data frame holding data from X_test.txt. All data for 561 features in test group.
testLabels - data frame holding data from y_test.txt. All numeric codes for test group activity types.
trainFeatures - data frame holding data from X_train.txt. All data for 561 features in train group.
trainLabels - data frame holding data from y_train.txt. All numeric codes for train group activity types.
features - data frame holding data from features.txt. All descriptive names of the 561 data types.
activityLabels - data frame holding data from activity_labels.txt. This has numeric codes for activities
paired with descriptive names for the activities.

The next three variables are combinations of the test and train variables, with test 
first, followed by train information.
allSubjectIDs - this variable holds all the volunteer numbers from test and train groups.
allFeatures - this variable holds all the data for the 561 features from both test and train groups.
allLabels - this variable holds all the numeric codes for the activity types performed by both test and train groups.

oneDataSet - this variable holds all of the data we need to work with. Starts out as a combination
of allSubjectIDs, allFeatures and allLabels, joined horizontally left to right in that order. Next it
uses the colsToKeep variable(see below) to keep only the feature columns with "mean" or "std" in the name.
Then it uses the variable activityDescriptions (see below) to replace the numeric codes for activities
with descriptive names for activities.

featureNames - a variable that contains a vector of the 561 feature names as character strings

SubjectIDs - name of the column in oneDataSet that holds the volunteers' ID numbers for each record.

ActivityLabels - name of the column in oneDataSet that holds the numerical codes for the activities
performed by the volunteers for each record.

colsToKeep - a variable that holds a vector of the column numbers from oneDataSet that we want to keep,
which are the first two columns and any columns with "mean" or "std" in their names (case ignored).

activityDescriptions - this is a variable that is used to hold a vector of the descriptive names
for the activities performed by the volunteers. The descriptive names correspond to the numerical
indicators of activities in the ActivityLabels column of oneDataSet.

oneDataSetMean - this is the final data frame that gives the means of each remaining feature
for each volunteer, each activity. This is the answer to the project.