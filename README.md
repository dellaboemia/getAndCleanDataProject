## Course Project
The script "run_analysis.R" reads and manipulates the "Human Activity Recognition 
Using Smartphones" data according to the instructions in the Getting and 
Cleaning Data Course Project. This script assumes that you have already downloaded 
and unzipped the UCI HAR data (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 
as is, preserving the directory structure in that archive.

### Tidiness
I've chosen to tidy my data by making it long. This means there are only 4 columns 
in my data. Depending on the analysis task, this may or may not be ideal, but I 
find this version easy to understand and useful for certain types of analysis. For instance,
I like to use ggplot for exploration and plotting, and this long format is the most 
convenient for plotting/faceting across multiple variables. Another example: we can 
very easily compute aggregate statistics across subjects for each activity and 
for every variable in this format, whereas if the data were wide we would need to 
write separate aggregations for each column, or use lapply. However, if we needed to 
convert the data to the wide format (for instance to use the formula interface for 
a regression model), we could very easily do that by using the "spread()" function. 

When I extracted just the mean/standard deviations from the original data, I found 
a data set with 66 measurement variables along with the subject ID and the 
activity classification label, for a total of 68 variables in all. By gathering 
the columns, I narrowed and lengthened the data set: the tidy version has just 
4 columns but 11,880 rows. This makes sense since there are 30 subjects in all 
and 6 activity types (and every subject was observed doing every activity). 
66 * 30 * 6 = 11,880.

### How the script works:
The script makes use of the `magrittr` package in order to make the code more 
concise and easier to read. Instead of storing data in temporary variables in the 
course of processing, I use %>% to pass the output of one function onto the next 
function. 

Both the training and test data are stored in three separate text files: a subject 
file which just includes the subject id associated with each measurement (one column), 
the "X" file which has the 561 measurements associated with each row, and finally 
the "Y" file which has the activity classification (hand-coded). All files use a 
standard newline for the end of each row, and the "X" file uses whitespace as a delimiter 
between columns. Further, all files are in the same order, so combining them requires 
cbinding them without re-ordering any of the files. The function c_data does that, 
see the comments in run_analysis.R for more details.

After reading and cbinding the train and test data, the script combines them into one 
column using rbind, and then extracts just the columns that were requested: the subject, 
the activity label, and any measurement variable that is a mean or standard deviation. 
I've interpreted that request as excluding the various meanFreq columns, which are not 
simple means of the measurement windows like the other columns, but instead do 
further processing. I use regular expressions to identify columns with "mean()" 
or "std()" in the name.  

To clean up the variable names, I chose to put everything into lower case using 
underscores_to_parse_words instead of camelCase. I also replaced instances of 
"body_body" with "body" since that looked like a mistake, and expanded abbreviations 
to make the names easier to understand. All of this was accomplished using the sub/gsub 
functions along with the appropriate regular expressions (see run_analysis.R).

Finally, the last step is to gather the wide data into a long 4-column dataset, and 
to summarise each variable by taking the mean for every combination of subject and 
activity, using group_by() and summarise() from the `dplyr` package. 

### Codebook
Note: All of the measurement variables have descriptive names with the pattern: 
*domain_signalType_device(_jerk)(_magnitude)-aggregation(-axis)* where:
- domain: one of "time" or "frequency"
- signalType: "body" or "gravity," as separated via filtering of the signals
- device: "accelerometer" or "gyroscope"
- aggregation: "mean" or "standard deviation"

When "_jerk" appears as part of the name, this indicates the variable is the derivative 
of velocity with respect to time (aka acceleration). The "-axis" at the end will be 
one of "-X" "-Y" or "-Z," indicating the X, Y, or Z axis respectively. For some 
measurements, the magnitude of the signal was calculated, in those cases the 
variable name will not have an "-axis" suffix, but instead will say "_magnitude." 
See below for the full list of measurement types.

- subject: Subject ID
- label: The labeled activity, as classified by human observers. This is one of: 
    - WALKING
    - WALKING_UPSTAIRS
    - WALKING_DOWNSTAIRS
    - SITTING
    - STANDING
    - LAYING
- measurement:
    - time_body_accelerometer-mean-X
    - time_body_accelerometer-mean-Y
    - time_body_accelerometer-mean-Z
    - time_body_accelerometer-standard_deviation-X
    - time_body_accelerometer-standard_deviation-Y
    - time_body_accelerometer-standard_deviation-Z
    - time_gravity_accelerometer-mean-X
    - time_gravity_accelerometer-mean-Y
    - time_gravity_accelerometer-mean-Z
    - time_gravity_accelerometer-standard_deviation-X
    - time_gravity_accelerometer-standard_deviation-Y
    - time_gravity_accelerometer-standard_deviation-Z
    - time_body_accelerometer_jerk-mean-X
    - time_body_accelerometer_jerk-mean-Y
    - time_body_accelerometer_jerk-mean-Z
    - time_body_accelerometer_jerk-standard_deviation-X
    - time_body_accelerometer_jerk-standard_deviation-Y
    - time_body_accelerometer_jerk-standard_deviation-Z
    - time_body_gyroscope-mean-X
    - time_body_gyroscope-mean-Y
    - time_body_gyroscope-mean-Z
    - time_body_gyroscope-standard_deviation-X
    - time_body_gyroscope-standard_deviation-Y
    - time_body_gyroscope-standard_deviation-Z
    - time_body_gyroscope_jerk-mean-X
    - time_body_gyroscope_jerk-mean-Y
    - time_body_gyroscope_jerk-mean-Z
    - time_body_gyroscope_jerk-standard_deviation-X
    - time_body_gyroscope_jerk-standard_deviation-Y
    - time_body_gyroscope_jerk-standard_deviation-Z
    - time_body_accelerometer_magnitude-mean
    - time_body_accelerometer_magnitude-standard_deviation
    - time_gravity_accelerometer_magnitude-mean
    - time_gravity_accelerometer_magnitude-standard_deviation
    - time_body_accelerometer_jerk_magnitude-mean
    - time_body_accelerometer_jerk_magnitude-standard_deviation
    - time_body_gyroscope_magnitude-mean
    - time_body_gyroscope_magnitude-standard_deviation
    - time_body_gyroscope_jerk_magnitude-mean
    - time_body_gyroscope_jerk_magnitude-standard_deviation
    - frequency_body_accelerometer-mean-X
    - frequency_body_accelerometer-mean-Y
    - frequency_body_accelerometer-mean-Z
    - frequency_body_accelerometer-standard_deviation-X
    - frequency_body_accelerometer-standard_deviation-Y
    - frequency_body_accelerometer-standard_deviation-Z
    - frequency_body_accelerometer_jerk-mean-X
    - frequency_body_accelerometer_jerk-mean-Y
    - frequency_body_accelerometer_jerk-mean-Z
    - frequency_body_accelerometer_jerk-standard_deviation-X
    - frequency_body_accelerometer_jerk-standard_deviation-Y
    - frequency_body_accelerometer_jerk-standard_deviation-Z
    - frequency_body_gyroscope-mean-X
    - frequency_body_gyroscope-mean-Y
    - frequency_body_gyroscope-mean-Z
    - frequency_body_gyroscope-standard_deviation-X
    - frequency_body_gyroscope-standard_deviation-Y
    - frequency_body_gyroscope-standard_deviation-Z
    - frequency_body_accelerometer_magnitude-mean
    - frequency_body_accelerometer_magnitude-standard_deviation
    - frequency_body_accelerometer_jerk_magnitude-mean
    - frequency_body_accelerometer_jerk_magnitude-standard_deviation
    - frequency_body_gyroscope_magnitude-mean
    - frequency_body_gyroscope_magnitude-standard_deviation
    - frequency_body_gyroscope_jerk_magnitude-mean
    - frequency_body_gyroscope_jerk_magnitude-standard_deviation
- mean: the mean of the measurement for the given subject and activity label
