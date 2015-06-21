# Skrip untuk perbandingan operasi (perkalian matriks) dengan dan tanpa vektorisasi
# oleh Okiriza, Juni 2015

set.seed(100)

nbaris <- 3
nkolom <- 4
mid_dim <- 2
n_elem <- nbaris*nkolom

M <- matrix(rnorm(nbaris*mid_dim), nrow=nbaris)
N <- matrix(rnorm(mid_dim*nkolom), ncol=nkolom)

# Versi 1: Dengan perulangan
MN <- matrix(nrow=nbaris, ncol=nkolom)

for (i in 1:nbaris) {
    for (j in 1:nkolom) {
        MN_ij <- 0

        for (k in 1:mid_dim) {
            MN_ij <- MN_ij + M[i, k]*N[k, j]
        }
        
        MN[i, j] <- MN_ij
    }
}

# Versi 2: Dengan operasi built-in
MN_vec <- M %*% N
