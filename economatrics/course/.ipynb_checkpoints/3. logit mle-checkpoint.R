rm(list = ls(all=T)) # This code clears all. 

###############################################################################
#--------------G function------------------------------------------------------
###############################################################################
z=seq(-6, 6, length=100)

G <- function(z) {
  exp(z)/(1+exp(z)) 
}

y=G(z)

dev.new()
plot(z,y, xlab=expression(z),type='l', ylab=expression(pi))


#######################################################################
#------load the data for the labor market participation example--------
#######################################################################

load("F:\\teaching\\Econometrics\\lecture_2022\\R_code\\logit\\mroz.RData")
#ls() #give the names of the objects in the specified environment.
#desc #return the list of variables

head(data) #show the head of the dataset

inlf <- data$inlf #this variable (y=inlf) has either 1 or 0
nwifeinc <- data$nwifeinc
educ <- data$educ
exper <- data$exper
exper2 <- exper^2
age <- data$age
kidslt6 <- data$kidslt6 
kidsge6 <- data$kidsge6


################################################################################
#--------------------MLE: Logit Model-------------------------------------------
################################################################################

#pi=G(X*beta)
#pi is the probability of y=1. 

#minus log-likelihood function
logit_mle <- function(theta_logit){

   X.beta <- theta_logit[1] + theta_logit[2]*kidslt6 + theta_logit[3]*educ  #updated version of (1)
   sum ( -inlf*log( G(X.beta) )-(1-inlf)*log( 1-G(X.beta) ) )
}

#estimation of the model using optim().
logit_out <- optim(theta_logit <- c(-0.4, -1.50, 0.30),
                   method = "BFGS",  
                   logit_mle, 
                   hessian=TRUE) 

estimate<-logit_out$par
estimate

information.m <- logit_out$hessian # I=-Hessian
var.beta <- solve(information.m)   # variance=(I)^(-1)
var.beta #variance-covariance matrix

se <-sqrt(diag(var.beta)) #The function diag takes the diagnal elements. 
se

t <-estimate/se
t

beta<-c("beta0", "beta1", "beta2")
output<-data.frame(beta, estimate, se, t)
output


#################################################################################
#--------------------------contour for logit model-------------------------------
#################################################################################
beta0 <- -2.05 #beta0 is fixed at its estimate based on the logit model
beta1 <- seq(-4.0,2.0,0.01)
beta2 <- seq(0.0,0.4,0.01)
pars <- as.matrix(expand.grid(beta0, beta1, beta2)) #grid points with beta0 fixed at -2.05

head(pars)
tail(pars)
nrow(pars)

#Creat a matrix to save likelihood values
loglik<-matrix(data = NA, nrow = nrow(pars), ncol = 1) #likelihood values will be saved in loglik. 

#Compute likelihood values based on the parameter set
 for(i in 1:nrow(pars)){
    theta<-pars[i,]
    loglik[i,1]<-c(logit_mle(theta = theta)) #logit_mle is defined above
 }

head(loglik)

#Put log likelihood values into matrix - need to be careful about ordering
loglik.mat<-matrix(data = loglik, nrow = length(beta1), 
    ncol = length(beta2), byrow = FALSE)

dev.new()
contour(x = beta1, y = beta2, z = -loglik.mat,  xlab = 
    expression(beta[1]), ylab = expression(beta[2]), main = 
    "contour plot of likelihood")

abline(v = logit_out$par[2], col = "blue")
abline(h = logit_out$par[3], col = "blue")

#################################################################################
#--------------------------3D plot-----------------------------------------------
#################################################################################
help(persp3D)

install.packages("plot3D")
library(plot3D) #Package for 3D interactive plots

#3D plot with gridlines 
dev.new()
persp3D(x = beta1, y = beta2, z = -loglik.mat,  
        xlab = "beta[1]", ylab = "beta[2]", zlab = "log-likilihood", 
        ticktype = "detailed", 
        #r=3,
        shade=0.1,
        #image=TRUE,
        #contour=TRUE,
        theta=60, phi=40, expand=0.6 #set the view point
)


#################################################################################
#-------------------------plot: labor market participation-----------------------
#################################################################################
#pi=G(X*beta) for the logit model
#pi=X*beta for the linear probability model

kidslt6.x <- seq(0, 7, length=8)

#college degree
educ.x <- 16
X_beta <- estimate[1]+estimate[2]*kidslt6.x+estimate[3]*educ.x #X*beta
pi <- G(X_beta)

#high school degree
educ.x <- 12
X_beta <- estimate[1]+estimate[2]*kidslt6.x+estimate[3]*educ.x
pi12 <- G(X_beta)

dev.new()
plot(kidslt6.x, pi, pch=16, col="blue", cex=2, ylab="probability", xlab="number of kids under age 6")
points(kidslt6.x, pi12, pch=16, col="red", cex=2)

legend(x="topright", legend=c("college degree", "high school degree"), 
       col=c("blue","red"), lty=1, pch=16, cex=1.3)




##################################################################################
#-----------linear versus logit model with more explanatory variables-------------
##################################################################################

########################################################################
#                  logit model: pi=G(X*beta) 
########################################################################

#-----------------estimation-------------------------------------------#
out.logit2 <- glm(inlf ~ nwifeinc+educ+exper+exper2+age+kidslt6+kidsge6, 
                  data=data, family=binomial("logit")) 
out.logit<-summary(out.logit2)
b<-out.logit$coefficients[,1] #estimates
b

#--------case 1: college degree-------------------

nwifeinc.f <- 35 #income=$35,000
educ.f <- 16     #college degree
exper.f <- 5     #5 years of experience 
age.f <- 30
kidslt6.f <- seq(0, 7, length=8) #number of kids less than 6
kidsge6.f <-0    #number of kids greater than 6

X.beta <-b[1]+b[2]*nwifeinc.f+b[3]*educ.f+b[4]*exper.f+b[5]*exper.f^2+
              b[6]*age.f+b[7]*kidslt6.f+b[8]*kidsge6.f #X*beta

pi16 <- G(X.beta) #probability of participating in the labor market

#-----case 2: high school degree------------------
educ.f <- 12     
X.beta <-b[1]+b[2]*nwifeinc.f+b[3]*educ.f+b[4]*exper.f+b[5]*exper.f^2+
              b[6]*age.f+b[7]*kidslt6.f+b[8]*kidsge6.f #X*beta

pi12 <- G(X.beta) #probability of participating in the labor market

#-----case 3: middle school degree------------------
educ.f <- 9     
X.beta <-b[1]+b[2]*nwifeinc.f+b[3]*educ.f+b[4]*exper.f+b[5]*exper.f^2+
              b[6]*age.f+b[7]*kidslt6.f+b[8]*kidsge6.f #X*beta

pi9 <- G(X.beta) #probability of participating in the labor market


#-----plot the relationship between the probability and kidslt6------------------------
dev.new()
plot(kidslt6.f, pi16, pch=16, col="blue", cex=2, ylab="probability", xlab="number of kids under age 6")
points(kidslt6.f, pi12, pch=16, col="red", cex=2)
points(kidslt6.f, pi9, pch=16, col="orange", cex=2)
abline(v=0, lty="dotted")
abline(v=1, lty="dotted")

legend(x="topright", legend=c("college degree", "high school degree", "middle school degree"), 
       col=c("blue","red","orange"), lty=1, pch=16, cex=1.3)


########################################################################
#                  linear model: pi=X*beta 
########################################################################


############----Linear Probability Model------------##################
out.lm2 <- lm(inlf ~ nwifeinc+educ+exper+exper2+age+kidslt6+kidsge6,data=data);
out.lm<-summary(out.lm2)
b.lm <- out.lm$coefficients[,1] #estimates
b.lm

#--------case 1: college degree-------------------
educ.f <- 16  
X.beta <-b.lm[1]+b.lm[2]*nwifeinc.f+b.lm[3]*educ.f+b.lm[4]*exper.f+b.lm[5]*exper.f^2+
                 b.lm[6]*age.f+b.lm[7]*kidslt6.f+b.lm[8]*kidsge6.f #X*beta
pi16 <-X.beta #probability of participating in the labor market

#-----case 2: high school degree------------------
educ.f <- 12     
X.beta <-b.lm[1]+b.lm[2]*nwifeinc.f+b.lm[3]*educ.f+b.lm[4]*exper.f+b.lm[5]*exper.f^2+
                 b.lm[6]*age.f+b.lm[7]*kidslt6.f+b.lm[8]*kidsge6.f #X*beta
pi12 <-X.beta #probability of participating in the labor market

#-----case 3: middle school degree------------------
educ.f <- 9     
X.beta <-b.lm[1]+b.lm[2]*nwifeinc.f+b.lm[3]*educ.f+b.lm[4]*exper.f+b.lm[5]*exper.f^2+
                 b.lm[6]*age.f+b.lm[7]*kidslt6.f+b.lm[8]*kidsge6.f #X*beta
pi9 <-X.beta #probability of participating in the labor market


#-----plot the relationship between the probability and kidslt6------------------------
dev.new()
plot(kidslt6.f, pi16, pch=16, col="blue", cex=2, ylab="probability", xlab="number of kids under age 6")
points(kidslt6.f, pi12, pch=16, col="red", cex=2)
points(kidslt6.f, pi9, pch=16, col="orange", cex=2)
abline(v=0, lty="dotted")
abline(v=1, lty="dotted")

legend(x="topright", legend=c("college degree", "high school degree", "middle school degree"), 
       col=c("blue","red","orange"), lty=1, pch=16, cex=1.3)
