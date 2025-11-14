are_post_batch_request <- function(endpoint, single_batch_queries_list) {
  token <- Sys.getenv("GEOREFAR_TOKEN")
  url <- paste0(base_url, endpoint)

  body_data <- list()
  body_data[[endpoint]] <- single_batch_queries_list

  req <- httr2::request(url) |>
    httr2::req_method("POST") |>
    httr2::req_body_json(data = body_data, auto_unbox = TRUE) |>
    # httr2::req_error will convert responses with status != 200 to an R error,
    # which req_perform_parallel(on_error="return") will then return as that error object.
    # The httr2_error_handler provides a formatted message for such errors.
    httr2::req_error(is_error = ~ httr2::resp_status(.x) != 200, body = httr2_error_handler)

  if (!is.null(token) && token != "") {
    req <- req |> httr2::req_auth_bearer_token(token)
  }

  return(req)
}
