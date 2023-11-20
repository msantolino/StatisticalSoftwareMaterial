rm(list=ls())
library(numbers)
fun <- function(x) 
{
   numbers::isPrime(x)
}
# Generate some large integers
N <- 1000 
min <- 100000 
max <- 10000000000 
inputs <- sample(min:max, N) 


system.time(resultsO <- lapply(inputs, fun)) 

library(parallel)
numCores <- detectCores()
system.time(results <- mclapply(inputs, fun, mc.cores = numCores)) #does not work in windows

#install.packages("snow")
#library("snow")
cl <- makeCluster(numCores-1) 
system.time(result <- parLapply(cl, inputs, fun)) #works

stopCluster(cl)#stop cluster in parallel


#install.packages("doParallel")
library(doParallel)
# Get the number of cores
nCores <- detectCores()
cluster <- makeCluster(nCores-1) 
registerDoParallel(cluster)
system.time(results <- foreach (val = inputs, .combine = "c") %dopar% { 
  fun(val) 
})

stopCluster(cluster)#stop cluster in parallel