##############################################################################
###
### Long data preparation script for US Virgin Islands
###
##############################################################################

### Load packages

require(data.table)
require(SGP)


### Load Data

load("Data/Base_Files/Hawaii_Data_LONG_DeIdentified.Rdata")
US_VI_Data_LONG_TEMP <- fread("Data/Base_Files/SB_Data_No_PI_v2.csv")


### Tidy up US_VI Data

US_VI_Data_LONG_ELA <- data.table(
                VALID_CASE="VALID_CASE",
                YEAR=rep(c("2015", "2016"), each=nrow(US_VI_Data_LONG_TEMP)),
                CONTENT_AREA="ELA",
                GRADE=as.character(c(US_VI_Data_LONG_TEMP[['2014-15ELAGrade']], US_VI_Data_LONG_TEMP[['2015-16ELAGrade']])),
                ID=rep(US_VI_Data_LONG_TEMP[['ID']], 2),
                SCALE_SCORE=as.numeric(c(US_VI_Data_LONG_TEMP[['2014-15ELAScaleScore']], US_VI_Data_LONG_TEMP[['2015-16ELAScaleScore']])),
                ACHIEVEMENT_LEVEL=as.numeric(c(US_VI_Data_LONG_TEMP[['2014-15ELAPerformanceLevel']], US_VI_Data_LONG_TEMP[['2015-16ELAPerformanceLevel']])),
                SCHOOL_NUMBER=c(US_VI_Data_LONG_TEMP[['2014-15ELASchoolNum']], US_VI_Data_LONG_TEMP[['2015-16ELASchoolNum']]),
                DISTRICT_NUMBER=c(US_VI_Data_LONG_TEMP[['2014-15ELADistrictID']], US_VI_Data_LONG_TEMP[['2015-16ELADistrictID']]),
                ORIGIN="VI")

US_VI_Data_LONG_MATHEMATICS <- data.table(
                VALID_CASE="VALID_CASE",
                YEAR=rep(c("2015", "2016"), each=nrow(US_VI_Data_LONG_TEMP)),
                CONTENT_AREA="MATHEMATICS",
                GRADE=as.character(c(US_VI_Data_LONG_TEMP[['2014-15MATGrade']], US_VI_Data_LONG_TEMP[['2015-16MATGrade']])),
                ID=rep(US_VI_Data_LONG_TEMP[['ID']], 2),
                SCALE_SCORE=as.numeric(c(US_VI_Data_LONG_TEMP[['2014-15MATScaleScore']], US_VI_Data_LONG_TEMP[['2015-16MATScaleScore']])),
                ACHIEVEMENT_LEVEL=as.numeric(c(US_VI_Data_LONG_TEMP[['2014-15MATPerformanceLevel']], US_VI_Data_LONG_TEMP[['2015-16MATPerformanceLevel']])),
                SCHOOL_NUMBER=c(US_VI_Data_LONG_TEMP[['2014-15MATSchoolNum']], US_VI_Data_LONG_TEMP[['2015-16MATSchoolNum']]),
                DISTRICT_NUMBER=c(US_VI_Data_LONG_TEMP[['2014-15MATDistrictID']], US_VI_Data_LONG_TEMP[['2015-16MATDistrictID']]),
                ORIGIN="VI")


US_Virgin_Islands_Data_LONG <- rbindlist(list(US_VI_Data_LONG_ELA, US_VI_Data_LONG_MATHEMATICS))

US_Virgin_Islands_Data_LONG <- US_Virgin_Islands_Data_LONG[!is.na(SCALE_SCORE)]

US_Virgin_Islands_Data_LONG[,ACHIEVEMENT_LEVEL:=as.character(factor(ACHIEVEMENT_LEVEL, labels=c("Not Met Standard", "Nearly Met Standard", "Met Standard", "Exceeded Standard")))]
US_Virgin_Islands_Data_LONG[GRADE %in% c("2", "9", "10"), VALID_CASE:="INVALID_CASE"]


### Tidy up Hawaii LONG Data

Hawaii_Data_LONG_DeIdentified[CONTENT_AREA=="READING", CONTENT_AREA:="ELA"]


### Merge in de-identified Hawaii data

US_Virgin_Islands_Data_LONG <- rbindlist(list(US_Virgin_Islands_Data_LONG, Hawaii_Data_LONG_DeIdentified), fill=TRUE)


### setkey

setkey(US_Virgin_Islands_Data_LONG, VALID_CASE, CONTENT_AREA, YEAR, ID)


### Save LONG Data

save(US_Virgin_Islands_Data_LONG, file="Data/US_Virgin_Islands_Data_LONG.Rdata")
