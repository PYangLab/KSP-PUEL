# set to directory that contains the data
load("Ins_Phosphoproteome.RData")

#### secondary feature 1
# magnitude calculation (mathematical mean)
average.score <- rowSums(Ins_Phosphoproteome[, 2:9]) / ncol(Ins_Phosphoproteome[, 2:9])
names(average.score) <- rownames(Ins_Phosphoproteome)

#### secondary feature 2
# temporal profile fitting to check if the profile follows are good trend
fitting.score <- c()
for (i in 1:nrow(Ins_Phosphoproteome)) {
   y <- as.numeric(Ins_Phosphoproteome[i, 1:9]);
   x <- 1:9
   x2 = x^2
   lmfit <- lm(formula = y ~ x + x2 - 1)
   f.stat <- summary(lmfit)$fstatistic
   fitting.score <- c(fitting.score, f.stat[1])
}
fitted.score <- log2(fitting.score)
names(fitted.score) <- rownames(Ins_Phosphoproteome)

#### secondary feature 3
# area under the temporal curve
area <- function(y1, y2, x1, x2) {
   m <- (y2 + y1) * (x2 - x1) / 2
   return(m)
}

tp <- 0:8
subustrate.areas <- list()
for (j in 1:nrow(Ins_Phosphoproteome)) {
   y <- as.numeric(Ins_Phosphoproteome[j, 1:9]);
   y.scaled <- (y - min(y)) / (max(y) - min(y))
   areas <- c();
   for (i in 1:(length(y.scaled) - 1)) {
      areas <- c(areas, area(y.scaled[i], y.scaled[i+1], tp[i], tp[i+1]));
   }
   subustrate.areas[[j]] <- areas
}
substrates.area.sum <- 1 - sapply(subustrate.areas, sum) / 8
names(substrates.area.sum) <- rownames(Ins_Phosphoproteome)

# combine extracted secondary features with primary features
Ins_Phosphoproteome_features.dat <- cbind(average.score, fitted.score, substrates.area.sum, Ins_Phosphoproteome)


