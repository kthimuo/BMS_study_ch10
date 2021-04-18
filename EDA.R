library(ggplot2)
data <- read.csv('~/BMS/ch08/SSPI2015.csv')

#年収が0または2500万以上は除外
data <- data[data$Y>0 & data$Y<2500,]

ggplot(data, aes(x = Y))+ geom_histogram(bins=18)

data$log_Y <- log(data$Y) 
data$FEM <- as.character(data$FEM)

ggplot(data, aes(x = Y))+ geom_histogram(position = "identity", fill="blue", colour="black",bins=18)

ggplot(data, aes(x = log_Y))+ geom_histogram(position = "identity", fill="blue", colour="black",bins=12)

ggplot(data, aes(x = log_Y, fill=FEM))+ geom_histogram(position = "identity",alpha=0.6,bins=12) 
