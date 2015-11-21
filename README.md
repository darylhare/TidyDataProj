# TidyDataProj

run_analysis.R is the only script in the repository.  It assumes the working direcoty has the unzipped "UCI HAR Dataset" folder in it.

It takes the features.txt file and the subject, X, and Y files from the train and test directories and creates a single tidy dataset.

First, it loads the features.txt file as a dataframe which will be used to set the row names of the dataset.

Next, it processes the training dataset.  subject_train, x_train, and y_train are all loaded.  When loading the y_train set, the col.names option is used with the second column of the feas dataset so that the variable names are connected to the corresponding columns in the full dataset.  Since the rows of all three datasets are alligned (rather than using any sort of ID variable to connect them), the subjectID and activityLabel are just added to the trainDat dataframe (instead of using a merge command).

This process is then repeated for the test data.

Now, the train and test dataframes both have the same columns and mutually exclusive rows, so we combine them into a single dataframe named allDat with a row bind command.

The dplyr library is loaded for next transformations.

First, the script pulls out just the mean and std variable columns using the select command with the contains function.  The subjectID (subID) and activityID (Activ) are also kept.  Note, some column names have the word "mean" in them, but they are not mean variables (for example "angle(tBodyAccJerkMean),gravityMean)").  That is why the script is written to look for "mean.." and requires an exact case match.  This way, the select function picks out the 33 columns which give the mean of all 33 measurement variables in the dataframe (and another 33 for standard deviation).  The resulting dataframe, allMeanStd, has 68 columns: subjectID, activityID, 33 means, and 33 standard deviations.

Next, the mutate function is used to add a new column called actName which gives the text representation of the 6 activity types stored in Activ.

Finally, a pipelined command is used to create the final tidy dataframe.  The allMeanStd dataframe is grouped by activity name and subject ID and summarize_each is used to get the mean for each set.  The resuting dataframe has 180 rows (6 activities by 30 subjects).

write.table is used to write out the dataframe to TidyAssign.txt.
