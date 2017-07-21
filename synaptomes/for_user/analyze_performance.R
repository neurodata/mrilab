# a function to rIun performance analysis in the background
analyze_performance <- function(func, args, path='/tmp', tres=1) {
    system(paste('pkill -f memlog'))
    memtxt <- paste(path, '/mem.txt', sep="")

    cmd <- paste('./memlog.sh', memtxt, tres)  # run memory logging sh utility

    jid <- system(cmd, intern=TRUE)  # run memory logging in background and save job id

    ptm <- proc.time()[2]  # previous time
    out <- do.call(func, args)
    time <- proc.time()[2] - ptm  # time after function is run

    system(paste('kill', jid))  # kill old job
    memdat <- scan(memtxt, what=double(), sep="\n")  # read memory per tres line by line
    
    return(list(out=out, time=time, mem=((max(memdat) - min(memdat)))/1000))
}
