
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




