# Skrip untuk membuat plot klasifikasi
# pada tulisan "Klasifikasi"
# oleh Okiriza, Agustus 2015


library(ggplot2)

N = 20
POINT_SIZE = 4
set.seed(7)

prev_views = rpois(N, 3) + 1
prev_trans = rpois(N, 2)

aesthetics = aes(prev_views, prev_trans, col=unsure)
x_lab = xlab('# views on item')
y_lab = ylab('# transactions in last 6 months')

unsure = rep('No', N)
unsure[prev_views > 5] = "Yes"
X = data.frame(prev_views=prev_views, prev_trans=prev_trans, unsure=unsure)
ggplot(X, aesthetics) + geom_point(size=POINT_SIZE) + x_lab + y_lab

unsure = rep('No', N)
unsure[(prev_views > 5) | ((prev_trans < 2) & (prev_views > 2))] = "Yes"
X = data.frame(prev_views=prev_views, prev_trans=prev_trans, unsure=unsure)
ggplot(X, aesthetics) + geom_point(size=POINT_SIZE) + x_lab + y_lab
