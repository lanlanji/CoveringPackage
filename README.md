# CoveringPackage

## Gurobi

Before the installation of CellCover, the user need to install the Gurobi optimizer using the following steps.

### Step 1: Installing the Gurobi Optimizer

Sign up for a Gurobi account using the academic email, log into your account, and download the Gurobi optimizer from [Gurobi Software - Gurobi Optimization](https://www.gurobi.com/downloads/gurobi-software/)

### Step 2: Accessing the (Academy) license

For the Gurobi optimizer to run properly, users need to request a free academic liscence from [Academic Program and Licenses - Gurobi Optimization](https://www.gurobi.com/academia/academic-program-and-licenses/) . A license key will be given once the request is processed. An example license key will look like the following. (This example key is not real, please do not use it to activate the license)

```
grbgetkey 54f2ff08-fade-11ab-8a77-0367ac980104
```

### Step 3: Activate the license

Open the command line and paste the license key. If the license is installed successfully, we are good to proceed to the last step!

### Step 4: Install the Gurobi in R

Follow the instruction in [Installing the R package - Gurobi Optimization](https://www.gurobi.com/documentation/9.5/refman/ins_the_r_package.html) and install the Gurobi R package.

### More Information:

A great guidance writtened by Richard Schuster on installing Gurobi in R can be found in [Gurobi installation guide (r-project.org)](https://cran.r-project.org/web/packages/prioritizr/vignettes/gurobi_installation_guide.html)

## CellCover

### Installation:

```r
library(devtools)
install_github("lanlanji/CoveringPackage")
```

### Covering Marker:

To get the Covering marker, we can call the following function

```r
library(CoveringPackage)
Covering = CellCover(J = ,
                     alpha = ,
                     mat= ,
                     CellTypeLabels= ,
                     CellTypeNames= , 
                     te =,
                     genes_per_class = ,
                     prev =)
```

Here is a summary of the main parameters in the *CoveringMarkers* function

- *J*: the depth of the covering. The default is 3
  
- *alpha*: 1 - covering rate. The default is 0.05
  
- *mat*: This is the input single-cell gene expression data frame. The rows of *mat* should correspond to the genes, and the columns of *mat* correspond to the cells. Note *mat* can be the raw count data. The function will do the binarization under the hood.
  
- *CellTypeLabels*: a vector of cell type labels. (It can be a vector of strings.) The length of *CellTypeLabels* should equal number of columns of *mat*.
  
- *CellTypeNames*: The target cell class to get the covering markers from. For example, if we want the covering markers for all the cell classes, *CellTypeNames* should be a vector of all the unique names of *CellTypeLabels*.
  
- *te*: This is a parameter for pruning the data. For each class, the gene expressing more than *te* * 100 percent of time are selected for finding the covering markers. The default is $0.1$.
  
- *genes_per_class*: This is another pruning parameter. In each class, *genes_per_class* number of genes with the highest margin score will be selected for marker selection. The default is 6000.
  
- *prev*: The output from previous covering run that user can use as base for the nested expansion. All of the genes in prev will be selected as marker for the current covering nested expansion. The default is NULL. An example of how to get nested expansion markers are illustrated in the following.
  

```r
#This is an example of getting nested-expanded covering marker

CellCover.r5 = CellCover(J = 5, 
                         mat=mat,
                         CellTypeLabels=CellTypeLabels,
                         CellTypeLabels=CellTypeLabels)
CellCover.r10.nested.from.r5 = CellCover(J = 10, 
                                         mat=mat,
                                         CellTypeLabels=CellTypeLabels,
                                         CellTypeLabels=CellTypeLabels,
                                         prev = CellCover.r5)
#CellCover.r10.nested.from.r5 will be a covering set of depth 10 
#including all the genes in CellCover.r5
```

Remark: The parameters *J* and *alpha* jointly define the covering. A covering of depth *J* with rate 1-*alpha* in class $k$ returns a set of genes $M_k$ such that the probability that at least *J* markers in $M_k$ being expressed in class $k$ exceeds 1-*alpha*.
