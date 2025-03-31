## Date : 2025-03-31
## Author : HollyRiver
## Title : tidyverse 통합 패키지

## 1. 파이프 연산자
library(tidyverse)  ## magrittr이 있어야 파이프연산자가 동작

x <- 1:10
x |> sum()
x %>% sum()
x %>% sum