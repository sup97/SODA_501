###
### Claire Kelling
### Exercise Due 1/25, SODA 501
###
### Created 1/15/2018 to work on problem 6 in Bit by Bit, Salganik
### 
### 

#load in data
n_gram <- read.table("C:/Users/ckell/Downloads/googlebooks-eng-all-1gram-20120701-1.txt",skip =5000000, fill = TRUE, nrow = 5000) 
total_counts <- read.table("C:/Users/ckell/Downloads/googlebooks-eng-all-totalcounts-20120701.txt",sep="\t", fill = TRUE)

#need to get in the form of a dataframe
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

tot_count <- tot_count[-1,]

#read full data, 11:33
n_gram <- read.table("C:/Users/ckell/Downloads/googlebooks-eng-all-1gram-20120701-1.txt",fill = TRUE) 

#column names
colnames(tot_count) <- c("ngram", "match_count", "page_count", "volume_count") #per year
rownames(tot_count) <- c()
colnames(n_gram) <- c("ngram", "year", "match_count", "volume_count")

n_gram$ngram <- as.character(n_gram$ngram)

#find the entries that have these mentions
ind_1883 <- which(n_gram$ngram == "1883")
ind_1910 <- which(n_gram$ngram == "1910")
ind_1950 <- which(n_gram$ngram == "1950")

#remove the large file from memory
rm(n_gram)
#save the indices
#save(ind_1883, ind_1910, ind_1950, file = "C:/Users/ckell/Downloads/ind_keep.R")

#now, load a subset of the data
load(file = "C:/Users/ckell/Downloads/ind_keep.R")
n_gram_1883 <- read.table("C:/Users/ckell/Downloads/googlebooks-eng-all-1gram-20120701-1.txt",skip =ind_1883[1], fill = TRUE, nrow = length(ind_1883)) 
