#####################################################
# BALL MAPPER R wrapper
#####################################################

# In this exercise we will play with a classical Boston Property Dataset. 
# It describes the prices of properties in Boston in '70. The task is to 
# understand how they depend on multiple factors. Please consider the following 
# URL for more details https://www.cs.toronto.edu/~delve/data/boston/bostonDetail.html

# Note the list of considered variables. Varianble number 14: MEDV - Median value 
# of owner-occupied homes in $1000's is the descriptive variable we want to 
# understand. In order to avoid extensve file processing, two files boston and 
# boston_prices have been prepared for you. In the code below we read them and 
# create the Ball Mapper plot.

setwd("~/GitHub/BallMapper/")

library(data.table) # to read csv faster

library(Rcpp)
sourceCpp('R/BallMapper.cpp')

source('R/BallMapper_utils.R')


#####################################################
# This is the function to create the standard BM
BallMapperCpp <- function( points , values , epsilon )
{
  output <- SimplifiedBallMapperCppInterface( points , values , epsilon )
  colnames(output$vertices) = c('id','size')
  return_list <- output
}#BallMapperCpp


# load the example 8x8 MNIST dataset
data <- fread('data/boston.tsv', sep='\t', header = FALSE)

sapply(data, class)

# load the labels
prices <- fread('data/boston_prices.tsv', sep=',', header = FALSE)


############################
# BM with full dataset
# create a BM of radius epsilon, and color by the prices 
epsilon <- 100

print("COMPUTING BM")
start <- Sys.time()
BM <- BallMapperCpp(data, prices$V1, epsilon)
print("DONE")
print(Sys.time() - start)
print("SAVING")
# save BM to file
# WARNING to not run more than once, it will corrupt the output files
storeBallMapperGraphInFile(BM, filename = paste0("BM_graphs/boston/", epsilon))
print("THE END")

# plot the BM
ColorIgraphPlot(BM, seed=42)


