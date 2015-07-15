### Copyright Okiriza Wibisono & Ali Akbar S.
### July 2015


generate = function(n, m = 0, s = 1, randomness = 50) {
    x = rnorm(n, m, s)
    a = runif(1, -2*s, 2*s)
    b = runif(1, -s, s)

    if (randomness == 100) {
        y = a + b*rnorm(n, m, s)
    } else if (randomness < 100) {
        y = a + b*x
        y = y + rnorm(n, sd = randomness/100 * 2*sd(y))
    }

    list(x = x, y = y, a = a, b = b)
}

compute_a = function(x, y) {
    b = compute_b(x, y)
    mean(y) - b*mean(x)
}

compute_b = function(x, y) {
    cor(x, y) * sd(y)/sd(x)
}

RMSE = function(y, pred) {
    sqrt(mean((y - pred)^2))
}

RSE = function(y, pred) {
    sqrt(sum((y - pred)^2)/(length(y) - 2))
}

MAE = function(y, pred) {
    mean(abs(y - pred))
}

R2 = function(y, pred) {
    mean_y = mean(y)
    RSS = sum((y - pred)^2)
    TSS = sum((y - mean_y)^2)

    1 - (RSS/TSS)
}

decimal = function(x, k) format(round(x, k), nsmall=k)

