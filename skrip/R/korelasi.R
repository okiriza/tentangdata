# Skrip untuk membuat plot korelasi
# pada tulisan "Korelasi"
# oleh Okiriza, Desember 2014


library(ggplot2)
library(xkcd)

set.seed(122014)
x <- rnorm(100)
y0.5 <- x + rnorm(100, sd=0.5)
y1   <- x + rnorm(100, sd=1)
y2   <- x + rnorm(100, sd=2)

z0.5 <- data.frame(x=x, y=y0.5)
z1   <- data.frame(x=x, y=y1)
z2   <- data.frame(x=x, y=y2)

yrange <- c(min(min(y0.5), min(y1), min(y2)), max(max(y0.5), max(y1), max(y2)))

plot.corr <- function(z, yrange, ycolour, what.sd) {
    xrange <- range(z$x)
    
    ggplot(z, aes(x=x, y=y)) +
        geom_point(size=4, colour=ycolour) +
        xlab('x') + ylab('y') +
        theme(axis.text=element_text(size=20), axis.title=element_text(size=25)) +
        annotate('text', x=min(x) + 0.5, y=c(yrange[2], yrange[2] - 1), label=c(paste('Corr = ', sprintf('%.3f', cor(z$x, z$y))), paste('sd = ', what.sd)), family='xkcd', size=8) +
        xkcdaxis(xrange, yrange)
}

plot.corr(z0.5, yrange, 'blue', 0.5)
plot.corr(z1, yrange, 'green3', 1)
plot.corr(z2, yrange, 'red', 2)
