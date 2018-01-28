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




###
### Problem 2
###


#possible terms: "Harvey_Weinstein", "Me_Too_(hashtag)", "James_Comey"
page_v <- article_pageviews(article = "Michael_Flynn", end = "2018100100")

ggplot(data=page_v, aes(x=date, y = views))+geom_point()

##
# Aggregate data by months, instead of dates
##
page_v$month <- cut(page_v$date, breaks = "month")
page_v <- page_v[,c("month", "views")]

getsum  <- function(Df) c(views = sum(Df$views))

agg_dat <- ddply(page_v, .(month), getsum)
agg_dat$month <- as.POSIXct(agg_dat$month)

ggplot(data=agg_dat, aes(x=month, y = views))+geom_point()
