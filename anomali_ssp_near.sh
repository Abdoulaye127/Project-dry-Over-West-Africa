SET MEMORY/SIZE = 10000 ! Set memory size
can data /all  ! Cancel all data
can win /all  ! Cancel all windows
set win/new  ! Set new window

! Load SSP projection data
use cdd_pr_day_ssp126_2031-2060_west_Africa_Ensmean.nc
let ssp126 = CONSECUTIVE_DRY_DAYS_INDEX_PER_TIME_PERIOD[l=@ave,d=1]

use cdd_pr_day_ssp245_2031-2060_west_Africa_Ensmean.nc
let ssp245 = CONSECUTIVE_DRY_DAYS_INDEX_PER_TIME_PERIOD[l=@ave,d=1]

use cdd_pr_day_ssp585_2031-2060_west_Africa_Ensmean.nc
let ssp585 = CONSECUTIVE_DRY_DAYS_INDEX_PER_TIME_PERIOD[l=@ave,d=1]

! Load historical data (replace with your actual historical data file)
use cdd_pr_day_historical_1985-2014_west_Africa_Ensmean.nc
let historical = CONSECUTIVE_DRY_DAYS_INDEX_PER_TIME_PERIOD[l=@ave,d=1]

! Calculate anomalies
let anomaly_ssp126 = ssp126 - historical
let anomaly_ssp245 = ssp245 - historical
let anomaly_ssp585 = ssp585 - historical

! Visualization for SSP126 anomaly
set VIEW V1
PPL AXLABP 0 0
fill/pal=orange_purple/nolabel anomaly_ssp126
label -5 33 -1 0 0.15 @P7 SSP126 Anomaly

! Visualization for SSP245 anomaly
set VIEW V2
PPL AXLABP 0 0
fill/pal=orange_purple/nolabel anomaly_ssp245
label -5 33 -1 0 0.15 @P7 SSP245 Anomaly

! Visualization for SSP585 anomaly
set VIEW V3
PPL AXLABP 0 0
fill/pal=orange_purple/nolabel anomaly_ssp585
label -5 33 -1 0 0.15 @P7 SSP585 Anomaly

! Final adjustments to display
go land 7 "" 1

