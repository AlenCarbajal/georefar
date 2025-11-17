library(httr2)

check_list_of_lists <- function(query_list){
  if (!is.list(queries_list) || !all(sapply(queries_list, is.list))) {
    stop("'queries_list' debe ser una lista de listas.")
  }
  if (length(queries_list) == 0) {
    warning("'queries_list' está vacía, no se realizarán consultas.")
    return(dplyr::tibble())
  }
}

check_params <- function(endpoint, params, query){
  valid_params <- params[[endpoint]]
  invalid_params <- setdiff(names(query), valid_params)
    
  if (length(invalid_params) > 0) {
    warning(
      paste0("Consulta ", i, " en 'queries_list' para 'departamentos' contiene par\u00e1metro(s) no reconocido(s): ",
                    paste(invalid_params, collapse = ", "), ". ",
                    "Par\u00e1metros v\u00e1lidos son: ", paste(valid_params, collapse = ", "), "."))
  }
}

check_max <- function(query) {
  current_max <- query$max
  current_inicio <- query$inicio
  
  if (!is.null(current_max) && (!is.integer(current_max) || current_max < 0 || current_max > LIMIT_MAX)) {
    stop(paste0("En la consulta ", i, ", el par\u00e1metro 'max' debe ser un n\u00famero entre 0 y ", LIMIT_MAX, "."))
  }
  if (!is.null(current_inicio) && (!is.integer(current_inicio) || current_inicio < 0)) {
    stop(paste0("En la consulta ", i, ", el par\u00e1metro 'inicio' debe ser un n\u00famero positivo."))
  }
  if (!is.null(current_max) && !is.null(current_inicio) && (current_max + current_inicio > LIMIT_MAX_INICIO)) {
    stop(paste0("En la consulta ", i, ", la suma de 'max' e 'inicio' no debe superar ", LIMIT_MAX_INICIO, "."))
  }
}

bulk_post_request <- function(endpoint, queries_list, check_max = FALSE) {
  # Check de que es una lista de listas
  check_list_of_lists(queries_list)

  # Check parametros en cada consulta
  queries_list.
  for (query in queries_list){
    check_params(endpoint, query)
    if (check_max){ check_max(query) }
  }

  # Crear lotes
  query_batches <- create_query_batches(queries_list, param_name_for_sum = "max")

  # Check se crearon lotes
  if (length(query_batches) == 0){
    if(length(queries_list) > 0) {
      warning(paste0("No se pudieron crear lotes de consultas para '", endpoint, "', aunque la lista de consultas no estaba vac\u00eda."), call. = FALSE)
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
      warning(paste0("Error en el lote ", i, " para '", endpoint, "': ", conditionMessage(item)), call. = FALSE)
    } else {
      has_errors <- TRUE
      warning(paste0("Error desconocido o respuesta inesperada en el lote ", i, " para '", endpoint, "'. Clase del objeto: ", class(item)[1]), call. = FALSE)
    }
  }

  # Combinar resultados
  combined_results <- dplyr::bind_rows(processed_results)
  if (nrow(combined_results) == 0 && length(queries_list) > 0 && !has_errors) {
    warning(paste0("La consulta POST completa para '", endpoint, "' (", length(queries_list)," consultas originales en ", length(query_batches)," lotes) devolvi\u00f3 una lista vac\u00eda o no se pudieron procesar los resultados, aunque no se reportaron errores directos en los lotes."), call. = FALSE)
  } else if (nrow(combined_results) == 0 && length(queries_list) > 0 && has_errors) {
    warning(paste0("La consulta POST completa para '", endpoint, "' (", length(queries_list)," consultas originales en ", length(query_batches)," lotes) no produjo resultados y se encontraron errores en algunos lotes."), call. = FALSE)
  }
  return(combined_results)
}
