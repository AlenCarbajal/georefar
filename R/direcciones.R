#' Normalizacion de direcciones
#'
#' Permite normalizar una dirección utilizando el listado de vías de circulación.
#' Realiza la consulta GET al endpoint /direcciones de georef-ar-api.
#' Si existe GEOREFAR_TOKEN en el Renviron lo usará para hacer la consulta.
#' @param direccion text Requerido. Direccion a normalizar, debe contener altura separada por espacio. (Ej: Colon 127)
#' @param provincia text Filtrar por nombre o ID de provincia.
#' @param departamento text Filtrar por nombre o ID de departamento.
#' @param localidad_censal text Filtrar por nombre o ID de localidad censal.
#' @param localidad text Filtrar por nombre o ID de localidad.
#' @param orden text Campo por el cual ordenar los resultados. (Por ID o nombre)
#' @param aplanar boolean Cuando está presente, muestra el resultado JSON con una estructura plana.
#' @param campos text Campos a incluir en la respuesta separados por comas, sin espacios. Algunos campos siempre serán incluidos, incluso si no se agregaron en la lista. Para incluir campos de sub-entidades, separar los nombres con un punto, por ejemplo: provincia.id.
#' @param max integer Cantidad máxima de resultados a devolver. La API limita a un máximo de 10 para este endpoint.
#' @param inicio integer Cantidad de resultados a omitir desde el principio.
#' @param exacto boolean Cuando está presente, se activa el modo de búsqueda por texto exacto. Sólo tiene efecto cuando se usan campos de búsqueda por texto (por ejemplo, nombre).
#'
#' @export
#' @rdname normalizar_direccion
#'
#' @references [georef-ar-api/direcciones](https://datosgobar.github.io/georef-ar-api/open-api/#/Recursos/get_direcciones)
#' @return Un Data Frame con el listado normalizado de de direcciones
#' @examples
#' \dontrun{
#' normalizar_direccion(direccion = "Corrientes 1200, Rosario")
#' normalizar_direccion(direccion = "SAN MARTIN 100", provincia = "02", max = 5)
#' }

normalizar_direccion <- function(
    direccion, 
    provincia = NULL, 
    departamento = NULL, 
    localidad_censal = NULL, 
    localidad = NULL, 
    orden = NULL,
    aplanar = TRUE,
    campos = NULL, 
    max = NULL, 
    inicio = NULL, 
    exacto = NULL, 
    desplazar = NULL
  ){
  get_endpoint(endpoint = "direcciones", args = as.list(environment()))
}

post_normalizar_direccion <- function(queries_list){
  bulk_post_request(endpoint = "direcciones", queries_list = queries_list)
}