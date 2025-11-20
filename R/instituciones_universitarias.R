get_instituciones_universitarias <- function(
    id = NULL,
    nombre = NULL,
    provincia = NULL,
    departamento = NULL,
    orden = NULL,
    campos = NULL,
    max = NULL,
    inicio = NULL,
    exacto = NULL,
    aplanar = TRUE,
    gestion = NULL,
    universidad = NULL
  ){
    get_endpoint(endpoint = "instituciones-universitarias", args = as.list(environment()))
}

post_instituciones_universitarias <- function(queries_list){
  post_endpoint(endpoint = "instituciones-universitarias", queries_list = queries_list)
}