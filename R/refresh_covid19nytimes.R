#' US State Data from the NY Times
#'
#' @description Update the state-level data from the New York Times on Covid-19
#'
#' @details Pulls from the open source data at https://www.nytimes.com/article/coronavirus-county-data-us.html
#' including cummulative cases and deaths. Returns the data in the covid19R standard tidy format for easy use.
#' See https://github.com/nytimes/covid-19-data for extensive methodology description and license.
#'
#' @source New York Times, "We’re Sharing Coronavirus Case Data for Every U.S. County" \href{https://www.nytimes.com/article/coronavirus-county-data-us.html}{article} and {https://github.com/nytimes/covid-19-data}{data repository}
#' @source \href{https://github.com/Covid19R/documentation}{covid19R documentation}
#'
#' @return A tibble object
#' * date - The date in YYYY-MM-DD form
#' * location - The name of the location as provided by the data source. The counties dataset provides county and state. They are combined and separated by a `,`, and can be split by `tidyr::separate()`, if you wish.
#' * location_type - The type of location using the covid19R controlled vocabulary. Nested locations are indicated by multiple location types being combined with a `_
#' * location_standardized - A standardized location code using a national or international standard. In this case, FIPS state or county codes. See https://en.wikipedia.org/wiki/Federal_Information_Processing_Standard_state_code and https://en.wikipedia.org/wiki/FIPS_county_code for more
#' * location_standardized_type The type of standardized location code being used according to the covid19R controlled vocabulary. Here we use `fips_code`
#' * data_type - the type of data in that given row. Includes `total_cases` and `total_deaths`, cummulative measures of both.
#' * value - number of cases of each data type
#' @export refresh_covid19nytimes_states
#'
#' @examples
#'\dontrun{
#'
#' #update the data
#' covid19nytimes_states <- refresh_covid19nytimes_states()
#'
#'
#' }

refresh_covid19nytimes_states <- function(){
  url <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv"

  #load the data
  dat <- readr::read_csv(url,
                         col_types = list(
                           date = readr::col_date(),
                           state = readr::col_character(),
                           fips = readr::col_character(),
                           cases = readr::col_double(),
                           deaths = readr::col_double()
                         ))

  #reshape to data standard
  dat <- dat %>%
    dplyr::rename(cases_total = cases,
                  deaths_total = deaths,
           fips_code = fips) %>%
    tidyr::pivot_longer(cols = c(cases_total, deaths_total),
                        names_to = "data_type",
                        values_to = "value") %>%
    tidyr::pivot_longer(cols = state,
                        names_to = "location_type",
                        values_to = "location") %>%
    tidyr::pivot_longer(cols = fips_code,
                        names_to = "location_standardized_type",
                        values_to = "location_standardized") %>%
    dplyr::select(date,
           location, location_type,
           location_standardized, location_standardized_type,
           data_type, value)

  #return
  return(dat)
}


#' US County Data from the NY Times
#'
#' @description Update the county-level data from the New York Times on Covid-19
#'
#' @details Pulls from the open source data at https://www.nytimes.com/article/coronavirus-county-data-us.html
#' including cummulative cases and deaths. Returns the data in the covid19R standard tidy format for easy use.
#' Location data is returned as `County,State`.
#' See https://github.com/nytimes/covid-19-data for extensive methodology description and license.
#'
#' @source New York Times, "We’re Sharing Coronavirus Case Data for Every U.S. County" \href{https://www.nytimes.com/article/coronavirus-county-data-us.html}{article} and {https://github.com/nytimes/covid-19-data}{data repository}
#' @source \href{https://github.com/Covid19R/documentation}{covid19R documentation}
#'
#' @return A tibble object
#' * date - The date in YYYY-MM-DD form
#' * location - The name of the location as provided by the data source. The counties dataset provides county and state. They are combined and separated by a `,`, and can be split by `tidyr::separate()`, if you wish.
#' * location_type - The type of location using the covid19R controlled vocabulary. Nested locations are indicated by multiple location types being combined with a `_
#' * location_standardized - A standardized location code using a national or international standard. In this case, FIPS state or county codes. See https://en.wikipedia.org/wiki/Federal_Information_Processing_Standard_state_code and https://en.wikipedia.org/wiki/FIPS_county_code for more
#' * location_standardized_type The type of standardized location code being used according to the covid19R controlled vocabulary. Here we use `fips_code`
#' * data_type - the type of data in that given row. Includes `total_cases` and `total_deaths`, cummulative measures of both.
#' * value - number of cases of each data type
#' @export refresh_covid19nytimes_counties
#'
#' @examples
#'\dontrun{
#'
#' #update the data
#' covid19nytimes_counties <- refresh_covid19nytimes_counties()
#'
#'
#' }

refresh_covid19nytimes_counties <- function(){
  url <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv"

  #load the data
  dat <- readr::read_csv(url,
                         col_types = list(
                           date = readr::col_date(),
                           county = readr::col_character(),
                           state = readr::col_character(),
                           fips = readr::col_character(),
                           cases = readr::col_double(),
                           deaths = readr::col_double()
                         ))

  #reshape to data standard
  dat <- dat %>%
    dplyr::mutate(county_state = paste(county, state, sep = ",")) %>%
    dplyr::rename(cases_total = cases,
                  deaths_total = deaths,
                  fips_code = fips) %>%
    tidyr::pivot_longer(cols = c(cases_total, deaths_total),
                        names_to = "data_type",
                        values_to = "value") %>%
    tidyr::pivot_longer(cols = county_state,
                        names_to = "location_type",
                        values_to = "location") %>%
    tidyr::pivot_longer(cols = fips_code,
                        names_to = "location_standardized_type",
                        values_to = "location_standardized") %>%
    dplyr::select(date,
                  location, location_type,
                  location_standardized, location_standardized_type,
                  data_type, value)

  return(dat)
}
