
#--------------------hOmework 2------------------------------------------------

# We learned the following R code in class. Answer the following questions using this code. 

#------------example: Scatter Plot---------------------------------
n<-1000
x<-4+rnorm(n,mean=1,sd=5)
y<-1+2*x+rnorm(n,mean=0,sd=4)

dev.new()
plot(x,y, pch=16, col="blue", 
     main=expression(paste("Sampling under ", beta[0], 
                           "=1", " ", "and", " ", beta[1], "=2")))
text(10, 2, "scatter plot", cex=1.5)
abline(a=1,b=2, col="red", lwd=3)


#------------------------------------------------------------------
# question 1: Compute the mean values of x and y using "for loop"!
#             Do not use built-in functions!!! 



#------------------------------------------------------------------
# question 2: Compute the covariance between x and y using "for loop"!
#             Do not use built-in functions!!! 



#------------------------------------------------------------------
# question 3: Compute the variance x using "for loop"!
#             Do not use built-in functions!!! 



#--------------------------------------------------------------------------
# question 4: Compute the parameter beta[1] (slope of the regression line)!

