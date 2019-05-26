rm(list=ls())

txt1 <- "X_test.txt"
file1 <-  read.table(txt1, header = T)

txt2 <- "y_test.txt"
file2 <-  read.table(txt2, header = T)

txt3 <- "X_train.txt"
file3 <-  read.table(txt3, header = T)

file4 <-  read.table(txt4, header = T)

txt5 <- "subject_test.txt"
file5 <-  read.table(txt5, header = T)

txt6 <- "subject_train.txt"
file6 <-  read.table(txt6, header = T)

txt7 <- "features.txt"
file7 <-  read.table(txt7, header = F)
file7 <- file7[,2]

txt8 <- "activity_labels.txt"
file8 <-  read.table(txt8, header = F)
colnames(file8) <- c("ID","activity names")

test <- cbind(file1,file2,file5)
colnames(test) <- file7
colnames(test)[562] <- "activity"
colnames(test)[563] <- "subject"

train <- cbind(file3,file4,file6)
colnames(train)  <- file7
colnames(train)[562] <- "activity"
colnames(train)[563] <- "subject"

my_file <- rbind(test,train)

my_file_ms <- my_file[,grep("mean\\()|std()|activity|subject",names(my_file))]

my_file_final <- merge(my_file_ms,file8,by.x="activity",by.y="ID")

names(my_file_final) <- sub("^f","frequency domain signals of",names(my_file_final))
names(my_file_final) <- sub("^t","time domain signals of",names(my_file_final))
names(my_file_final) <- sub("*BodyAcc*"," body acceleration",names(my_file_final))
names(my_file_final) <- sub("*GravityAcc*"," gravity acceleration ",names(my_file_final))
names(my_file_final) <- sub("*BodyGyro*"," body angular velocity",names(my_file_final))
names(my_file_final) <- sub("*Jerk*"," jerk",names(my_file_final))
names(my_file_final) <- sub("*Mag*"," magnitude",names(my_file_final))
names(my_file_final) <- sub("-mean\\()"," in mean value",names(my_file_final))
names(my_file_final) <- sub("*-std\\()"," in standard deviation value",names(my_file_final))
names(my_file_final) <- sub("*-X"," on the x axis",names(my_file_final))
names(my_file_final) <- sub("*-Y"," on the y axis",names(my_file_final))
names(my_file_final) <- sub("*-Z"," on the z axis",names(my_file_final))
names(my_file_final) <- sub("Body","",names(my_file_final))

tidydata <- aggregate(my_file_final[, 2:67], by=list(my_file_final$"subject",my_file_final$"activity names"), mean)
names(tidydata)[1] <- "subject"
names(tidydata)[2] <- "activity names"

write.table(tidydata,file="step 5",row.name=FALSE)
