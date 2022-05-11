#' @export

Find_CTGroups = function(labelseq,ctnames)
{
  nct = length(ctnames)

  ctgrouplist = list()
  for (i in 1:nct)
  {
    ctgrouplist[[i]] = which(labelseq == ctnames[i])
  }
  return(ctgrouplist)
}



CompPropMatrix=function(ctgrouplist,mat,paral=TRUE)
{
  ng=nrow(mat)
  nct=length(ctgrouplist)

  if (paral==FALSE)
  {
    freqct=matrix(NA,ng,nct)
    for (i in 1:nct)
    {
      group=ctgrouplist[[i]]
      l=length(group)
      temp1=mat[,group]
      for (j in 1:ng)
      {
        freqct[j,i]=sum(temp1[j,]!=0)/l
      }
    }
    return(freqct)
  }

  if (paral==TRUE)
  {

    library(parallel)
    tempfunction=function(currentct)
    {
      group=ctgrouplist[[currentct]]
      l=length(group)
      temp1=mat[,group]
      count=0
      for (j in 1:ng)
      {
        count[j]=sum(temp1[j,]!=0)/l
      }
      return(count)
    }
    tempresult=mclapply(seq(1,nct),tempfunction)
    freqct=matrix(NA,ng,nct)
    for (i in 1:nct)
    {
      freqct[,i]=tempresult[[i]]
    }
    return(freqct)
  }
}
