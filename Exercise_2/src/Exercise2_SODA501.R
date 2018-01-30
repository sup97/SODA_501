###
### Claire Kelling
### SODA 501 Exercise 2
###
### Created 1/28/18 for work on Exercise 2 about regression discontinuity
### 

library(pageviews)
library(ggplot2)
library(lattice)
library(plyr)

###
### Problem 1
###
terr_trend <- read.csv("C:/Users/ckell/OneDrive/Penn State/2017-2018/01_Spring/SODA_501/SODA_501/Exercise_2/data/multiTimeline.csv")

#subset data to match paper figure
terr_trend <- terr_trend[102:126,]

#convert month to date variable in R
terr_trend$date <- as.Date(paste(terr_trend$Month,"-01",sep=""))
colnames(terr_trend) <- c("month", "views", "date")

#plot
ggplot(data=terr_trend, aes(x=date, y = views))+geom_point()+
  geom_smooth(data=terr_trend[1:114,], method="lm")+ #for full dataset, 114
  geom_smooth(data=terr_trend[115:169,], method="lm")+ #for full dataset, 169
  labs(title = "Searches of 'Terrorism' Over Time", subtitle = "Pre and post 06/2013")

###
### Problems 2 and 3
###


#increases: "Harvey_Weinstein", "Me_Too_(hashtag)", "James_Comey", "Bitcoin", "cryptocurrency"
#                 "Las_Vegas", "Fidget_spinner", "Ed_Sheeran"
#decreases: "Obama"
page_v <- article_pageviews(article = "Harvey_Weinstein", end = "2018100100")

ggplot(data=page_v, aes(x=date, y = views))+geom_point()

##
# Aggregate data by months, instead of dates
##
page_v$month <- cut(page_v$date, breaks = "month")
page_v <- page_v[,c("month", "views")]

getsum  <- function(Df) c(views = sum(Df$views))

agg_dat <- ddply(page_v, .(month), getsum)
agg_dat$month <- as.POSIXct(agg_dat$month)

ggplot(data=agg_dat, aes(x=month, y = views))+geom_point()+labs(title = "PageViews of 'Harvey Weinstein' Over Time", subtitle = "Pre and post Hollywood Scandal")



#Regression discontinuity plots
# Cutoffs rows: 
#     Harvey Weinstein, 24
#     Obama, 21
#     Ed Sheeran, 16
cutoff <- 24

#plot
ggplot(data=agg_dat, aes(x=month, y = views))+geom_point()+
  geom_smooth(data=agg_dat[1:cutoff,], method="lm")+
  geom_smooth(data=agg_dat[(cutoff+1):nrow(agg_dat),], method="lm")+ #labs(title = "PageViews of 'Ed Sheeran' Over Time", subtitle = "Pre and post 'Shape of You' Release")
  #labs(title = "PageViews of 'Obama' Over Time", subtitle = "Pre and post Election")
 labs(title = "PageViews of 'Harvey Weinstein' Over Time", subtitle = "Pre and post Hollywood Scandal")

