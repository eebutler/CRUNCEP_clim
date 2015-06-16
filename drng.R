# this should be parallelizable to speed it up

library(ncdf)

# moving range function to get daily min/max 
mov_rng <- function(x,n=4){
  x_rng <- matrix(nrow=length(x)/n,ncol=2)
  for(i in seq(0,length(x)/n-1)){
    x_rng[i+1,]<-range(x[(1+i*n):(n+i*n)]) }
  return(x_rng)
}

#file_dir <- "/home/reichpb/shared/cesm_inputdata/atm/datm7/atm_forcing.datm7.cruncep_qianFill.0.5d.V4.c130305/TPHWL6Hrly/"

file_dir <- "/home/reichpb/shared/cesm_inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/TmpPrsHumWnd3Hrly/"

# set-up the storage arrays: [month, year,] tmax/min, lat, lon
temp_arr <- array(dim=c(12,20,2,720,360))

# two digit numeric values 
mons <- c("01","02","03","04","05","06",
	  "07","08","09","10","11","12")

# loop through months [i] and years [j]   
for (i in seq(1,1)) {
  for (j in seq(1,2)) {

    # update the netCDF each month
    #ncname <- paste("clmforc.cruncep.V4.c2011.0.5d.TPQWL.",1969+j,"-",
    #    	     mons[i],".nc",sep="")
    ncname <- paste("clmforc.Qian.c2006.T62.TPQW.",1969+j,"-",
        	     mons[i],".nc",sep="")

    ncin <- open.ncdf(paste(file_dir,ncname,sep=""))

    # variable of interest, T at lowest atmospheric level (in K)
    temp <- get.var.ncdf(ncin,"TBOT")
    
    # convert from K to C
    temp <- temp - 273.16

    # get the daily diel temperature range of each cell
    drng <- apply(temp,1:2,mov_rng)
   
    d <- dim(drng)
     
    # change the shape to get the average of min/max across days
    drng <- array(drng,dim=c(d[1]/2,2,720,360))

    # get a mean value of min and max for the month across days
    mrng <- apply(drng,2:4,mean)

    temp_arr[i,j,,,] <- mrng

    print(paste(i,j+1969))
  }
}
