#' Obtener Ubicacion
#'
#' Permite realizar una georreferenciación inversa para un punto, informando cuales unidades territoriales lo contienen.
#' Realiza la consulta GET al endpoint /ubicacion de georef-ar-api.
#' Si existe GEOREFAR_TOKEN en el Renviron lo usará para hacer la consulta.
#' @param lat numeric Latitud del punto, en forma de número real con grados decimales.
#' @param lon numeric Longitud del punto, en forma de número real con grados decimales.
#' @param aplanar boolean Cuando está presente, muestra el resultado JSON con una estructura plana.
#' @param campos text Campos a incluir en la respuesta separados por comas, sin espacios. Algunos campos siempre serán incluidos, incluso si no se agregaron en la lista. Para incluir campos de sub-entidades, separar los nombres con un punto, por ejemplo: provincia.id.
#'
#' @export
#' @rdname get_ubicacion
#'
#' @references [georef-ar-api/ubicacion](https://datosgobar.github.io/georef-ar-api/open-api/#/Recursos/get_ubicacion)
#' @return Un Data Frame con las unidades territoriales que contienen el punto.
#' @examples
#' \dontrun{
#' get_ubicacion()
#' }
get_ubicacion <- function(lat, lon, aplanar = TRUE, campos = NULL, formato = NULL){
  get_endpoint(endpoint = "ubicacion", args = as.list(environment()))
}

#'@export
port_ubicacion <- function(queries_list){
  bulk_post_request(endpoint = "ubicacion", queries_list = queries_list)
}
