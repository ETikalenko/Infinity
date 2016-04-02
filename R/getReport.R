#' Function for getting report from Infinity API
#'
#' @export
#'
#' @param url  URL for getting data. See \code{\link{buildUrl}}
#' @param pagination   Results from the Infinity API are restricted to a maximum of number of rows per request.
#' This maximum number is typically 10,000 and if you specify a higher limit value the API will return an error.
#' For getting of all records parameter pagination = TRUE.
#' If the number of rows in result data frame will be less than 10,000 than pagination doesn't used.
#' @param username  Username
#' @param password  Password
#'
#' @examples
#' \dontrun{
#'# Create list of parameters
#' params <- triggerInit(igrp = 840,
#'                      trigger = "calls",
#'                      limit = 10500,
#'                      sort = "triggerDatetime-desc"
#'                      display = c("triggerDatetime",
#'                                  "srcPhoneNumber",
#'                                  "callState",
#'                                  "txr",
#'                                  "destPhoneNumber",
#'                                  "ringTime"))
#'# Build URL for getting report
#'  url <- buildUrl(params)
#'
#'# Getting report from Infinity API to data frame
#'  df <- getReport(url, username, password, pagination = TRUE)
#'}
#'
#'@importFrom RCurl getURL
#'@importFrom jsonlite fromJSON

getReport <- function(url, username, password, pagination = FALSE) {

  max.rows <- get("max.rows", envir=inf.env)
  callLimit <- get("callLimit", envir=inf.env)

  auth <- paste0(username, ":", password)

  content <- RCurl::getURL(url, userpwd=auth, httpauth = 1L)

  df <- data.frame()

  # Incorrect empty response. Content contains symbols "\n]\n" which can't be parsed by RJSONIO
  if (content != "\n]\n") {
    df <- jsonlite::fromJSON(content)

  } else print("Empty response...")

  # Validation error messages from API are as text content of df
  if (is.character(df)) {
    print(df)
  } else {
    if ((pagination == FALSE) & (nrow(df) == max.rows) & (callLimit > max.rows)) {
      print("API returned 10000 rows. For getting all records, please set pagination = TRUE in getReport function")
    }

    if ((pagination == TRUE) & (nrow(df) == max.rows) & (callLimit > max.rows)) {
      n <- 0
      while(callLimit > max.rows) {
        n <- n + 1
        callLimit <- callLimit - max.rows

        if (callLimit < max.rows) {
          # offset on new value of callLimit, else - offset on next max.row
          temp.content <- RCurl::getURL(paste0(url,"&offset=", (n-1)*max.rows+callLimit, "&limit=", callLimit), userpwd=auth, httpauth = 1L)
        } else temp.content <- RCurl::getURL(paste0(url,"&offset=", n*max.rows, "&limit=", max.rows), userpwd=auth, httpauth = 1L)

        if (temp.content != "\n]\n") {
          temp.df <- jsonlite::fromJSON(temp.content)
          df <- rbind(df, temp.df)
        } else break
      }
    }
  }

  return(invisible(df))
}
