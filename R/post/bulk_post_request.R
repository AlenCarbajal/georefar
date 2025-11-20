library(httr2)

bulk_post_request <- function(endpoint, queries_list, check_max = FALSE) {
  # Check de que es una lista de listas
  check_list_of_lists(queries_list)

  # Check parametros en cada consulta
  for (query in queries_list){
    check_params(endpoint, query)
    if (check_max == TRUE){ 
      check_max(query) 
    }
  }

  # Crear lotes
  query_batches <- create_query_batches(queries_list, param_name_for_sum = "max")

  # Check se crearon lotes
  if (length(query_batches) == 0){
    if(length(queries_list) > 0) {
      warning(
        sprintf(
          ERR_MSGS$post$BULK_POST_REQUESTS$NO_BATCHES_CREATED,
          endpoint
        ), 
        call. = FALSE
      )
    }


    return(dplyr::tibble())
  }

  # Check acceso a internet
  check_internet()

  # Preparar y enviar requests en paralelo
  all_batch_requests <- list()
  for (batch_idx in seq_along(query_batches)) {
    current_batch <- query_batches[[batch_idx]]
    request_obj <- prepare_post_batch_request(endpoint, current_batch)
    all_batch_requests <- append(all_batch_requests, list(request_obj))
  }
  responses <- req_perform_parallel(all_batch_requests, on_error = "return")
  
  # Check errores y procesar respuestas
  processed_results <- list()
  has_errors <- FALSE
  for (i in seq_along(responses)) {
    item <- responses[[i]]
    batch_size <- length(query_batches[[i]])
    if (inherits(item, "httr2_response")) {
      processed_tibble <- process_single_post_response(item, endpoint, batch_size)
      processed_results <- append(processed_results, list(processed_tibble))
    } else if (inherits(item, "error")) {
      has_errors <- TRUE
      warning(sprintf(ERR_MSGS$post$ERROR_LOTE,i, endpoint, conditionMessage(item)), call. = FALSE)
    } else {
      has_errors <- TRUE
      warning(paste0(ERR_MSGS$post$ERROR_DESCONOCIDO, i, endpoint, class(item)[1]), call. = FALSE)
    }
  }

  # Combinar resultados
  combined_results <- dplyr::bind_rows(processed_results)
  if (nrow(combined_results) == 0 && length(queries_list) > 0){
    err_text <- sprintf(ERR_MSGS$post$BASE_COMBINE_ERROR, endpoint, length(queries_list), length(query_batches))
    if(!has_errors) {
      err_text <- paste0(err_text, "devolvi\u00f3 una lista vac\u00eda o no se pudieron procesar los resultados, aunque no se reportaron errores directos en los lotes.")
    } else if (nrow(combined_results) == 0 && length(queries_list) > 0 && has_errors) {
      err_text <- paste0(err_text, " no produjo resultados y se encontraron errores en algunos lotes.")
    }
    warning(err_text, call. = FALSE)
  }
  return(combined_results)
}
