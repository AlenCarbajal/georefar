library(httr2)


get_endpoint <- function(endpoint, args) {
  check_internet()
  args_clean <- purrr::discard(args, is.null)

  if (!assertthat::noNA(args_clean)) {
    stop(c(err_msg(), sapply(names(args_clean[is.na(args_clean)]),
                                                                                   function(x) paste0(" ", x),
                                                                                   USE.NAMES = F)))
  }

  token <- Sys.getenv("GEOREFAR_TOKEN")

  req <- request(paste0(base_url, endpoint)) |>
    req_url_query(!!!args_clean) |>
    req_error(is_error = ~ resp_status(.x) != 200,
               body = httr2_error_handler)

  if (!is.null(token) && token != "") {
    req <- req |> req_auth_bearer_token(token)
  }

  # Use req_perform() for synchronous behavior needed by get_endpoint
  response <- req_perform(req)

  parsed <- resp_body_json(response)

  data_list <- parsed[[gsub(pattern = "-", replacement = "_", x = endpoint)]]

  if (is.null(data_list)) {
    data_list <- list() # Ensure it's an empty list if the key wasn't found or was null
  }

  data <- data_list |>
    purrr::modify_if(is.null, list) # Convert NULL elements within the list to list() for as_tibble

  if (length(data) == 0) {
    warning("La consulta devolvió una lista vacía", call. = FALSE)
  }

  data |>
    dplyr::bind_rows() |>
    dplyr::as_tibble(.name_repair = function(x) {gsub(pattern = "\\$|\\.", replacement = "_", x = x)})
}
