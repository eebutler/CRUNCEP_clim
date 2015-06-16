library(fields)
library(ggplot2)

setwd('~/Desktop/Projects/Plants/TRY/')

# load the databases
load('clean_try.Rdata')
load('PFT_temp.RData')
load('ncep_lon_lat.RData')

locs <- matrix(nrow=720*360,ncol=2)
# convert lon to -180 to 180
lon <- ((lon+180) %% 360) - 180
locs[,1] <- as.vector(lon)
locs[,2] <- as.vector(lat)

sites <- cbind(clean_try$Lon,clean_try$Lat)

dists <- vector(length=length(sites))

d <- dim(sites)

for (i in seq(1,dim(1))) {
  # rdist.earth is finicky about input structure
  site <- t(as.matrix(sites[i,]))
  dists[i] <- which.min(rdist.earth(locs,site))
  print(i)
}

Tcmin <- mean_minT[dists]
Tcmax <- mean_maxT[dists]
GDD_5C <- mean_GDD[dists]

try_clim <- cbind(clean_try,Tcmin,Tcmax,GDD_5C)

mp <- ggplot() + borders() + 
      geom_point(data=clean_try,aes(x=Lon,y=Lat,color=Tcmin)) + 
      scale_colour_gradient2("Tmin [C]",low="blue",mid="white",high="red") +
      ylim(-60,85)
pdf(file="Tmin.pdf",width=8,height=5)
mp
dev.off()

mp <- ggplot() + borders() + 
      geom_point(data=clean_try,aes(x=Lon,y=Lat,color=Tcmax)) + 
      scale_colour_gradient2("Tmax [C]",low="blue",mid="white",high="red") +
      ylim(-60,85)
pdf(file="Tmax.pdf",width=8,height=5)
mp
dev.off()

mp <- ggplot() + borders() + 
      geom_point(data=clean_try,aes(x=Lon,y=Lat,color=GDD_5C)) + 
      scale_color_continuous("GDD [C day]",low="blue",high="red") +
      ylim(-60,85)
pdf(file="GDD_5C.pdf",width=8,height=5)
mp
dev.off()

# now with monthly averages of min and max T
load("drng.RData")
# get the hottest and coolest month
minT <- apply(temp_arr[,,1,,],2:4,min)
maxT <- apply(temp_arr[,,2,,],2:4,max)
# make the climatology
mean_mon_maxT <- colMeans(maxT,dims=1)
mean_mon_minT <- colMeans(minT,dims=1)

# assign locations
Tcmin_mon <- mean_mon_minT[dists]
Tcmax_mon <- mean_mon_maxT[dists]

try_clim <- cbind(clean_try,Tcmin_mon,Tcmax_mon,Tcmin,Tcmax)

mp <- ggplot() + borders() + 
      geom_point(data=clean_try,aes(x=Lon,y=Lat,color=Tcmin-Tcmin_mon)) + 
      scale_colour_gradient2("Tmin diff[C]",
			     low="blue",mid="white",high="red") +
      ylim(-60,85)
pdf(file="Tmin_diff.pdf",width=8,height=5)
mp
dev.off()

mp <- ggplot() + borders() + 
      geom_point(data=clean_try,aes(x=Lon,y=Lat,color=Tcmax-Tcmax_mon)) + 
      scale_colour_gradient2("Tmax diff[C]",
			     low="blue",mid="white",high="red") +
      ylim(-60,85)
pdf(file="Tmax_diff.pdf",width=8,height=5)
mp
dev.off()

mp <- ggplot() + borders() + 
      geom_point(data=clean_try,aes(x=Lon,y=Lat,color=Tcmin_mon)) + 
      scale_colour_gradient2("Tmin(mon) [C]",
			     low="blue",mid="white",high="red") +
      ylim(-60,85)
pdf(file="Tmin_mon.pdf",width=8,height=5)
mp
dev.off()

mp <- ggplot() + borders() + 
      geom_point(data=clean_try,aes(x=Lon,y=Lat,color=Tcmax_mon)) + 
      scale_colour_gradient2("Tmax(mon) [C]",
			     low="blue",mid="white",high="red") +
      ylim(-60,85)
pdf(file="Tmax_mon.pdf",width=8,height=5)
mp
dev.off()

tmp <- cbind(clean_try$Observation,clean_try$Lat,clean_try$Lon,
	    Tcmin_mon,Tcmax_mon)

colnames(tmp) <- c("Observation","Lat","Lon","Tcmin_mon","Tcmax_mon")

mon_temps <- tmp

save(mon_temps,file="mon_temps.RData")
