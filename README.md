# KSP-PUEL
## Positive-unlabeled ensemble learning for kinase substrate prediction from dynamic phosphoproteomics data

### Description
Positive-unlabeled ensemble learning (PUEL) for kinase substrate prediction (KSP-PUEL) is an application developed for predicting novel substrates of kinases of interest.

Current version includes:

- GUI version 
- R function version. 

**To use the GUI verion, please download `KspPuel.jar` and double click on this executable.** For details on how to use the GUI verion, please refer to the document "KSP-PUEL GUI documentation.docx". 

### References

Yang, P.#, Humphrey, S., James, D., Yang, J. & Jothi, R.# (2016). Positive-unlabeled ensemble learning for kinase substrate prediction from dynamic phosphoproteomics data. Bioinformatics, 32(2), 252-259. [[fulltext](http://bioinformatics.oxfordjournals.org/content/32/2/252.abstract)]

### Examples

The following two examples show how the R function can be used for predicting Akt and mTOR substrates. Download "PUEL.R" and "InsulinPhospho.RData" files from the folder "R package". Suppose "PUEL.R" and "InsulinPhospho.RData" files are in the current directory, type the following in R to load the data and the prediction function:

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

