## loads ibraries
library("readr")
library("lubridate")
library("dplyr")

## downloads dataset
url_link <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url = url_link, destfile = "data.zip", quiet = TRUE)
rm(url_link)

## reads rows only with 2007-02-01 and 2007-02-02 
df_uci <- read_delim("data.zip", delim = ";", trim_ws = TRUE, na = c("?", "NA"),
                     skip = 66637, n_max = 2880, col_names = FALSE)
df_col <- read_delim("data.zip", delim = ";", trim_ws = TRUE, na = c("?", "NA"),
                     n_max = 1)
## assigns column names to dataframe
names(df_uci) <- colnames(df_col)

## converts the data column to a date format and ads a date_time column
## as a date-time format
df_uci <- df_uci %>%
        mutate(Date = dmy(gsub("[[:punct:]]", "-", Date))) %>%
        mutate(date_time = as.POSIXct(paste(Date, Time)))

## plot functions
png(filename = "plot2.png")
with(df_uci, plot(Global_active_power ~ date_time, type = "l", 
                    ylab = "Global Active Power (kilowatts)", xlab =""))
dev.off()

