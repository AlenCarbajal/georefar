#' Enviar Lote de Consultas de Departamentos (POST)
#'
#' Permite realizar múltiples búsquedas sobre el listado de departamentos en una sola llamada POST.
#' Realiza la consulta POST al endpoint /departamentos de georef-ar-api.
#'
#' @param queries_list Lista de listas. Cada lista interna debe contener los parámetros
#'        para una consulta de departamento individual (e.g., list(nombre = "Rosario"), list(provincia = "02")).
#'        Parámetros válidos por consulta: id, nombre, provincia, orden, aplanar, campos, max, exacto.
#' @return Un Data Frame (tibble) con los resultados combinados de todas las consultas.
#' @export
#' @rdname post_departamentos_bulk
#'
#' @references [georef-ar-api/departamentos POST](https://datosgobar.github.io/georef-ar-api/open-api/#/Recursos/post_departamentos)
#' @examples
#' \dontrun{
#' consultas_deptos <- list(
#'   list(provincia = "22", nombre = "Ledesma"),
#'   list(id = "14028")
#' )
#' resultados_deptos <- post_departamentos_bulk(queries_list = consultas_deptos)
#' print(resultados_deptos)
#' }

library(httr2)

check_query_list <- function(query_list){
  if (!is.list(queries_list) || !all(sapply(queries_list, is.list))) {
    stop("'queries_list' debe ser una lista de listas.")
  }
  if (length(queries_list) == 0) {
    warning("'queries_list' está vacía, no se realizará ninguna consulta.")
    return(dplyr::tibble())
  }
}




post_departamentos_bulk <- function(queries_list) {
  check_query_list(queries_list)

  valid_params <- c("id", "nombre", "provincia", "interseccion", "orden", "aplanar", "campos", "max", "inicio", "exacto")
  for (i in seq_along(queries_list)) {
    query <- queries_list[[i]]

    invalid_params <- setdiff(names(query), valid_params)

    if (length(invalid_params) > 0) {
      warning(paste0("Consulta ", i, " en 'queries_list' para 'departamentos' contiene par\u00e1metro(s) no reconocido(s): ",
                     paste(invalid_params, collapse = ", "), ". ",
                     "Par\u00e1metros v\u00e1lidos son: ", paste(valid_params, collapse = ", "), "."))
    }
  }
  endpoint <- "departamentos"
  check_internet()
  query_batches <- create_query_batches(queries_list, param_name_for_sum = "max")


  if (length(query_batches) == 0)
    if(length(queries_list) > 0) {
      warning(paste0("No se pudieron crear lotes de consultas para '", endpoint, "', aunque la lista de consultas no estaba vac\u00eda."), call. = FALSE)
    }
    return(dplyr::tibble())
  }
  all_batch_requests <- list()
  for (batch_idx in seq_along(query_batches)) {
    current_batch <- query_batches[[batch_idx]]
    request_obj <- prepare_post_batch_request(endpoint = endpoint, single_batch_queries_list = current_batch)
    all_batch_requests <- append(all_batch_requests, list(request_obj))
  }
  responses_or_errors <- req_perform_parallel(all_batch_requests, on_error = "return")
  final_results_list_of_tibbles <- list()
  has_errors <- FALSE
  for (i in seq_along(responses_or_errors)) {
    item <- responses_or_errors[[i]]
    num_queries_in_this_batch <- length(query_batches[[i]])
    if (inherits(item, "httr2_response")) {
      processed_tibble <- process_single_post_response(response_obj = item, endpoint = endpoint, num_queries_in_this_batch = num_queries_in_this_batch)
      final_results_list_of_tibbles <- append(final_results_list_of_tibbles, list(processed_tibble))
    } else if (inherits(item, "error")) {
      has_errors <- TRUE
      warning(paste0("Error en el lote ", i, " para '", endpoint, "': ", conditionMessage(item)), call. = FALSE)
    } else {
      has_errors <- TRUE
      warning(paste0("Error desconocido o respuesta inesperada en el lote ", i, " para '", endpoint, "'. Clase del objeto: ", class(item)[1]), call. = FALSE)
    }
  }
  combined_results <- dplyr::bind_rows(final_results_list_of_tibbles)
  if (nrow(combined_results) == 0 && length(queries_list) > 0 && !has_errors) {
    warning(paste0("La consulta POST completa para '", endpoint, "' (", length(queries_list)," consultas originales en ", length(query_batches)," lotes) devolvi\u00f3 una lista vac\u00eda o no se pudieron procesar los resultados, aunque no se reportaron errores directos en los lotes."), call. = FALSE)
  } else if (nrow(combined_results) == 0 && length(queries_list) > 0 && has_errors) {
    warning(paste0("La consulta POST completa para '", endpoint, "' (", length(queries_list)," consultas originales en ", length(query_batches)," lotes) no produjo resultados y se encontraron errores en algunos lotes."), call. = FALSE)
  }
  return(combined_results)
}
