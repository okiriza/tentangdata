# Skrip R untuk membuat plot tarif taksi vs jarak
# pada tulisan "Satu Lagi Tulisan Tentang Regresi"
# oleh Okiriza, Mei 2015


library(ggplot2)

set.seed(100)

x <- rnorm(100, 5, 1.8)
y <- 7.5 + x*15 + rnorm(100)*10
d <- data.frame(Jarak=x, Tarif=y)

ggplot(d, aes(Jarak, Tarif)) + 
    geom_point(col='blue', size=3) +
    geom_smooth(method='lm', size=1, col='red', se=F, fullrange=T) + 
    xlim(0, 10) + ylim(0, 150) + 
    xlab('Jarak (km)') + ylab('Tarif (ribu rupiah)') + 
    theme(axis.title=element_text(size=15), axis.text=element_text(size=12))
