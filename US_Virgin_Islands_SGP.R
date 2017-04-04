#####################################################
###
### SCRIPT FOR CREATING SGPs FOR US VIRGIN ISLANDS
###
#####################################################

### LOAD SGP PACKAGE

require(SGP)


### Load LONG Data

load("Data/US_Virgin_Islands_Data_LONG.Rdata")


### prepareSGP

US_Virgin_Islands_SGP <- prepareSGP(US_Virgin_Islands_Data_LONG, create.additional.variables=FALSE)


### analyzeSGP

US_Virgin_Islands_SGP <- analyzeSGP(US_Virgin_Islands_SGP,
			sgp.percentiles=TRUE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE)


### combineSGP

US_Virgin_Islands_SGP<-combineSGP(US_Virgin_Islands_SGP)


### summarizeSGP

#US_Virgin_Islands_SGP <- summarizeSGP(US_Virgin_Islands_SGP)


### outputSGP

outputSGP(US_Virgin_Islands_SGP)


### save results

save(US_Virgin_Islands_SGP, file="Data/US_Virgin_Islands_SGP.Rdata")


### visualizeSGP (Occurs last due to subsetting of data)

US_Virgin_Islands_SGP@Data <- US_Virgin_Islands_SGP@Data[ORIGIN=="VI"]
visualizeSGP(US_Virgin_Islands_SGP, plot.types=c("growthAchievementPlot", "studentGrowthPlot"), sgPlot.demo.report=TRUE)
