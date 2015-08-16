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

mod = glm(unsure ~ prev_views + prev_trans, data=X, family=binomial(logit))
u = predict(mod, X)
unsure_pred = rep('No', N)
unsure_pred[u > 0] = 'Yes'
X_pred = X
X_pred$unsure = unsure_pred

ggplot(X, aesthetics) + geom_point(size=POINT_SIZE) + x_lab + y_lab
ggplot(X_pred, aesthetics) + geom_point(size=POINT_SIZE) + x_lab + y_lab
