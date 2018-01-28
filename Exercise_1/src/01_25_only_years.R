###
### Claire Kelling
### Exercise Due 1/25, SODA 501
###
### Created 1/17/2018 to subset data to be only years, to create half-life graph
### 

library(dplyr)
library(ggplot2)
#   Laptop:
setwd("C:/Users/ckell/OneDrive/Penn State/2017-2018/01_Spring/SODA_501/SODA_501")

#read in total counts
total_counts <- read.table("data/googlebooks-eng-all-totalcounts-20120701.txt",sep="\t", fill = TRUE)
#total_counts <- read.table("/storage/home/cek32/work/googlebooks-eng-all-totalcounts-20120701.txt",sep="\t", fill = TRUE)
#read full n gram data
n_gram <- read.table("/storage/home/cek32/work/googlebooks-eng-all-1gram-20120701-1.txt",fill = TRUE) 

#need to get the total counts data in the form of a dataframe
mat <- t(as.matrix(total_counts))
total_counts <- as.data.frame(mat)
rownames(total_counts) <- c()
total_counts$V1 <- as.character(total_counts$V1)
total_counts <- total_counts[-c(1,427),]
total_counts <- as.data.frame(total_counts)
total_counts$total_counts <- as.character(total_counts$total_counts)

#separate by commas
tot_count <- NA
for(i in 1:nrow(total_counts)){
  row <- unlist(strsplit(total_counts[i,1], ","))
  tot_count <- rbind(tot_count, row)
}
tot_count <- tot_count[-1,] #first row is NA

###clear up workspace
rm(total_counts, mat, row, i)
###

#column names
colnames(tot_count) <- c("year", "match_count", "page_count", "volume_count") #per year
rownames(tot_count) <- c()
colnames(n_gram) <- c("ngram", "year", "match_count", "volume_count")
tot_count <- as.data.frame(tot_count)

#only using a subset of the data, between 1875 and 2000
tot_count <- tot_count[which(tot_count$year %in% 1875:2000),]
n_gram <- n_gram[which(n_gram$year %in% 1875:2000),]

#it is a factor variable, change to character
n_gram$ngram <- as.character(n_gram$ngram)

load("data/n_gram_year.Rdata")
#need to convert this to a character variable with only four elements
n_gram <- n_gram[which(nchar(n_gram$ngram) ==4),]
n_gram <- n_gram[!is.na(as.numeric(n_gram$ngram)), ]
# still includes periods
n_gram2 <- n_gram
n_gram$ngram <- as.numeric(n_gram$ngram) #convert to numeric
n_gram <- n_gram[which(nchar(n_gram$ngram) ==4),] # need to again filter after removing periods
n_gram <- n_gram[which(n_gram$ngram %in% 1875:2000),] #only include certain years

#save(n_gram, file = "/storage/home/cek32/work/n_gram_year.Rdata")

# divide n_gram uses of year by the total n_gram's in that year
tot_count$year <- as.numeric(as.character(tot_count$year))
n_gram <- left_join(n_gram, tot_count[,1:2], by = c(year = "year"))

#need to compute proportion
n_gram$match_count.y <- as.numeric(as.character(n_gram$match_count.y))
n_gram$prop <- n_gram$match_count.x/n_gram$match_count.y

#now I need to calculate the half-life for each of these years
hl1 <- NA
for(i in 1875:1975){
    n_gram_new <- n_gram[which(n_gram$ngram == i),]
    #find half-life for 1883
    ind_max <- which(n_gram_new$prop == max(n_gram_new$prop))
    #ind_max <- ind_max[1]
    ind_hl <- min(which(n_gram_new$prop[ind_max:nrow(n_gram_new)] < max(n_gram_new$prop)/2))-1+ind_max
    hl2 <- n_gram_new$year[ind_hl] - n_gram_new$year[ind_max]
    hl1 <- rbind(hl1, hl2)
}

hl1 <- hl1[-1]

half_life_df <- cbind(1875:1975, hl1)
colnames(half_life_df) <- c("Year", "half_life")
half_life_df <- as.data.frame(half_life_df)

of_interest <- half_life_df[which(half_life_df$Year %in% c(1883, 1910, 1950)),]

fig3_sm <- ggplot() + geom_point(data = half_life_df, aes(x=Year, y=half_life), col= "grey",size=2)+
  geom_point(data = of_interest, aes(x=Year, y=half_life, col = "red"), size=4)+
  labs(x="Year", y="Half-life (yrs)")+theme(legend.position = "none")
