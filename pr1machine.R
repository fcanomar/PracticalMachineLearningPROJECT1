library(caret)


#get the data

url <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
download.file(url, destfile="/Users/franciscocanomarchal/Data-Science/Practical-Machine-Learning/Project-One/training.csv", method="curl")
exercise <- read.csv("~/Data-Science/Practical-Machine-Learning/Project-One/training.csv")


#divide into training and test set

trainPart <- createDataPartition(exercise$classe,p=0.75,list=FALSE)
training <- exercise[trainPart,]
test <- exercise[-trainPart,]

#select variables

train <- subset(training,select=-c(X,user_name,raw_timestamp_part_1,raw_timestamp_part_2,cvtd_timestamp, new_window, num_window))    

#I am going to keep only the variables actually measured

trainm <- train[,grepl(names(train),pattern="^roll_|^pitch_|^yaw_|^gyros_|^accel_|^magnet_|^classe")]

M <- abs(cor(subset(trainm,select=-c(classe))))
diag(M) <- 0
which(M>0.8,arr.ind=T)

#some of them are quite correlated, it is to be expected for ex. due to contraints in the body movement

#try pca?
traindes <- subset(trainm,select=-c(classe))
        
prComp <- preProcess(traindes,method="pca")
trainPC  <- predict(prComp,traindes)

#only 23 components needed to capture 95 percent of the variance

#RANDOM FORESTS
library(randomForest)
set.seed(647)

trainsub <- trainm[sample(1:nrow(trainm),1000),]

modelFit <- randomForest(classe~.,data=trainsub)

#modelFit <- train(classe~., data=trainm, method="rf", )

#RANDOM FORESTS WITH PCA

#subset
# sample <- sample(1:nrow(trainm),10000)
# trainsubpca <- trainPC[sample,]
# ressubpca <- trainm$classe[sample]
# 
# modelFitPCA <- randomForest(ressubpca~.,data=trainsubpca)

#whole set
modelFitPCA <- randomForest(trainm$classe~.,data=trainPC)

#test the model
test <- subset(test,select=-c(X,user_name,raw_timestamp_part_1,raw_timestamp_part_2,cvtd_timestamp, new_window, num_window))    
testm <- test[,grepl(names(test),pattern="^roll_|^pitch_|^yaw_|^gyros_|^accel_|^magnet_|^classe")]
testdes <- subset(testm,select=-c(classe))
testPCA <- predict(prComp, testdes)

pred  <- predict(modelFitPCA,testPCA)
table(pred,testm$classe)
confusionMatrix(testm$classe,pred)














