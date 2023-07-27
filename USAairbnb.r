library(ggplot2)
airbnb<-read.csv('USAirbnb.csv',stringsAsFactors=TRUE)
airbnb<- subset(airbnb, select = -c(X) )
#cancel<-read.csv('Cancel.csv',stringsAsFactors = TRUE)
airbnb$State = toupper(airbnb$State)
count(airbnb,'State')

#Correlations
cor(as.numeric(airbnb$MinimumNights), airbnb$Price)


#Visualization 1 - box plot between Room Type and Price
bpproptype<-boxplot(Price~RoomType,data=airbnb, xlab="Room Type",ylab="Price ($USD)",outline=FALSE,col=colorsboxplot, main="Price of Different Room Types")
colorsboxplot<-c("#DC8665","#138086","#534666")

#Visualization 2 - box plot between Bed Type and Price
bpproptype<-boxplot(Price~BedType,data=airbnb, xlab="Bed Type",ylab="Price ($USD)",outline=FALSE,col=colorsboxplot, main="Price of Different Bed Types")
colorsboxplot<-c("#DC8665","#138086","#534666","#CD7672","#EEB462")
library(plyr)
count(airbnb,'BedType')

#Visualization 3 - scatter plot between Host Response Rate and Price NOT INSIGHTFUL
ggplot(data=airbnb) + geom_point(aes(x=HostResponseRate,y=Price)) + xlab("Host Response Rate") + ylab("Price ($USD)")

#Visualization 4 - scatter plot between Total Listings Count and Price NOT INSIGHTFUL
ggplot(data=airbnb) + geom_point(aes(x=HostTotalListingsCount,y=Price)) + xlab("Host Listings") + ylab("Price ($USD)")

#Visualization 5 - box plot between Property Type and Price
bpproptype<-boxplot(Price~PropertyType,data=airbnb, main="Price for different Property Types",xaxt="n",ylab="Price ($USD)",col=colorsboxplot,outline=FALSE)
axis(side = 1, labels = FALSE)
text(x = 1:26,
     y = par("usr")[3],
     xpd = NA,
     srt = 45,
     xpd = NA,
     labels = bpproptype$names, adj=1
)

#Visualization 6 - bar graph between accomodates and Price
accombar<-ggplot(data=airbnb) + geom_bar (aes(x=Accommodates, y=Price),stat="summary",fun="mean",fill=colorsbarchart)
colorsbarchart<-c("#DC8665","#138086","#534666","#CD7672","#EEB462","#DC8665","#138086","#534666","#CD7672","#EEB462","#DC8665","#138086","#534666","#CD7672","#EEB462","#DC8665","#138086")
accombar+labs(x="Accommodates (# of people)",y="Price ($USD)")+ggtitle("Average Price for different Accommodation numbers")

#Visualization 7 - bathrooms vs price
colorsbarchart<-c("#DC8665","#138086","#534666","#CD7672","#EEB462","#DC8665","#138086","#534666","#CD7672","#EEB462","#DC8665")
colorsbarchart<-c("#DC8665","#138086","#534666","#CD7672","#EEB462","#DC8665","#138086","#534666","#CD7672","#EEB462","#DC8665","#138086","#534666","#CD7672","#EEB462","#DC8665","#138086")
ggplot(data=airbnb) + geom_bar (aes(x=Beds, y=Price),stat="summary",fun="mean",fill=colorsbarchart) +ggtitle("Average Price for different Bed numbers")+labs(y="Price ($USD)")

#Visualiztion 8 - cancellation policy
library(plyr)
count(airbnb,'Zipcode')
count(airbnb,'CancellationPolicy')

#Classification process
library(dplyr)

group_mean <- aggregate(airbnb$Price, list(airbnb$CancellationPolicy), mean)
colorsbarchart<-c("#DC8665","#138086","#534666","#CD7672","#EEB462","#DC8665","#138086")
ggplot(data=airbnb) + geom_bar (aes(x=CancellationPolicy, y=Price),stat="summary",fun="mean",fill=colorsbarchart) +ggtitle("Average Price for different Cancellation Policies")+labs(y="Price ($USD)")
colorsboxplot<-c("#DC8665","#138086","#534666","#CD7672")
Means<-c(141.5191,136.6497, 177.0045,348.8757)
Titles<-c("Flexible","Moderate","Strict","Super Strict")
barplot(Means,names.arg=Titles,xlab="Cancellation Policy",ylab="Price ($USD)",col=colorsboxplot,ylim=c(0,350),
        main="Price for different Cancellation Policies")

#Visualization 9 - Guests Included
colorsbarchart<-c("#DC8665","#138086","#534666","#CD7672","#EEB462","#DC8665","#138086","#534666","#CD7672","#EEB462","#DC8665","#138086","#534666","#CD7672","#EEB462","#DC8665","#138086","#534666","#CD7672")
ggplot(data=airbnb) + geom_bar (aes(x=GuestsIncluded, y=Price),stat="summary",fun="mean", fill=colorsbarchart) +ggtitle("Average Price for different number of guests")+labs(y="Price ($USD)")


#Visualization 10 - Extra People,MinimumNights,MaximumNights NOT INSIGHTFUL
colorsbarchart<-c("#DC8665","#138086","#534666","#CD7672","#EEB462","#DC8665","#138086","#534666","#CD7672","#EEB462","#DC8665","#138086","#534666","#CD7672","#EEB462","#DC8665","#138086","#534666","#CD7672")
ggplot(data=airbnb) + geom_point(aes(x=MinimumNights,y=Price)) + xlab("Extra Guests") + ylab("Price ($USD)") +xlim(0,100)


#Visualization 11 - Zip codes
ggplot(data=airbnb)+geom_bar(aes(x=Zipcode, y=Price), stat="summary",fun="mean")
zipcount<-count(airbnb,'Zipcode')
tbdeleted<-zipcount[zipcount$freq<100,]
airbnb<-airbnb[!(airbnb$Zipcode %in% tbdeleted$Zipcode),]


#Delete unreviewed
library(tidyr)
airbnbonlyreview<-airbnb
airbnbonlyreview<-airbnbonlyreview[!is.na(airbnbonlyreview$ReviewScoresRating),]

#Classification of reviews
library(dplyr)
airbnbonlyreview<-airbnbonlyreview %>%
  mutate(Review = case_when(
    ReviewScoresRating>=95 ~ "Good",
    ReviewScoresRating<95 ~ 
       "Bad"
  ))

good<-airbnbonlyreview[airbnbonlyreview$Review=="Good",]
bad<-airbnbonlyreview[airbnbonlyreview$Review=="Bad",]
reviewcount<-count(airbnbonlyreview,'Review')

#Classification Tree
selected.var <- c(21, 28, 29, 30, 31, 32, 33, 34, 36, 42, 44:151) #current

#high correlation
selected.var <- c(21, 28, 29, 30, 31, 32, 33, 34, 36,42, 44:47,50:54,56:61,65,68,76,78:82, 93,97:99, 101,102,105,109, 114:117,120:122,127,133,135,138,140,144,145,149,150,151)

#selected.var of things that can change
selected.var <- c(34,44:151)
#amenities
selected.var<- c(44:151)
#All the data
selected.df <- airbnbonlyreview[, selected.var]
set.seed(100)
train.index <- sample(1:nrow(selected.df), nrow(selected.df)*0.6)
# Build training and validation set by indexing
train.df <- selected.df[train.index, ]
valid.df <- selected.df[-train.index, ]
# if not installed, run:
# install.packages(“rpart”)
library(rpart)
# if not installed, run:
# install.packages(“rpart.plot”)
library(rpart.plot)
default.ct <- rpart(Review ~ ., data = train.df, method = "class",control = rpart.control(maxdepth =10, minbucket =  10))
## plot tree
rpart.plot(default.ct, extra = 1)
#Predict
default.ct.point.pred <- predict(default.ct, valid.df, type = "class")
confusionMatrix(default.ct.point.pred, factor(valid.df$Review))

##full tree
full.ct <- rpart(Review ~ ., data = train.df, method = "class", control = rpart.control(cp = -1, minsplit = 1))
##plot full tree
rpart.plot(full.ct,extra=1)

library(caret)

count(train.df,'Review')
count(valid.df,'Review')


#Label Encoding
library(CatEncoders)
labs = LabelEncoder.fit(airbnb$PropertyType)
airbnb$PropertyType = transform(labs, airbnb$PropertyType)
labs2 = LabelEncoder.fit(airbnb$RoomType)
airbnb$RoomType = transform(labs2, airbnb$RoomType)
labs3 = LabelEncoder.fit(airbnb$BedType)
airbnb$BedType = transform(labs3, airbnb$BedType)
labs4 = LabelEncoder.fit(airbnb$Zipcode)
airbnb$Zipcode = transform(labs4, airbnb$Zipcode)

#Modelling
count(airbnb,'State')
airbnb$BedType<-as.numeric(as.character(airbnb$BedType))
#68,76, 93,140
selected.var <- c(21, 28, 29, 30, 31, 32, 33, 34, 36, 41,42, 44:47,50:54,56:61,65,68,76,78:82, 93,97:99, 101,102,105,109, 114:117,120:122,127,133,135,138,140,144,145,149,150)
selected.var <- c(21, 28, 29, 30, 31, 32, 33, 34, 36, 41,42, 44:150) #current
#amenities
selected.var<- c(44:150)

#All the data
selected.df <- airbnb.norm[, selected.var]

#

#Cali data
selected.var <- c(21, 28, 29, 30, 31, 32, 33, 34, 36, 41,42, 44:150)
california<-airbnb.norm[airbnb.norm$State=="CA",]
selected.df<-california[,selected.var]

#NY data
newyork<-airbnb[airbnb$State=="NY",]
selected.df<-newyork[,selected.var]

#Normalize price
library(caret)
# compute mean and standard deviation of each column
#norm.values <- preProcess(airbnb, method=c("center", "scale"))
# we perform the transformation/normalization
airbnb.norm$Price<-log(airbnb$Price)
airbnb.norm$Accommodates<-log(airbnb.norm$Accommodates)
airbnb.norm <- airbnb
selected.var <- c(21, 28, 29, 30, 31, 32, 33, 34, 36, 41,42, 44:150)
selected.var <- c(21, 28, 29, 30, 31, 32, 33, 34, 36, 41,42)
set.seed(300) 
selected.df<-airbnb.norm[,selected.var]
train.index <- sample(1:nrow(selected.df), nrow(selected.df)*0.75)  
train.df <- selected.df[train.index, ]
valid.df <- selected.df[-train.index, ]
#str(train.df)

bnb.lm<-lm(Price~., data=train.df)
abc<-summary(bnb.lm)

write.csv("summarybnblm.csv",abc)

#str(selected.df)
set.seed(100) 
train.index <- sample(1:nrow(selected.df), nrow(selected.df)*0.75)  
train.df <- selected.df[train.index, ]
valid.df <- selected.df[-train.index, ]
#str(train.df)

bnb.lm<-lm(Price~., data=train.df)
summary(bnb.lm)

calibnb.lm <- lm(Price~., data = train.df)
summary(calibnb.lm)

newyork.lm<-lm(Price~.,data=train.df)
summary(newyork.lm)

options(scipen = 999)
options(max.print=999999)
summary(bnb.lm)

library(plyr)
count(train.df,'CancellationPolicy')
count(valid.df,'CancellationPolicy')
valid.df<-valid.df[valid.df$CancellationPolicy!="long_term",]
bnb.lm.pred <- predict(bnb.lm, valid.df)
library(forecast)

#  use options() to ensure numbers are not displayed in scientific notation.
options(scipen=999)

# use accuracy() to compute common accuracy measures.
accuracy(bnb.lm.pred, valid.df$Price)

plot(bnb.lm.pred,valid.df$Price)

#Classification tree for cali data
selected.var<- c(44:151)
california<-airbnbonlyreview[airbnbonlyreview$State=="CA",]
selected.df<-california[,selected.var]
set.seed(100) 
train.index <- sample(1:nrow(selected.df), nrow(selected.df)*0.6)  
train.df <- selected.df[train.index, ]
valid.df <- selected.df[-train.index, ]
default.ct <- rpart(Review ~ ., data = train.df, method = "class",control =0)
rpart.plot(default.ct, extra = 1)
default.ct.point.pred <- predict(default.ct, valid.df, type = "class")
confusionMatrix(default.ct.point.pred, factor(valid.df$Review))







