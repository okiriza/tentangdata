# Skrip untuk simulasi selisih kemunculan sisi muka dan belakang dalam lemparan koin
# pada tulisan "100 Lemparan Koin: Simulasi"
# oleh Okiriza, November 2014


library(ggplot2)
library(xkcd)

n.trial <- 10000
n.tosses <- 10^(1:9)
means <- sapply(n.tosses, function(n) {
    h <- rbinom(n.trial, n, 0.5)
    mean(abs(2*h - n))
})

plot.means <- function(n.tosses, means, is.log=FALSE) {
    set.seed(1)
    
    if (is.log) {
        mapping <- aes(log(n.tosses), log(means))
        x.label <- 'log jumlah lemparan'
        y.label <- 'log rata-rata selisih'
        xrange <- range(log(n.tosses))
        yrange <- range(log(means))
    } else {
        mapping <- aes(n.tosses, means)
        x.label <- 'Jumlah lemparan'
        y.label <- 'Rata-rata selisih'
        xrange <- range(n.tosses)
        yrange <- range(means)
    }
    
    ggplot(mapping=mapping) + geom_point(shape=1, size=10, colour='blue') + geom_line(size=2) + xlab(x.label) + ylab(y.label) + theme(axis.text=element_text(size=30), axis.title=element_text(size=30)) + xkcdaxis(xrange, yrange)
}

plot.means(n.tosses, means)
grid.edit("geom_point.points", grep = TRUE, gp = gpar(lwd=5))
plot.means(n.tosses, means, TRUE)
grid.edit("geom_point.points", grep = TRUE, gp = gpar(lwd=5))
