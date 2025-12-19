#' Obtener Localidades Censales
#'
#' Permite realizar búsquedas sobre el listado de localidades censales.
#' Realiza la consulta GET al endpoint /localidades-censales de georef-ar-api.
#' Si existe GEOREFAR_TOKEN en el Renviron lo usará para hacer la consulta.
#' @param id text Filtrar por ID.
#' @param nombre text Filtrar por Nombre.
#' @param provincia text Filtrar por nombre o ID de Provincia.
#' @param departamento text Filtrar por nombre o ID de Departamento.
#' @param municipio text Filtrar por nombre o ID de Municipio.
#' @param interseccion text Geometría GeoJSON utilizada para filtrar resultados por intersección espacial. Sólo se soportan polígonos y multipolígonos. Ejemplo: polygon((-58.431,-34.592),(-58.430,-34.590),(-58.428,-34.593),(-58.431,-34.592)).
#' @param orden text Campo por el cual ordenar los resultados (por ID o nombre)
#' @param aplanar boolean Cuando está presente, muestra el resultado JSON con una estructura plana.
#' @param campos text Campos a incluir en la respuesta separados por comas, sin espacios. Algunos campos siempre serán incluidos, incluso si no se agregaron en la lista. Para incluir campos de sub-entidades, separar los nombres con un punto, por ejemplo: provincia.id.
#' @param max integer Cantidad máxima de resultados a devolver. La API limita a un máximo de 5000 para este endpoint.
#' @param inicio integer Cantidad de resultados a omitir desde el principio.
#' @param exacto boolean Cuando está presente, se activa el modo de búsqueda por texto exacto. Sólo tiene efecto cuando se usan campos de búsqueda por texto (por ejemplo, nombre).
#'
#' @export
#' @rdname get_localidades_censales
#'
#' @references [georef-ar-api/localidades-censales](https://datosgobar.github.io/georef-ar-api/open-api/#/Recursos/get_localidades_censales)
#' @return Un Data Frame con el listado de Localidades Censales.
#' @examples
#' \dontrun{
#' get_localidades_censales(nombre = "VILLA GENERAL BELGRANO")
#' }
get_localidades_censales <- function(id = NULL, nombre = NULL, provincia = NULL, departamento = NULL, municipio = NULL, interseccion = NULL, orden = NULL, aplanar = TRUE, campos = NULL, max = NULL, inicio = NULL, exacto = NULL){
  get_endpoint(endpoint = "localidades-censales", args = as.list(environment()))
}

#'@export
post_localidades_censales <- function(queries_list){
  bulk_post_request(endpoint = "localidades-censales", queries_list = queries_list)
}