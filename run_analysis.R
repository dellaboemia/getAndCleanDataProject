library(magrittr)
library(tidyr)
library(dplyr)

# column names for the measurement data. removing the numeral at the start of 
# each feature name because R column names can't start with numerals (and can't
# have spaces)
features <- readLines("UCI HAR Dataset/features.txt") %>%
    gsub("^[0-9]+ ", "", .)

# activity labels are coded 1-6, and the activity_labels file has the 
# descriptive text names associated with those codes. We can use this 
activities <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactor=FALSE)
names(activities) <- c("code", "label")

# since we need to do the same thing with both train and test data 
# (cbind the subject, features, and activity_label columns), i'm using 
# a function to avoid writing the same code twice:
c_data <- function(dir) {
    # read and combine the text files from a given directory.
    # both train and test directories include "subject," "X," and "y,"
    # text files, corresponding to subject id, measurement 561-vectors, 
    # and activity classification
    
    files <- list.files(path = dir, include.dirs=FALSE, pattern = ".txt",
                        full.names=TRUE)
    files <- lapply(files, read.table, header=FALSE)
    
    # this part works because alphabetical order happens to match the order we
    # actually want: subject, then X, then y. 
    out <- do.call("cbind", files)
    names(out) <- c("subject", features, "label")
    out
}

# apply c_data to both the train and test directories
dirs <- list.dirs("UCI HAR Dataset", recursive=FALSE)
test <- c_data(dirs[1])
train <- c_data(dirs[2])
dat <- do.call("rbind", list(train, test))

# we only want the mean and standard deviation of each measurement,
# according to the documentation these are suffixed with "mean()" and
# "std()" for each axis (note, does not include "meanFreq," which is
# a weighted average of frequency components and not a mean calculated directly
# from the device measurements).
mean_and_sd <- dat[,grepl("(^subject$|^label$|mean\\(\\)|std\\(\\))", names(dat))]

# replace activity label codes (1-6) with the names (see the "activities" dataframe)
mean_and_sd$label <- factor(mean_and_sd$label, labels=activities$label)

# making descriptive name choices:
# replace abbreviations with full names, and convert camelCaps to
# underscore_spacing by replacing every upper case letter "X" with 
# an underscore and its lower case counterpart "_x"
names(mean_and_sd) <- names(mean_and_sd) %>%
    sub("^t", "time", .) %>%            
    sub("^f", "frequency", .) %>%
    gsub("([^\\-])([A-Z])", "\\1\\_\\L\\2\\E", ., perl=TRUE) %>%
    gsub("body_body", "body", .) %>%
    gsub("acc", "accelerometer", .) %>%  
    gsub("gyro", "gyroscope", .) %>%
    gsub("mag", "magnitude", .) %>%
    gsub("std\\(\\)", "standard_deviation", .) %>%
    gsub("mean\\(\\)", "mean", .)

# use the dplyr and tidyr functions to (a) convert the data to long data
# so that we can group by subject and activity label and then (b) in one go
# take the mean of all of the measurements:

tidy_dat <- tbl_df(mean_and_sd) %>%
    gather(measurement, value, -subject, -label) %>%
    group_by(subject, label, measurement) %>% 
    summarise(mean=mean(value))

write.table(tidy_dat, file="tidy_summary.txt", sep="\t", quote=FALSE, row.names=FALSE)