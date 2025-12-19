library(httr2)

process_single_post_response <- function(response_obj, endpoint, batch_size) {
  # This function assumes response_obj is a successful httr2_response
  parsed_content <- resp_body_json(response_obj, flatten = TRUE)

  if (!"resultados" %in% names(parsed_content)) {
    url_info <- tryCatch(
      resp_url(response_obj),
      error = function(e) "unknown URL"
    )
    stop(paste0("La respuesta del POST para el endpoint '", endpoint, "' (URL: ", url_info, ") no contiene el campo 'resultados' esperado."), call. = FALSE)
  }

  results_list_from_api <- parsed_content$resultados

  # The actual data items are expected to be in results_list_from_api[[endpoint]]
  actual_data_items_list <- lapply(results_list_from_api, function(x) x[[endpoint]])

  if (is.null(actual_data_items_list)) {
    warning(paste0("Expected data field '", endpoint, "' not found or is NULL within the 'resultados' field of the bulk API response. Available keys in 'resultados': ", paste(names(results_list_from_api), collapse=", ")), call. = FALSE)
    return(dplyr::tibble())
  }

  if (!is.list(actual_data_items_list)) {
    warning(paste0("Data for endpoint '", endpoint, "' within 'resultados' is not a list as expected. Type: ", class(actual_data_items_list)), call. = FALSE)
    return(dplyr::tibble())
  }

  processed_results <- purrr::map_dfr(actual_data_items_list, function(data_items_for_one_original_query) {


    if (is.null(data_items_for_one_original_query)) {
      return(dplyr::tibble())
    }
    if (is.data.frame(data_items_for_one_original_query)) {
      return(dplyr::as_tibble(data_items_for_one_original_query))
    } else if (is.list(data_items_for_one_original_query)) {
      if (length(data_items_for_one_original_query) == 0) {
        return(dplyr::tibble())
      }

      tryCatch({
        # Ensure that elements being bound are suitable for bind_rows (e.g., named lists or data.frames)
        # If data_items_for_one_original_query is a list of atomic vectors or unnamed lists, this might fail.
        # Assuming API returns list of objects (named lists) or list of data.frames.
        data_items_for_one_original_query <- replace_null_with_na(data_items_for_one_original_query)

        return(dplyr::bind_rows(lapply(data_items_for_one_original_query, as.data.frame)))

      }, error = function(e) {
        warning(paste0("Failed to bind rows for an item in '", endpoint, "' results. Item class: ", class(data_items_for_one_original_query), ". Error: ", e$message), call. = FALSE)
        return(dplyr::tibble())
      })
    } else {
      warning(paste0("Unexpected data type ('", class(data_items_for_one_original_query), "') for an item in '", endpoint, "' results. Skipping this item."), call. = FALSE)
      return(dplyr::tibble())
    }
  })


  if (ncol(processed_results) > 0) {
    # processed_results <- processed_results |>
    #   dplyr::rename_with(.fn = function(x) {gsub(pattern = "\\\\$|\\\\.", replacement = "_", x = x)})
  }

  if (nrow(processed_results) == 0 && batch_size > 0) {
    # This warning applies to a single batch. The overall warning will be in the calling post_*_bulk function.
    warning(paste0("Una tanda de ", batch_size, " consultas POST para '", endpoint, "' devolvi\\u00f3 una lista vac\\u00eda o no se pudieron procesar sus resultados."), call. = FALSE)
  }

  return(processed_results)
}
