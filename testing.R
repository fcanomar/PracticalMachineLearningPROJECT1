#testing

url <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(url, destfile="/Users/franciscocanomarchal/Data-Science/Practical-Machine-Learning/Project-One/testing.csv", method="curl")
testing <- read.csv("~/Data-Science/Practical-Machine-Learning/Project-One/testing.csv")

test <- testing
test <- subset(test,select=-c(X,user_name,raw_timestamp_part_1,raw_timestamp_part_2,cvtd_timestamp, new_window, num_window))    
testm <- test[,grepl(names(test),pattern="^roll_|^pitch_|^yaw_|^gyros_|^accel_|^magnet_|^classe")]
testPCA <- predict(prComp, testm)