#' Get list of igrps
#'
#'@export
#'@param username Username to access data, string
#'@param password Password to access data, string
#'
#'@return Data frame which contains all installation groups (igrp), available for given user
#'@examples \dontrun{
#'df <- getIGRP("username", "password")
#'}
#'
#'@importFrom RCurl getURL
#'@importFrom jsonlite fromJSON
#'

getIGRP <- function(username, password) {
  base_url <- "https://api.infinitycloud.com"
  url <- paste0(base_url, "/reports/v2/igrps?format=jsonarray", "")
  auth <- paste0(username, ":", password)

  content <- RCurl::getURL(url, userpwd=auth, httpauth = 1L)

  df <- jsonlite::fromJSON(content)
  if (is.character(df)) {
    print(df)
  }

  return(df)
}
