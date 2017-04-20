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
  repeat {
    out <- safely(get_page)(...)
    if(is.null(out$error) || grepl(error, out$error)) return(out)
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


# Downloads the data for the station station: ----------------------------------
download_data <- function(station, years, months = 1:12, error = "HTTP error 404") {
  require(magrittr) # for the " %>% " operator
  require(zeallot) # for the " %<-% " operator
  require(purrr) # for "map", "map2", "map_int"
  require(dplyr) # for "bind_rows", "select", "mutate", "mutate_if", "mutate_at"
  require(lubridate) # for "ymd"
  {months:years} %<-% expand.grid(months, years)
  out <- map2(years, months, make_url, station = station) %>%
    map(safe_get_page, error = error) %>%
    transpose
  out <- out$result %>%
    setNames(paste(years, pad(months), sep = "-")) %>%
    `[`(sapply(out$error,is.null)) %>%
    bind_rows(.id = "ym") %>%
    mutate(day=ymd(paste(ym, pad(Day), sep = "-"))) %>%
    select(-ym, -Day) %>%
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
library(dplyr) # for "filter"
library(magrittr) # for "%$%"

stations <- read_excel("climatic stations.xlsx")

download_data2 <- function(station, year) {
  download_data(station, year:2016)
}

out <- stations %$% map2(station, from, download_data2)
cambodia <- stations %>% filter(country=="Cambodia") %$% map2(station, from, download_data2)
save.image()
malaysia <- stations %>% filter(country=="Malaysia") %$% map2(station, from, download_data2)
save.image()
vietnam1 <- stations %>% filter(country=="Vietnam") %>% head(5) %$% map2(station, from, download_data2)
vietnam2 <- stations %>% filter(country=="Vietnam") %>% slice(6:10) %$% map2(station, from, download_data2)
vietnam3 <- stations %>% filter(country=="Vietnam") %>% slice(11:15) %$% map2(station, from, download_data2)
vietnam4 <- stations %>% filter(country=="Vietnam") %>% slice(16:20) %$% map2(station, from, download_data2)
vietnam5 <- stations %>% filter(country=="Vietnam") %>% slice(21:25) %$% map2(station, from, download_data2)
vietnam6 <- stations %>% filter(country=="Vietnam") %>% slice(26:30) %$% map2(station, from, download_data2)
vietnam7 <- stations %>% filter(country=="Vietnam") %>% slice(31:35) %$% map2(station, from, download_data2)
save.image()

myanmar1 <- stations %>% filter(country=="Myanmar") %>% slice(1:5) %$% map2(station, from, download_data2)
save.image()
myanmar2 <- stations %>% filter(country=="Myanmar") %>% slice(6:10) %$% map2(station, from, download_data2)
save.image()
myanmar3 <- stations %>% filter(country=="Myanmar") %>% slice(11:15) %$% map2(station, from, download_data2)
save.image()
myanmar4 <- stations %>% filter(country=="Myanmar") %>% slice(16:20) %$% map2(station, from, download_data2)
save.image()
myanmar5 <- stations %>% filter(country=="Myanmar") %>% slice(21:25) %$% map2(station, from, download_data2)
save.image()
myanmar6 <- stations %>% filter(country=="Myanmar") %>% slice(26:30) %$% map2(station, from, download_data2)
save.image()
myanmar7 <- stations %>% filter(country=="Myanmar") %>% slice(31:35) %$% map2(station, from, download_data2)
save.image()
myanmar8 <- stations %>% filter(country=="Myanmar") %>% slice(36:39) %$% map2(station, from, download_data2)
save.image()

philippines1 <- stations %>% filter(country=="Philippines") %>% slice(1:5) %$% map2(station, from, download_data2)
save.image()
philippines2 <- stations %>% filter(country=="Philippines") %>% slice(6:10) %$% map2(station, from, download_data2)
save.image()
philippines3 <- stations %>% filter(country=="Philippines") %>% slice(11:15) %$% map2(station, from, download_data2)
save.image()
philippines4 <- stations %>% filter(country=="Philippines") %>% slice(16:20) %$% map2(station, from, download_data2)
save.image()
philippines5 <- stations %>% filter(country=="Philippines") %>% slice(21:25) %$% map2(station, from, download_data2)
save.image()
philippines6 <- stations %>% filter(country=="Philippines") %>% slice(26:30) %$% map2(station, from, download_data2)
save.image()
philippines7 <- stations %>% filter(country=="Philippines") %>% slice(31:35) %$% map2(station, from, download_data2)
save.image()
philippines8 <- stations %>% filter(country=="Philippines") %>% slice(36:40) %$% map2(station, from, download_data2)
save.image()
philippines9 <- stations %>% filter(country=="Philippines") %>% slice(41:45) %$% map2(station, from, download_data2)
save.image()
philippines10 <- stations %>% filter(country=="Philippines") %>% slice(46:50) %$% map2(station, from, download_data2)
save.image()
philippines11 <- stations %>% filter(country=="Philippines") %>% slice(51:52) %$% map2(station, from, download_data2)
save.image()

thailand1 <- stations %>% filter(country=="Thailand") %>% slice(1:5) %$% map2(station, from, download_data2)
save.image()

thailand2 <- stations %>% filter(country=="Thailand") %>% slice(6:10) %$% map2(station, from, download_data2)
save.image()
thailand3 <- stations %>% filter(country=="Thailand") %>% slice(11:15) %$% map2(station, from, download_data2)
save.image()
thailand4 <- stations %>% filter(country=="Thailand") %>% slice(16:20) %$% map2(station, from, download_data2)
save.image()
thailand5 <- stations %>% filter(country=="Thailand") %>% slice(21:25) %$% map2(station, from, download_data2)
save.image()
thailand6 <- stations %>% filter(country=="Thailand") %>% slice(26:30) %$% map2(station, from, download_data2)
save.image()
thailand7 <- stations %>% filter(country=="Thailand") %>% slice(31:35) %$% map2(station, from, download_data2)
save.image()
thailand8 <- stations %>% filter(country=="Thailand") %>% slice(36:40) %$% map2(station, from, download_data2)
save.image()
thailand9 <- stations %>% filter(country=="Thailand") %>% slice(41:45) %$% map2(station, from, download_data2)
save.image()
thailand10 <- stations %>% filter(country=="Thailand") %>% slice(46:50) %$% map2(station, from, download_data2)
save.image()
thailand11 <- stations %>% filter(country=="Thailand") %>% slice(51:55) %$% map2(station, from, download_data2)
save.image()
thailand12 <- stations %>% filter(country=="Thailand") %>% slice(56:60) %$% map2(station, from, download_data2)
save.image()
thailand13 <- stations %>% filter(country=="Thailand") %>% slice(60:65) %$% map2(station, from, download_data2)
save.image()
thailand14 <- stations %>% filter(country=="Thailand") %>% slice(66:70) %$% map2(station, from, download_data2)
save.image()
thailand15 <- stations %>% filter(country=="Thailand") %>% slice(71:75) %$% map2(station, from, download_data2)
save.image()
thailand16 <- stations %>% filter(country=="Thailand") %>% slice(76:80) %$% map2(station, from, download_data2)
save.image()
thailand17 <- stations %>% filter(country=="Thailand") %>% slice(81:85) %$% map2(station, from, download_data2)
save.image()
thailand18 <- stations %>% filter(country=="Thailand") %>% slice(86:91) %$% map2(station, from, download_data2)
save.image()



thailand <- stations %>% filter(country=="Thailand") %$% map2(station, from, download_data2)
save.image()


#vientiane <- download_data(489400,1954:2016)
#devtools::use_data(vientiane, overwrite = TRUE)

# ------------------------------------------------------------------------------


