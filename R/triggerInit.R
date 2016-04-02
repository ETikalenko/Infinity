#' Collect request parameters
#'
#' Function collects all request parameters in one list for passing to function \code{\link{buildUrl}}
#'
#' @export
#' @param igrp  (int) Installation ID
#' @param trigger - (string) A trigger represents a single tracked event in Infinity.
#'
#' Possible values:
#'
#'     all  -   Get all triggers
#'
#'     calls   - Get all call triggers ( where trigger action is call )
#'
#'     calls/users    - Get all Hosted PBX Call User triggers ( where trigger action is callUser )
#'
#'     callStatus    - Get all call status triggers ( where trigger action is callBlegStart or callAlegStop )
#'
#'     goals   -  Get all goal triggers ( where trigger is marked as a goal )
#'
#'     transactions   -  Get all transaction triggers ( where trigger has transaction currency or goal currency fields )#'
#'                      callRate triggers are excluded from these reports
#'
#'     callsGoalsTransactions  -   Get all triggers with any transaction, call or goal details.
#'                                This is a union of the three routes "calls", "goals" and "transactions" described above
#'
#'     touchPoints  -   Get all touch point triggers.
#'                     This is a collection of recent land, call and goal triggers.
#'                     You can only query back as far as your Installation's trigger retention period on this route
#'
#' @param limit  (int) Limit result set.
#'
#' @param offset  (int) Offset result set.
#'
#' @param sort  (array) One or more sorts. String or vector of strings.
#'
#' @param filter  (array) Optional. One or more filters. String or vector of strings.
#'
#' @param startDate  (string) Optional. Start Date to filter by, Start Date must be of the format YYYY-MM-DD.
#'
#' @param endDate  (string) Optional. End Date to filter by, End Date must be of the format YYYY-MM-DD.
#'
#' @param tz  (string) Optional. Timezone to convert to.
#'
#' @param display  (array) Optional. One ore more fields to display in report. String or vector of strings.
#'
#' @param attributionModelId  (int) Optional. Attribution Model ID to use for report. Can be 'none' to remove attribution data from report.
#'
#' @param nestAttributions  (int) Optional. Enables/Disables nested multiple attribution output. If disabled will return multiple rows per trigger for each attributed land.
#'
#' @seealso
#' Full description of filter and sort fields can be found at \url{https://www.infinitycloud.com/service/api/reports_v2_triggers.html}
#'
#' @return List of parameters required for getting reports
#'
#' @examples \dontrun{
#' params <- triggerInit(igrp = 840,
#'                      trigger = "calls",
#'                      limit = 50,
#'                      sort = "triggerDatetime-desc"
#'                      display = c("triggerDatetime",
#'                                  "srcPhoneNumber",
#'                                  "callState",
#'                                  "txr",
#'                                  "destPhoneNumber",
#'                                  "ringTime"))
#'}

triggerInit <- function(
  igrp = NULL,
  trigger = NULL,
  limit = NULL,
  offset = NULL,
  sort = NULL,
  filter = NULL,
  startDate = NULL,
  endDate = NULL,
  tz = NULL,
  display = NULL,
  attributionModelId = NULL,
  nestAttributions = NULL) {

  params <- list(
    "igrp" = igrp,
    "trigger" = trigger,
    "limit" = limit,
    "offset" = offset,
    "sort" = sort,
    "filter" = filter,
    "startDate" = startDate,
    "endDate" = endDate,
    "tz" = tz,
    "display" = display,
    "attributionModelId" = attributionModelId,
    "nestAttributions" = nestAttributions)

  return(params)
}
