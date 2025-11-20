get_establecimientos_educativos <- function(
    id = NULL,
    nombre = NULL,
    provincia = NULL,
    departamento = NULL,
    gestion = NULL,
    orden = NULL,
    campos = NULL,
    max = NULL,
    inicio = NULL,
    exacto = NULL,
    aplanar = TRUE
  ){
    get_endpoint(endpoint = "establecimientos-educativos", args = as.list(environment()))
}

post_establecimientos_educativos <- function(queries_list){
  post_endpoint(endpoint = "establecimientos-educativos", queries_list = queries_list)
}