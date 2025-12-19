httr2_error_handler <- function(resp) {
  error_body_text <- ""
  tryCatch({
    if (httr2::resp_has_body(resp) && grepl("json|text|xml", httr2::resp_content_type(resp), ignore.case = TRUE)) {
      body_content <- httr2::resp_body_string(resp, encoding = "UTF-8")
      if (nchar(body_content) < 500) {
        error_body_text <- paste0(" - API Response: ", body_content)
      }
    }
  }, error = function(e) {})

  stop(paste0("API request failed: ",
              httr2::resp_status_desc(resp), " (", httr2::resp_status(resp), "). ",
              "URL: ", httr2::resp_url(resp),
              error_body_text),
       call. = FALSE)
}
