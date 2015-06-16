# setwd('~/Desktop/Projects/Plants/TRY/')

# library(gdata)
# clean_try <- read.xls('TRY_environmental_trait-1_cleaned_2012_08_24.xlsx',
#			 na.strings = "")
# save(clean_try,file='clean_try.Rdata')

# good geographic spread, 78,604 total entries with 132 values
# (how many are "traits") only 60 > 70K and 88 > 50K

# length(unique(clean_try$AccSpecies))
14,338 species
3,793 genuses
358 Families

# summary(as.factor((clean_try$PhylogeneticGroup)))
six Phylogenetic groups:
1. Angiosperm, Eudicotyl - 55461
2. Angiosperm, Monocotyl - 10264
3. Angiosperm, Magnoliid - 3904
4. Gymnosperm - 7605
5. Bryophytes - 9
6. Pteridophytes - 1361

Angiosperms - flowering plants with enclosed seeds, 'more advanced'
than gymnosperms
Gymnosperms - flowering plants, think conifers
bryophytes - non-vascular plants, mosses, etc.
pteridophytes - spore plants, think ferns

# summary(as.factor((clean_try$PlantGrowthForm)))
six growth forms 
1. tree - 34005
2. shrub - 14604
3. herb - 16905
4. graminoid, monocots, grasses - 7035
5. fern - 1361
6. moss - 9
7. NA - 4685

five leaf types
1. broadleaved - 69809 
2. needleleaved - 7461
3. pinnate, feathering from common axis - 14
4. scale-shaped, flat - cedar or juniper - 28
5. w/o leaves - 7
6. NA - 1285

with three phenologies
1. deciduous - 11619
2. deciduous/evergreen - 39875
3. evergreen - 4263
4. NA - 22847

photosynthesis pathways
1. C3 - 56486
2. C3/C4 - 105
3. C3/C4/CAM - 24
4. C3/CAM - 3246
5. C4 - 1943
6. C4/CAM - 4
7. CAM - 81
8. NA - 16715

Woodiness (carbon turnover times)
1. non-woody - 23696
2. non-woody/woody - 1109
3. non-woody/woody at base - 379
4. non-woody/woody rootstock - 35
5. woody - 51019
6. NA - 2366

Leaves
1. compound - 9615
2. simple - 66651
3. NA - 2338

# some more clean-up
# cols <- which(colSums(is.na(clean_try))!=78604)
# eliminates 22 columns
# Trait Numbers
Specific Leaf Area (SLA) - 33053
Plant Height - 16456
Seed Mass - 7311
Leaf Dry Matter Content (LDMC) - 17343
Stem Specific Density - 9191
Leaf Area - 39438
Leaf N - 26892
Leaf P - 11977
Stem conduit density (vessels and traches) - 62
Leaf N content per area - 8180
Leaf fresh mass - 11484
Leaf N/P ratio - 5999
Leaf C content per dry mass - 8125
Leaf delta 15N - 9022
# all of these also have dataID, ErrorRisk, Duplicate, and ValueKind associated

# Environment Information
# Climate
Temp. Ann. Mean
Precip. Ann. Mean
Isothermality (from weekly: Mean Diurnal Range / Mean Annual Range?)
Temperature Seasonality (SD of weekly Mean T or SD(MeanT) / Annual Mean?)
Koeppen Geiger Code
Available Water Capacity (AWC)

# Soil, what's the difference between S and T (sub and top?)
S_Clay, S_Gravel, S_Sand, S_Silt, S_OC (organic carbon)
T_Clay, T_Gravel, T_Sand, T_Silt, T_OC, T_SUM
texture class
T_Sand/T_Clay

# some more serious plotting
library(ggplot2)

# Temp
mp <- ggplot() + borders() + 
      geom_point(data=clean_try,aes(x=Lon,y=Lat,color=TempAnnMean_DegC)) + 
      scale_color_continuous("Tavg [C]", low="blue",high="red") +
      ylim(-60,85)
mp

#Precip
mp <- ggplot() + borders() + 
      geom_point(data=clean_try,aes(x=Lon,y=Lat,color=PrecipAnnMean_mm)) + 
      scale_color_continuous("Precip [mm]", low="light blue",high="dark blue") +
      ylim(-60,85)
mp

# Phylogenetic Groups
# still playing with size...
Palette1 <- c("#E69F00", "#56B4E9", "#009E73","#000000", "#0072B2", "#D55E00", "#CC79A7")
mp <- ggplot() + borders() + 
  geom_point(data=clean_try,aes(x=Lon,y=Lat,color=PhylogeneticGroup),size=1.25) + 
      scale_colour_manual(values=Palette1) + ylim(-60,85)
mp

# Growth Form
Palette2 <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
mp <- ggplot() + borders() + 
  geom_point(data=clean_try,aes(x=Lon,y=Lat,color=PlantGrowthForm),size=1.25) + 
      scale_colour_manual(values=Palette2) + ylim(-60,85)
mp

# Woodiness
Palette2 <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
mp <- ggplot() + borders() + 
  geom_point(data=clean_try,aes(x=Lon,y=Lat,color=Woodiness),size=1.25) + 
      scale_colour_manual(values=Palette2) + ylim(-60,85)
mp

# Leaf Area
# What are these values? Too big to be LAI... 
mp <- ggplot() + borders() + 
      geom_point(data=clean_try[!is.na(clean_try$LeafArea),],
		 aes(x=Lon,y=Lat,color=LeafArea)) + 
      scale_color_continuous("Units?", low="light green",high="dark green",
			     limits=c(0,10000)) + ylim(-60,85)
mp
