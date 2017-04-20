# Remove the last 2 lines of a matrix m: ---------------------------------------
rm_summaries <- function(m) {
  n <- nrow(m)
  m[-((n - 1):n), ]
}


# Coerce a matrix m to a data frame using the first line for the variable names:
as.data.frame2 <- function(m) {
  setNames(as.data.frame(m, as.is = TRUE), m[1, ])[-1, ]
}


# Downloads data from the URL url and organize it into a data frame: -----------
get_page <- function(url) {
  require(magrittr) # for the " %>% " operator
  require(xml2) # for "read_html"
  require(rvest) # for "html_node", "html_text"
  print(url)
  url %>%
    read_html %>%
    html_nodes(".mensuales td , th") %>%
    html_text %>%
    matrix(ncol = 15, byrow = TRUE) %>%
    rm_summaries %>%
    as.data.frame2
}


# A safe version of the get_page function: -------------------------------------
# Tries the URL again and again if internet is interrupted and handle specific
# errors (e.g. 404).
safe_get_page <- function(..., error) {
  require(purrr) # for "safely"
  while(TRUE) {
    out <- safely(get_page)(...)
    if(is.null(out$error)) return(out$result)
    else if(grepl(error, out$error)) return(error)
  }
}


# Pad 1-digit numbers to 2-digit ones with zeros on the left: ------------------
pad <- function(x) {
  require(stringr) # for "str_pad"
  str_pad(as.character(x), 2, pad = "0")
}


# Build an URL from a year, a month and a station: -----------------------------
make_url <- function(year, month, station) {
  paste0("http://en.tutiempo.net/climate/",
         pad(month), "-", year, "/ws-", station, ".html")
}


# Give the slots of a list l that do not contain the error message eror: -------
where_no_error <- function(l, error) {
  require(magrittr) # for the " %>% " operator
  l %>%
    map(function(x) x != error) %>%
    map(`[`, 1) %>%
    unlist %>%
    which
}


# Downloads the data for the station station: ----------------------------------
download_data <- function(station, years, months = 1:12, error = "HTTP error 404") {
  require(magrittr) # for the " %>% " operator
  require(zeallot) # for the " %<-% " operator
  require(purrr) # for "map", "map2", "map_int"
  require(dplyr) # for "bind_rows", "select", "mutate", "mutate_if", "mutate_at"
  require(lubridate) # for "ymd"
  {months:years} %<-% expand.grid(months, years)
  out <- map2(years, months, make_url, station = station) %>%
    map(safe_get_page, error = error)
  sel <- where_no_error(out, error)
  out %<>% `[`(sel)
  months %<>% `[`(sel)
  years %<>% `[`(sel)
  n <- map_int(out, nrow)
  out <- data.frame(year = rep(years, n), month = rep(months, n), bind_rows(out)) %>%
    mutate(day = ymd(paste0(year, "-", pad(month), "-", pad(Day)))) %>%
    select(-year, -month, -Day) %>%
    select(day, everything()) %>%
    mutate_if(is.factor, as.character) %>%
    mutate_at(vars(T, TM, Tm, SLP, PP, VV, V, VM, VG), as.numeric) %>%
    mutate_at(vars(H), as.integer) %>%
    mutate_at(vars(RA, SN, TS, FG), function(x) x == "o")
  names(out) %<>%
    sub("^T$", "ta", .) %>%
    sub("TM", "tx", .) %>%
    sub("Tm", "tn", .) %>%
    tolower
  out
}


# Make the data sets: ----------------------------------------------------------
library(readxl) # for "read_excel"
library(purrr) # for "map2"
stations <- read_excel("climatic stations.xlsx")
download_data2 <- function(station, year) {
  download_data(station, year:2016)
}
out <- stations %$% map2(station, from, download_data2)


#vientiane <- download_data(489400,1954:2016)
#devtools::use_data(vientiane, overwrite = TRUE)
