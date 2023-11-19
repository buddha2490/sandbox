library(microbenchmark)
library(dplyr)

merging <- function(n) {

     df1 <- data.frame(
          id = as.character(1:n),
          a = runif(n, 0, 10),
          b = sample(letters, n, replace = TRUE),
          c = sample(c(1,2,3,4,5), n, replace = TRUE) %>% factor()
     )

     df2 <- data.frame(
          id = as.character(1:n),
          d = runif(n, 0, 10),
          e = sample(letters, n, replace = TRUE),
          f = sample(c(1,2,3,4,5), n, replace = TRUE) %>% factor()
     )

     df3 <- full_join(df1, df2, by = "id")

}

write <- function(n) {

     df1 <- data.frame(
          id = as.character(1:n),
          a = runif(n, 0, 10),
          b = sample(letters, n, replace = TRUE),
          c = sample(c(1,2,3,4,5), n, replace = TRUE) %>% factor()
     )

     saveRDS(df1, file = file.path(tempdir,  "writefile.rds"))

}


read <- function() {

     readRDS(file = file.path(tempdir,  "writefile.rds"))

}


# merging
microbenchmark(
     merging(n = 100000),
     times = 100)

# writing
microbenchmark(
     write(n = 100000),
     times = 100
)

# reading
microbenchmark(
     read(),
     times = 100
)

