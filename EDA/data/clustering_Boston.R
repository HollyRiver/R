# section 13.2
library(MASS)
data(Boston)
names(Boston)
zBoston <- scale(Boston[,-14])
clusters <- kmeans(zBoston,4)
names(clusters)
table(clusters$cluster, dnn="cluster number")
round(clusters$centers[, c(1,5,6,7,8,13)], 2)
clusters$totss
clusters$tot.withinss

boxplot(Boston$medv ~ clusters$cluster, main="Boston Housing", 
    xlab="clusters", ylab="medv", ylim=c(0,60))

index <- rep(0,10)
for (k in 1:10) index[k] <- kmeans(zBoston, k)$tot.withinss
plot(index, ylim=c(0,7000), main="Boston k-means", 
    xlab="number of clusters", ylab="tot.withinss")

clusters <- kmeans(zBoston,4, nstart=10)
clusters$tot.withinss

# section 13.3
R <- cor(Boston[,-14])
p <- nrow(R)
D <- as.dist(matrix(1,p,p) - R)
round(D,2)
var.cluster <- hclust(D, method="complete")
plot(var.cluster, xlab="", sub="")
cluster <- cutree(var.cluster, h=1)

var.1 <- (cluster==1)
round(R[var.1,var.1],2)
var.2 <- (cluster==2)
round(R[var.2,var.2],2)

# section 13.4
pca.1 <- princomp(zBoston[, var.1], cor=T)
par(mar=c(4,4,6,4), oma=c(2,2,0,0))
biplot(pca.1, scale=0, cex=0.8, xlab="First Dim", ylab="Second Dim", 
    xlim=c(-5,5), ylim=c(-5,5), main="Boston Housing",
    col=c("gray","red"))
x11()
plot(pca.1$scores[,1:2], xlab="First Dim", ylab="Second Dim", 
    xlim=c(-5,5), ylim=c(-5,5), main="Boston Housing",
    col=c("#FF000077","#00FF0077","#0000FF77","#FF00FF77")[clusters$cluster],
    pch=c(15,16,22,21)[clusters$cluster])
legend("topleft", legend=c("cluster1","cluster2","cluster3","cluster4"),
    col=c("#FF000077","#00FF0077","#0000FF77","#FF00FF77"),
    border="white",
    pch=c(15,16,22,21))

pca.2 <- princomp(zBoston[, var.2], cor=T)
par(mar=c(4,4,6,4), oma=c(2,2,0,0))
biplot(pca.2, scale=0, cex=0.8, xlab="First Dim", ylab="Second Dim", 
    xlim=c(-5,5), ylim=c(-5,5), main="Boston Housing",
    col=c("gray","red"))
x11()
plot(pca.2$scores[,1:2], xlab="First Dim", ylab="Second Dim", 
    xlim=c(-5,5), ylim=c(-5,5), main="Boston Housing",
    col=c("#FF000077","#00FF0077","#0000FF77","#FF00FF77")[clusters$cluster],
    pch=c(15,16,22,21)[clusters$cluster])
legend("topleft", legend=c("cluster1","cluster2","cluster3","cluster4"),
    col=c("#FF000077","#00FF0077","#0000FF77","#FF00FF77"),
    border="white",
    pch=c(15,16,22,21))

# end


