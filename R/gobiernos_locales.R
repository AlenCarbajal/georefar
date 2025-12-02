#'@export
get_gobiernos_locales <- function(
    id = NULL,
    nombre = NULL,
    provincia = NULL,
    interseccion = NULL,
    categoria = NULL,
    orden = NULL,
    campos = NULL,
    max = NULL,
    inicio = NULL,
    exacto = NULL,
    aplanar = TRUE
  ){
    get_endpoint(endpoint = "gobiernos-locales", args = as.list(environment()))
}

#'@export
post_gobiernos_locales <- function(queries_list){
  bulk_post_request(endpoint = "gobiernos-locales", queries_list = queries_list)
}