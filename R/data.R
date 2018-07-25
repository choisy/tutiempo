#' Meteorological data for Southeast Asia
#'
#' A data containing the daily meteorological data for 7 countries in Southeast
#' Asia, from  \href{https://en.tutiempo.net}{en.tutiempo.net}.
#'
#' @format A data frame with 3,319,182 rows and 16 variables:
#' \itemize{
#'  \item \code{station}: climatic station ID
#'  \item \code{day}: date of data colletion
#'  \item \code{ta}: average temperature (Centigrad)
#'  \item \code{tx}: maximum temperature (Centigrad)
#'  \item \code{tn}: minimum temperature (Centigrad)
#'  \item \code{slp}: atmospheric pressure at sea level (hPa)
#'  \item \code{h}: average relative humidity (%)
#'  \item \code{pp}: total rainfall and / or snowmelt (mm)
#'  \item \code{vv}: average visibility (km)
#'  \item \code{v}: average wind speed (km / h)
#'  \item \code{vm}: maximum sustained wind speed (km / h)
#'  \item \code{vg}: maximum speed of wind (km / h)
#'  \item \code{ra}: boolean indicating whether there was rain or drizzle
#'  \item \code{sn}: boolean indicating whether it snowed
#'  \item \code{ts}: boolean indicating whether there were storm
#'  \item \code{fg}: boolean indicating whether there was fod
#' }
#'
#' @details The variable \code{station} is a key shared with dataset
#' \code{\link{stations}}.
#' @source \href{https://en.tutiempo.net}{en.tutiempo.net}.
"meteo"

# ------------------------------------------------------------------------------

#' Locations and elevations of climatic stations
#'
#' A dataset containing the coordinates and elevations of the climatic stations
#' contained in the \code{meteo} data frame.
#'
#' @format A data frame with 261 rows and 7 variables:
#' \itemize{
#'  \item \code{station}: climatic station ID
#'  \item \code{country}: country of the climatic station
#'  \item \code{location}: location of the climatic station
#'  \item \code{longitude}: longitude of the climatic station (decimal coordinates)
#'  \item \code{latitude}: latitude of the climatic station (decimal coordinates)
#'  \item \code{elevation}: elevation of the climatic station (m)
#'  \item \code{from}: year from which the data started being collected
#' }
#'
#' @details The variable \code{station} is a key shared with dataset
#' \code{\link{meteo}}.
#' @source \href{https://en.tutiempo.net}{en.tutiempo.net}.
"stations"
