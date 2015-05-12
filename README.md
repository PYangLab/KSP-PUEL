# KSP-PUEL
Positive-unlabeled ensemble learning for kinase substrate prediction from phosphoproteomics data

#### Description
Positive-unlabeled ensemble learning (PUEL) for kinase substrate prediction (KSP-PUEL) is a set of R codes and phosphoproteomics data used for predicting novel substrates of kinases of interest.

Current version includes the prediction R function and a phosphoproteomics data generated from insulin pathway profiling study. The following two examples show how the prediction code can be used for predicting Akt and mTOR substrates.

Suppose "PUEL.R" and "InsulinPhospho.RData" files are in the current directory, type the following in R to load the data and the prediction function:

```r
source("PUEL.R")
load("InsulinPhospho.RData")
```

The "InsulinPhospho.RData" contains the learning features extracted from dynamic phosphoproteomics data and the motif score calculated using known Akt substrates and mTOR substrates, respectively. To perform the prediction for Akt substrates using the positive-unlabeled ensemble learning, after loading the phosphoproteomics data and the prediction function as mentioned above and type the following in R:

```r
Akt.model <- ensemblePrediction(Akt.substrates, Akt.dat, ensemble.size=50, size.negative=length(Akt.substrates), kernelType="radial")
sort(Akt.model$prediction, decreasing=TRUE)[1:50]
```

and also for mTOR substrates prediction:

```r
mTOR.model <- ensemblePrediction(mTOR.substrates, mTOR.dat, ensemble.size=50, size.negative=length(mTOR.substrates), kernelType="radial")
sort(mTOR.model$prediction, decreasing=TRUE)[1:50]
```

The outputs from the prediction models are the top-50 high confident Akt and mTOR substrate predictions.

