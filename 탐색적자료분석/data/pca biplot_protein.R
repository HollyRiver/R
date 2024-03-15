protein <- read.table("protein.txt", header=T)
protein
pca <- princomp(protein[,2:10], cor=T)
pca
names(pca)
pca$loadings[,1:2]
pca$scores[,1:2]
attach(pca)
plot(scores[,2] ~ scores[,1], main = "Principal Component Space", 
xlim=c(-5,5), ylim=c(-5,5))
text(y=scores[,2], x=scores[,1], label=protein$Country, cex=0.8)
x11()
plot(loadings[,2] ~ loadings[,1], main = "Principal Component 
       Loadings", xlim=c(-1,1), ylim=c(-1,1))
text(y=loadings[,2], x=loadings[,1], label=colnames(protein[,2:10]), 
		cex=0.8)
	for (i in 1:9) {arrows(0,0,0.8*loadings[i,1],0.8*loadings[i,2],
		length = 0.1)}
biplot(pca, xlim=c(-0.5,0.5), ylim=c(-0.5,0.5), xlabs=protein$Country, cex=0.8, main="protein")
