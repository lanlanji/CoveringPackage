
#' @export
FindIndicesList = function(Y, ctnames)
{
  nt = length(ctnames)
  ctIndiceslist = list()
  for (i in 1:nt)
  {
    ctIndiceslist[[i]] = which(Y == ctnames[i])
  }
  return(ctIndiceslist)
}


#' @export
FindIndicesList2 = function(Y, ctnames)
{
  nt = length(ctnames)
  ctIndiceslist = list()
  for (i in 1:nt)
  {
    ctIndiceslist[[i]] = which(Y == ctnames[i])
  }
  return(ctIndiceslist)
}

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

