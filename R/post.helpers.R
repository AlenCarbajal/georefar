ERR_MSGS <- ERR_MSGS$helpers


check_list_of_lists <- function(queries_list){
    if (!is.list(queries_list) || !all(sapply(queries_list, is.list))) {
        stop(ERR_MSGS$NOT_LIST_OF_LISTS)
    }
    if (length(queries_list) == 0) {
        warning(ERR_MSGS$EMPTY_QUERY_LIST, call. = FALSE)
        return(dplyr::tibble())
    }
}

check_params <- function(endpoint, params, query){
    valid_params <- params[[endpoint]]
    invalid_params <- setdiff(names(query), valid_params)

    if (length(invalid_params) > 0) {
        warning(
        sprintf(ERR_MSGS$post$BULK_POST_REQUESTS$INVALID_PARAMS,
                paste(invalid_params, collapse = ", "), ". ",
                "Parámetros válidos: ", paste(valid_params, collapse = ", "), "."))
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