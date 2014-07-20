## Course Project
The script "run_analysis.R" reads and manipulates the "Human Activity Recognition 
Using Smartphones" data according to the instructions in the Getting and 
Cleaning Data Course Project. This script assumes that you have already downloaded 
and unzipped the UCI HAR data (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 
as is, preserving the directory structure in that archive.

### Tidiness
I've chosen to tidy my data by making it long. This means there are only 4 columns 
in my data. Depending on the analysis task, this may or may not be ideal, but I 
find this version easy to understand and useful for certain types of analysis. 

When I extracted just the mean/standard deviations from the original data, I found 
a data set with 66 measurement variables along with the subject ID and the 
activity classification label, for a total of 68 variables in all. By gathering 
the columns, I narrowed and lengthened the data set: the tidy version has just 
4 columns but 11,880 rows. This makes sense since there are 30 subjects in all 
and 6 activity types (and every subject was observed doing every activity). 
66 * 30 * 6 = 11,880.

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

### How the script works:
it does some stuff