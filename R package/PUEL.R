

ensemblePrediction <- function(substrates, phospho.feature.data, ensemble.size, size.negative, kernelType) {

   # building the positive traning set 
   positive.train <- phospho.feature.data[substrates, ]
   negative.pool <- phospho.feature.data[!(rownames(phospho.feature.data) %in% substrates), ]

   # sampling from the negative pool
   svm_models <- list();
   svm_estimated_c <- c();
   tot.acc <- c();

   for (r in 1:ensemble.size){
      #set.seed(r)
      idx <- sample(1:nrow(negative.pool), size = size.negative, replace = F)
      negative.samples <- rownames(negative.pool)[idx]
      negative.train <- phospho.feature.data[negative.samples, ]

      # SVM classification
      train.mat <- rbind(positive.train, negative.train)
      rownames(train.mat) <- NULL;

	  # estimating c
	  cls <- as.factor(rep(c(1, 2), times=c(nrow(positive.train), size.negative)))
	  library(caret);
	  library(e1071);
	  k <- 3
	  fold <- createFolds(cls, k);
	  svm_model <- svm(train.mat[-fold$Fold1,], cls[-fold$Fold1], kernel=kernelType, probability=TRUE, scale = TRUE)
	  # label 1 correspond to positive labelled examples
      p <- which(cls[fold$Fold1] == 1)
	  pred <- predict(svm_model, train.mat[fold$Fold1,][p,], decision.values=F, probability=T);
	  estimated.c <- sum(attr(pred, "probabilities")[,1]) / nrow(attr(pred, "probabilities"))
	  svm_estimated_c <- c(svm_estimated_c, estimated.c)
	  
      # training base classifiers
      svm_models[[r]] <- svm(train.mat, cls, kernel=kernelType, probability=TRUE, scale = TRUE)
   }

   # an ensemble approach for prediction
   predict.mat <- phospho.feature.data

   #ensemble.pred <- 0
   #for(i in 1:length(svm_models)) {
   #   svm.pred <- predict(svm_models[[i]], predict.mat, decision.values=TRUE, probability=TRUE);
   #   ensemble.pred <- ensemble.pred + attr(svm.pred,"probabilities")[,1]
   #}

   # correcting base classifiers with estimated c values
   ensemble.pred.corrected <- 0
   for(i in 1:length(svm_models)) {
      svm.pred <- predict(svm_models[[i]], predict.mat, decision.values=TRUE, probability=TRUE);
      ensemble.pred.corrected <- ensemble.pred.corrected + attr(svm.pred,"probabilities")[,1] / svm_estimated_c[i]
   }
   
   # return prediction results and base classifiers
   results <- list()
   predicts <- (ensemble.pred.corrected / ensemble.size)
   results$prediction <- predicts / max(predicts)
   results$svm_models <- svm_models;
   return(results);
}
