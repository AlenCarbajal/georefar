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
    formato = NULL,
    aplanar = TRUE
  ){
    get_endpoint(endpoint = "gobiernos-locales", args = as.list(environment()))
}

post_gobiernos_locales <- function(queries_list){
  post_endpoint(endpoint = "gobiernos-locales", queries_list = queries_list)
}