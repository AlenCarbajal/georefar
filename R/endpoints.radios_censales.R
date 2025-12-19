#'@export
get_radios_censales <- function(
    id = NULL,
    provincia = NULL,
    departamento = NULL,
    orden = NULL,
    max = NULL,
    inicio = NULL,
    exacto = NULL,
    aplanar = TRUE,
    campos = NULL,
    fraccion_censal = NULL
  ){
    get_endpoint(endpoint = "radios-censales", args = as.list(environment()))
}

post_radios_censales <- function(queries_list){
  bulk_post_request(endpoint = "radios-censales", queries_list = queries_list)
}