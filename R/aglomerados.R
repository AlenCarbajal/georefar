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

post_aglomerados <- function(queries_list){
  post_endpoint(endpoint = "aglomerados", queries_list = queries_list)
}