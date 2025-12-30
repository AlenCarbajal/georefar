#' Obtener aglomerados
get_aglomerados <- function(
    id = NULL,
    nombre = NULL,
    interseccion = NULL,
    orden = NULL,
    aplanar = TRUE,
    campos = NULL,
    max = NULL,
    inicio = NULL,
    exacto = NULL
  ){
    get_endpoint(endpoint = "aglomerados", args = as.list(environment()))
}

#' Obtener aglomerados en batch
#' @return devuelve un tibble con los resultados para cada query o
#' @export
post_aglomerados <- function(queries_list){
  bulk_post_request(endpoint = "aglomerados", queries_list = queries_list)
}
