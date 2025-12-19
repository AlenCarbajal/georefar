#' Reemplaza NULL por NA
#'
#' Recursively replaces NULL values with NA in a list or vector.
#' This function is useful for handling NULL values in API responses
#' before converting them to data frames.
#'
#' @param x A list, vector, or single value to process
#' @return The input with all NULL values replaced by NA
#' @keywords internal
replace_null_with_na <- function(x) {
  if (is.list(x)) {
    # If it's a list, apply the function recursively to each element
    lapply(x, replace_null_with_na)
  } else {
    if(is.null(x)) NA else x
  }
}
