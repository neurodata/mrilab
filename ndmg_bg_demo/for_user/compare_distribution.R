# a function to compute two density distributions for theoretically equivalent data on the same x axis,
# and produce a hellinger distance indicating the similarity of the two resulting distributions
compare_distrs <- function(x1, x2) {
    kde_x1_tmp <- density(as.numeric(x1)) # temporary computation so that we can see what range is optimal
    kde_x2_tmp <- density(as.numeric(x2))
    bw_selection <- mean(c(kde_x1_tmp$bw, kde_x2_tmp$bw)) # take mean of both bandwidths
    
    minx <- min(c(kde_x1_tmp$x, kde_x2_tmp$x)) #compute min
    maxx <- max(c(kde_x1_tmp$x, kde_x2_tmp$x)) #and max vals
    
    kde_x1 <- density(x1, from=minx, to=maxx, bw = bw_selection) # compute the density for the predetermined
    kde_x2 <- density(x2, from=minx, to=maxx, bw = bw_selection) # range(from, to)

    hd <- hell_dist(kde_x1$y, kde_x2$y)  # hellinger distance of the density estimates
    
    return(list(hd=hd, kde_x1=kde_x1, kde_x2=kde_x2))
}
