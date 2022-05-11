CoveringMarkers = function(J = 3, alpha = 0.02, td=1, te=0.1,
                           mat, CellTypeNames, CellTypeLabels)
{
  selectedtrain = Find_CTGroups(CellTypeLabels, CellTypeNames)
  trainfreq = CompPropMatrix(selectedtrain, mat, paral = FALSE)

  nct = length(selectedtrain)
  ng = nrow(mat)

  library(slam)
  library(gurobi)

  marginmatrix=matrix(NA,ng,nct)
  for (currenttype in 1:nct)
  {
    for (i in 1:ng)
    {
      temp=mean(trainfreq[i,-currenttype])
      marginmatrix[i,currenttype]=trainfreq[i,currenttype]/temp
    }
  }

  currentmarker=list()
  for (currenttype in 1:nct)
  {
    keepgeneindex=intersect(which(marginmatrix[,currenttype]>td),which(trainfreq[,currenttype]>=te))
    G=length(keepgeneindex)

    group=selectedtrain[[currenttype]]
    tempA=mat[keepgeneindex,group]
    N=ncol(tempA)

    A=matrix(0,G,N)
    for (i in 1:G)
    {
      A[i,which(tempA[i,]>0)]=1
    }

    AA=matrix(NA,N+1,G+N)
    AA[1:N,1:G]=matrix(t(A),N,G)
    AA[1:N,(G+1):(G+N)]=diag(J,N,N)
    AA[N+1,]=c(rep(0,G),rep(1,N))

    model = list()
    model$A = AA
    model$obj = c(1/(marginmatrix[keepgeneindex,currenttype]-1),rep(0,N))
    model$modelsense = 'min'
    model$modelname = 'poolserch'
    model$rhs = c(rep(J,N),alpha*N)
    model$sense = c(rep('>=',N),'<=')
    model$vtype = 'B'
    params = list()

    params$PoolSearchMode = 0

    solutions = gurobi(model, params = params)
    markerlist=keepgeneindex[which(solutions$x[1:G]>0.9)]

    currentmarker[[currenttype]]=markerlist
  }
  return(currentmarker)
}


