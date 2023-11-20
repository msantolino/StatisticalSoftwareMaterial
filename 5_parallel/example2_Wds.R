rm(list=ls())
##Example 2

set.seed(1234)
x <- rchisq(10000, 1.5)
med.boot <- replicate(5000, {
        xnew <- sample(x, replace = TRUE)
        median(xnew)
})
sd(med.boot)




### windows
library(parallel)
numCores<- detectCores()
cl<-makeCluster(numCores)
xs <- rchisq(10000, 1.5)

funX=function(X){
set.seed(1234)
        xnew <- sample(xs, replace = TRUE)
        median(xnew)
}

med.bootW <- parLapply(cl, x=1:5000,funX )#no funciona, no encuentra xs. No hay comunicación
#You’ll notice, unfortunately, that there’s an error in running this code. The reason is that while we have loaded the sulfate data into our R session, the data is not available to the independent child processes that have been spawned by the makeCluster() functio

system.time(lapply(X=1:5000,funX ))#si funciona. Generar los datos una sola vez
sd(unlist(lapply(X=1:5000,funX )))

stopCluster(cl)

###vamos a darle los datos para transportar

cl<-makeCluster(numCores-1)
xs <- rchisq(10000, 1.5)
clusterExport(cl, "xs")
funX=function(X){
	  set.seed(1234)
        xnew <- sample(xs, replace = TRUE)
        median(xnew)
}

med.bootB <- parLapply(cl, X=1:5000,funX )
sd(unlist(med.bootB))#siempre reproduce la misma

system.time(parLapply(cl, X=1:5000,funX ))
stopCluster(cl)

#como conseguir bootstrapping con seed general y datos reproducibles
#############
## si lo pongo global, no son reproducibles 


set.seed(1234)
cl<-makeCluster(numCores)
xs <- rchisq(10000, 1.5)
clusterExport(cl, "xs")
funX=function(X){
        xnew <- sample(xs, replace = TRUE)
        median(xnew)
}

med.bootB2 <- parLapply(cl, X=1:5000,funX )
sd(unlist(med.bootB2))#no reproducible
stopCluster(cl)


###tampoco funciona con lcuster RNGkind
library(doRNG)

RNGkind("L'Ecuyer-CMRG")
set.seed(1234)
cl<-makeCluster(numCores)
xs <- rchisq(10000, 1.5)
clusterExport(cl, "xs")

funX=function(X){
        xnew <- sample(xs, replace = TRUE)
        median(xnew)
}

med.bootB3 <- parLapply(cl, X=1:5000,funX )
sd(unlist(med.bootB3))#siempre reproduce la misma

stopCluster(cl)



###ahora si son reproducibles con doParallel

library(doParallel)
#install.packages("snow")

nCores <- detectCores()
cluster <- makeCluster(nCores-1, type="PSOCK") 
registerDoParallel(cluster)
registerDoRNG(seed = 1234)
x <- rchisq(10000, 1.5)
system.time(med.boot <- foreach (i = 1:5000, .combine = "c") %dopar% { 
        xnew <- sample(x, replace = TRUE)
        median(xnew)
})
sd(med.boot)

stopCluster(cluster)


#boostrapping puedes utilizar boot y también reproducible pero ineficiente

library(boot)
set.seed(1234)
b <- boot(xs, function(x, i) median(x[i]), R = 5000, parallel = "snow", ncpus = (nCores-1))

system.time(b <- boot(xs, function(x, i) median(x[i]), R = 5000, parallel = "multicore", ncpus = (nCores-1)))#ineficiente







