fisher_test <- function(set, mod, all){
  
  totalshared <- length(intersect(all, set))
  modshared <- length(intersect(mod, set))
  nonmodshared <- totalshared-modshared
  modnonshared <- length(mod)-modshared
  nonmodnonshared <- length(all)-length(mod)-nonmodshared
  confmat <- matrix(c(modshared, modnonshared, nonmodshared, nonmodnonshared), ncol=2)
  fisher.test(confmat, alternative="greater")$p.val
  
}