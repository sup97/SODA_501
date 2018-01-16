###
### Claire Kelling
### Exercise Due 1/25, SODA 501
###
### Created 1/15/2018 to work on problem 6 in Bit by Bit, Salganik
### 
### 

# packages
# install.packages("ggplot2")
library(ggplot2)

#set working directory:
#   cluster:
#setwd("/storage/home/cek32/work/")
#   BDSS office:
#setwd("C:/Users/cek32/Desktop/OneDrive/Penn State/2017-2018/01_Spring/SODA_501/SODA_501")
#   Laptop:
#setwd("C:/Users/ckell/OneDrive/Penn State/2017-2018/01_Spring/SODA_501/SODA_501")

#load in data on a computer (Laptop or BDSS)
#n_gram <- read.table("data/googlebooks-eng-all-1gram-20120701-1.txt",skip =0, fill = TRUE, nrow = 285) 
#total_counts <- read.table("data/googlebooks-eng-all-totalcounts-20120701.txt",sep="\t", fill = TRUE)
#read full n gram data
#n_gram <- read.table("data/googlebooks-eng-all-1gram-20120701-1.txt",fill = TRUE) 

#load in data on cluster
total_counts <- read.table("/storage/home/cek32/work/googlebooks-eng-all-totalcounts-20120701.txt",sep="\t", fill = TRUE)
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
colnames(tot_count) <- c("ngram", "match_count", "page_count", "volume_count") #per year
rownames(tot_count) <- c()
colnames(n_gram) <- c("ngram", "year", "match_count", "volume_count")
tot_count <- as.data.frame(tot_count)

#it is a factor variable, change to character
n_gram$ngram <- as.character(n_gram$ngram)

#find the entries that have these mentions
ind_1883 <- which(n_gram$ngram == "1883")
ind_1910 <- which(n_gram$ngram == "1910")
ind_1950 <- which(n_gram$ngram == "1950")

#now, load a subset of the data
#load(file = "data/ind_keep.R")
#n_gram_1883 <- read.table("data/googlebooks-eng-all-1gram-20120701-1.txt",skip =ind_1883[1], fill = TRUE, nrow = length(ind_1883)) 
n_gram_1883 <- n_gram[ind_1883,]
n_gram_1910 <- n_gram[ind_1910,]
n_gram_1950 <- n_gram[ind_1950,]

####
#creating the figure 3a in Michel's paper Quantitative analysis of culture using millions
# of digitized books
####

#create combined dataframe
n_gram_dat1 <- rbind(n_gram_1883, n_gram_1910, n_gram_1950)

#plot use of word over the years
fig3a <- ggplot() + geom_line(data=n_gram_1883, aes(x=year, y = match_count), col = "blue") +
  geom_line(data=n_gram_1910, aes(x=year, y = match_count), col = "green")+
  geom_line(data=n_gram_1950, aes(x=year, y = match_count), col = "red") +
  labs(x = "Year", y = "Frequency")

fig3a2 <- ggplot() + geom_line(data=n_gram_1883, aes(x=year, y = match_count, col = ngram))
  labs(x = "Year", y = "Frequency")


#save the image to my directory
ggsave("/storage/home/cek32/work/fig3a.jpg", plot = fig3a)
ggsave("/storage/home/cek32/work/fig3a2.jpg", plot = fig3a2)


#do it in terms of a proportion, instead of a raw count (?)
tot_count$ngram <- as.character(tot_count$ngram)
tot_count$match_count <- as.numeric(as.character(tot_count$match_count))
tot_1883 <- tot_count$match_count[which(tot_count$ngram == "1883")]
tot_1910 <- tot_count$match_count[which(tot_count$ngram == "1910")]
tot_1950 <- tot_count$match_count[which(tot_count$ngram == "1950")]

#compute proportion
n_gram_1883$prop <- n_gram_1883$match_count/tot_1883
n_gram_1910$prop <- n_gram_1910$match_count/tot_1910
n_gram_1950$prop <- n_gram_1950$match_count/tot_1950

#Once again, combine data and plot
n_gram_dat2 <- rbind(n_gram_1883, n_gram_1910, n_gram_1950)

fig3b <- ggplot() + geom_line(data=n_gram_1883, aes(x=year, y = prop), col = "blue") +
  geom_line(data=n_gram_1910, aes(x=year, y = prop), col = "green")+
  geom_line(data=n_gram_1950, aes(x=year, y = prop), col = "red") +
  labs(x = "Year", y = "Proportion")

fig3b2 <- ggplot() + geom_line(data=n_gram_1883, aes(x=year, y = prop, col = ngram))
  labs(x = "Year", y = "Proportion")

#store images in directory
ggsave("/storage/home/cek32/work/fig3b.jpg", plot = fig3b)
ggsave("/storage/home/cek32/work/fig3b2.jpg", plot = fig3b2)

####
## Half-Life problem
####
# half-life = number of years that pass before the proportion of mentions reaches half its peak value

#find half-life for 1883
ind_hl_1883 <- min(which( n_gram_1883$match_count > max(n_gram_1883$match_count)/2))
hl_1883 <- n_gram_1883$year[ind_hl_1883] - n_gram_1883$year[1]

#and for 1910
ind_hl_1910 <- min(which( n_gram_1910$match_count > max(n_gram_1910$match_count)/2))
hl_1910 <- n_gram_1910$year[ind_hl_1910] - n_gram_1910$year[1]

#and for 1950
ind_hl_1950 <- min(which( n_gram_1950$match_count > max(n_gram_1950$match_count)/2))
hl_1950 <- n_gram_1950$year[ind_hl_1950] - n_gram_1950$year[1]


#create a dataframe that combines all of these variables
hl <- cbind(c(1883, 1910, 1950),c(hl_1883, hl_1910, hl_1950))
print("line 133")
hl <- as.data.frame(hl)
print("line 135")
colnames(hl) <- c("Year", "half_life")
print("line 134")
hl$Year <- as.factor(hl$Year)

print("line 141")
#plot the half-lives for these three years (just 3 points)
fig3_sm <- ggplot() + geom_point(data = hl, aes(x=Year, y=half_life, col = Year), size=9)+labs(x="Year", y="Half-life (yrs)")
ggsave("/storage/home/cek32/work/fig3_sm.jpg", plot = fig3_sm)

print("line 145")
