#'@export
get_fracciones_censales <- function(
    id = NULL,
    provincia = NULL,
    departamento = NULL,
    orden = NULL,
    max = NULL,
    inicio = NULL,
    exacto = NULL,
    aplanar = TRUE,
    campos = NULL
  ){
    get_endpoint(endpoint = "fracciones-censales", args = as.list(environment()))
}

#'@export
post_fracciones_censales <- function(queries_list){
  bulk_post_request(endpoint = "fracciones-censales", queries_list = queries_list)
}