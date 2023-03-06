#' @export

CoveringMarkers = function(J = 3, alpha = 0.05, genes_per_class = 6000, te=0.1,
mat, CellTypeNames, CellTypeLabels,prev = NULL)
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
    td = sort(marginmatrix[,currenttype], decreasing = TRUE)[genes_per_class]
    if (td < 1){
      td = 1
    }
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

    if (is.null(prev) == FALSE)
    { 
      z0 = prev[[currenttype]] #only the index
      holder1 = rep(0,ng)
      for (i in 1:length(z0))
      {
        holder1[z0[i]] = 1
      }
      holder2 = rep(0,G)
      for (i in 1:G)
      {
        holder2[i] = holder1[keepgeneindex[i]]
      }
      AA = matrix(0, N+1+G,G+N)
      AA[1:N,1:G]=matrix(t(A),N,G)
      AA[1:N,(G+1):(G+N)]=diag(J,N,N)
      AA[N+1,]=c(rep(0,G),rep(1,N))
      AA[(N+2):(N+1+G),1:G] = diag(1,G,G)
      rhs=c(rep(J,N),alpha*N,holder2)
      sense= c(rep('>=',N),'<=',rep('>=',G))
    }
    
    else{
      AA=matrix(NA,N+1,G+N)
      AA[1:N,1:G]=matrix(t(A),N,G)
      AA[1:N,(G+1):(G+N)]=diag(J,N,N)
      AA[N+1,]=c(rep(0,G),rep(1,N))
      rhs = c(rep(J,N),alpha*N)
      sense = c(rep('>=',N),'<=')
    }
    
    model = list()
    model$A = AA
    model$obj = c(1/(marginmatrix[keepgeneindex,currenttype]-td+0.00001),rep(0,N))
    model$modelsense = 'min'
    model$modelname = 'poolserch'
    model$rhs = rhs
    model$sense = sense
    model$vtype = 'B'
    params = list()
    
    params$MIPFocus = 0
    
    params$PoolSearchMode = 0
    #params$PoolSolutions = 2
    solutions = gurobi(model, params = params)
    markerlist=keepgeneindex[which(solutions$x[1:G]>0.9)]
    
    currentmarker[[currenttype]]=markerlist
  }
  return(currentmarker)}
