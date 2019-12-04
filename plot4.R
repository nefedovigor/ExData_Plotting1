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
png(filename = "plot4.png")

## defines margins and plot postioning
par(mfrow = c(2, 2), mar = c(4, 4, 4, 4), oma = c(0, 1, 0, 1))

## 1st plot
with(df_uci, plot(Global_active_power ~ date_time, type = "l", 
                    ylab = "Global Active Power (kilowatts)", xlab =""))

## 2nd plot
with(df_uci, plot(Voltage ~ date_time, type = "l", 
                    ylab = "Voltage", xlab =""))

## 3rd plot
with(df_uci, plot(Sub_metering_1 ~ date_time, type = "l",
                    ylab = "Energy sub metering", xlab =""))
lines(df_uci$Sub_metering_2 ~ df_uci$date_time, type = "l", col = "red")
lines(df_uci$Sub_metering_3 ~ df_uci$date_time, type = "l", col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = 1, cex = 0.6, bty = "n")

## 4th plot
with(df_uci, plot(Global_reactive_power ~ date_time, type = "l", 
                    ylab = "Voltage", xlab =""))
dev.off()