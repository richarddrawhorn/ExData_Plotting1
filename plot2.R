
# load the dplyr package 
suppressPackageStartupMessages(library(dplyr))

# read the data into a data frame using the read.table function
data <- read.table(file="household_power_consumption.txt", sep=";", header=TRUE)

# convert the data frame to a tbl_df with dplyr
data <- tbl_df(data)

# filter the data for the two dates we are interested in
data <- filter(data, Date=="1/2/2007" | Date=="2/2/2007")

# concatenate Date and Time into a single string and convert it to class POSIXlt
data <- mutate(data, dt=paste(Date, Time, sep=" "))
data$dt <- strptime(data$dt, "%d/%m/%Y %H:%M:%S")

# drop the original Date and Time columns from the data
data <- select(data, -c(Date, Time))

# convert variables to their proper numeric classes
data$Global_active_power <- as.numeric(data$Global_active_power)
data$Global_reactive_power <- as.numeric(data$Global_reactive_power)
data$Voltage <- as.numeric(data$Voltage)
data$Global_intensity <- as.numeric(data$Global_intensity)
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)

# add new column for Global Active Power (megawatts)
data <- mutate(data, GAPmw=data$Global_active_power/1000)

# create PNG file
png(filename="plot2.png", width = 480, height = 480)

# create plot #2 (an x-y plot of day/time vs Global Active Power)
plot(data$dt, data$Global_active_power, ylab="Global Active Power (kilowatts)", xlab="Day/Time", type="l")

# turn off the graphics device 
dev.off()

