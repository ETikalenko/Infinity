library(Infinity)

username = "princely.bibi@coastdigital.co.uk"
password = "C04stD1g1t4l"

# using startDate and endDate fields to filter records
# sort by triggerDatetime in descending order
p <- triggerInit(igrp = 840,
                        trigger = "calls",
                        limit = 500,
                        sort = "triggerDatetime-desc",
                        startDate = "2016-03-15",
                        endDate = "2016-04-01",
                        display = c("triggerDatetime",
                                    "srcPhoneNumber",
                                    "callState",
                                    "txr",
                                    "destPhoneNumber",
                                    "ringTime",
                                    "goalTitle"))
url <- buildUrl(p)
df <- getReport(url, username, password)

# adding filter field: fetch only when ringTime <= 4 and srcPhoneNumber = 01227463508
# sort by ringTime in ascending order
p$filter <- c("ringTime-le-value-4", "srcPhoneNumber-eq-value-01227463508")
p$sort <- "ringTime-asc"

url <- buildUrl(p)
df <- getReport(url, username, password)