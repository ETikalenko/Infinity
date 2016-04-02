#' Function to build url for getting reports from Infinity API
#'
#' Function to build url for getting reports from Infinity API and to perform validation of some fields.
#' URL can be used for getting raw data in browser.
#'
#' @export
#'
#' @param param.list List of all request parameters. See \code{\link{getReport}} for full example.
#'
#' @return URL for getting reports.

buildUrl <- function(param.list) {

  max.rows <- 10000

  # Validate some required fields
  CheckFields <- function(){
    if (is.null(trigger)) stop("trigger must be defined")

    if (is.null(params["igrp"])) stop("igrp must be defined")

    if (is.null(limit)) stop("limit must be defined")

    if (is.null(params.array["sort"])) stop("sort must be defined")
  }

  trigger <- param.list$trigger
  limit <- param.list$limit
  assign(x="callLimit", value=limit, envir=inf.env)
  assign(x="max.rows", value=max.rows, envir=inf.env)

  params <- c(
    "igrp" = param.list$igrp,
    "offset" = param.list$offset,
    "startDate" = param.list$startDate,
    "endDate" = param.list$endDate,
    "tz" = param.list$tz,
    "attributionModelId" = param.list$attributionModelId,
    "nestAttributions" = param.list$nestAttributions)

  params.array <- c(
    "sort[]" = param.list$sort,
    "filter[]" = param.list$filter,
    "display[]" = param.list$display)

  CheckFields()

  base.url <- "https://api.infinitycloud.com/reports/v2/triggers/"

  # if need to retrieve more than 10000 rows, then add sort by rowId before all other sorts. It's necessary for pagination
  if (limit > max.rows) {
    url <- paste0(base.url, trigger, "?limit=", max.rows, "&", "sort[]=rowId-asc&")
  } else {
    url <- paste0(base.url, trigger, "?limit=", limit, "&")
  }

  i <- 0
  # add all not-null parameters which are not arrays to url
  for (i in 1:length(params)) {
      if (!is.null(params[i])) url <- paste0(url, names(params[i]), "=", params[i], "&")
  }

  # add array parameters to url
  for (i in 1:length(params.array)) {
      if (!is.null(params.array[i])) {
        # before paste, need to delete tail of numbers in names params.array after []
        url <- paste0(url, gsub(pattern="[0-9]",replacement="", x=names(params.array[i])), "=", params.array[i], "&")
      }
  }

  # add format of report - jsonarray
  url <- paste0(url, "format=jsonarray")

  return(url)
}
