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
US_VI_ELA <- fread("Data/Base_Files/US_Virgin_Islands_ELA.txt")
US_VI_MATHEMATICS <- fread("Data/Base_Files/US_Virgin_Islands_MATHEMATICS.txt")


### Tidy up US_VI Data

US_VI_ELA_LONG <- data.table(
                VALID_CASE="VALID_CASE",
                YEAR=rep(c("2015", "2016"), each=nrow(US_VI_ELA)),
                CONTENT_AREA="ELA",
                GRADE=as.character(c(US_VI_ELA$GradeLevelWhnAssessed-1, US_VI_ELA$GradeLevelWhnAssessed)),
                ID=paste0(US_VI_ELA$StudentIdentifier, "E"),
                SCALE_SCORE=as.numeric(c(US_VI_ELA[['2014_SS']], US_VI_ELA[['2015_SS']])),
                ACHIEVEMENT_LEVEL=as.numeric(c(US_VI_ELA[['2014_PL']], US_VI_ELA[['2015_PL']])),
                SCHOOL_NUMBER=c(rep(NA, nrow(US_VI_ELA)), US_VI_ELA$ResponsibleSchoolIdentifier),
                DISTRICT_NUMBER=c(rep(NA, nrow(US_VI_ELA)), US_VI_ELA$ResponsibleDistrictIdentifier),
                ORIGIN="VI")

US_VI_MATHEMATICS_LONG <- data.table(
                VALID_CASE="VALID_CASE",
                YEAR=rep(c("2015", "2016"), each=nrow(US_VI_MATHEMATICS)),
                CONTENT_AREA="MATHEMATICS",
                GRADE=as.character(c(US_VI_MATHEMATICS$GradeLevelWhnAssessed-1, US_VI_MATHEMATICS$GradeLevelWhnAssessed)),
                ID=paste0(US_VI_MATHEMATICS$StudentIdentifier, "M"),
                SCALE_SCORE=as.numeric(c(US_VI_MATHEMATICS[['2014_SS']], US_VI_MATHEMATICS[['2015_SS']])),
                ACHIEVEMENT_LEVEL=as.numeric(c(US_VI_MATHEMATICS[['2014_PL']], US_VI_MATHEMATICS[['2015_PL']])),
                SCHOOL_NUMBER=c(rep(NA, nrow(US_VI_MATHEMATICS)), US_VI_MATHEMATICS$ResponsibleSchoolIdentifier),
                DISTRICT_NUMBER=c(rep(NA, nrow(US_VI_MATHEMATICS)), US_VI_MATHEMATICS$ResponsibleDistrictIdentifier),
                ORIGIN="VI")

US_Virgin_Islands_Data_LONG <- rbindlist(list(US_VI_ELA_LONG, US_VI_MATHEMATICS_LONG))

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
