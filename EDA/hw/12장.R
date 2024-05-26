install.packages("rgl")
install.packages("mclust")
library(rgl)
library(mclust)

data("diabetes")
attach(diabetes)

## 3d plot
dev.new()
rgl::plot3d(glucose, insulin, sspg, col = "blue", size = 3)

## rainbow 3d plot
rgl::plot3d(glucose, insulin, sspg, col = rainbow(nrow(diabetes), start = 0.5), size = 3)

library(MASS)
data(geyser)
attach(geyser)

density1 = kde2d(waiting, duration, n = 25)  ## estimate pdf
open3d()  ## open 3d maps
bg3d("white")  ## background 3d
material3d(col = "blue")  ## setting material options
persp3d(density1$x, density1$y, density1$z, col = "lightblue")

x = glucose
y = insulin
z = sspg
open3d()
points3d(x, y, z, size = 3)

if (interactive()) {
  f = select3d()  ## 마우스 커서로 박스를 그려 그래프의 점을 선택
  keep = f(x, y, z)
  rgl.pop()
  points3d(x[keep], y[keep], z[keep], size = 3, col = "red")
  points3d(x[!keep], y[!keep], z[!keep], size = 3)
}

data("volcano")  ## matrix data
z = 2*volcano
x = 10*(1:nrow(z))  ## 10 meter spacing East to West
y = 10*(1:ncol(z))  ## South to North
zlim = range(z)
zlen = zlim[2] - zlim[1] + 1  ## z를 몇 개의 색으로 나눌 것인지(0~1)
colorlut = terrain.colors(zlen)  ## 지형 색상, 숫자만 입력하면 알아서 나눠줌
col = colorlut[z-zlim[1]+1]  ## z 값에 따른 색상 할당
open3d()
surface3d(x, y, z, col = col, back = "lines")

library(rJava)
library(iplots)

data(iris)
attach(iris)
ibar(Species)
ihist(Sepal.Length)
ihist(Sepal.Width)

iplot(Sepal.Length~Sepal.Width)
iplot(Petal.Length~Petal.Width)


library(lattice)
data("quakes")
attach(quakes)
depth_grp = trunc((depth-min(depth)+0.5)/(max(depth)-min(depth)+1)*4)  ## 0~1의 값으로 만들고 4를 곱하는 방법으로 그룹화
ibox(mag, depth_grp)
iplot(long, lat)


data(Cars93)
attach(Cars93)
imosaic(AirBags, Cylinders, Origin)
imosaic(Type, Man.trans.avail)


install.packages("tourr")
