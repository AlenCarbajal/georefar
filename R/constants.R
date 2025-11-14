# API Limits for batch POST requests
GEOREFAR_API_MAX_QUERIES_PER_BATCH <- 1000
GEOREFAR_API_MAX_SUM_MAX_PARAM_PER_BATCH <- 5000

base_url <- "https://apis.datos.gob.ar/georef/api/"

#' Mensajes de error
err_msgs <- list(
  GET_NA        = "GET no admite NAs. Los parámetros siguientes tienen NAs:%s",
  EMPTY_QUERY   = "La consulta devolvió una lista vacía",
  BAD_STATUS    = "El servidor respondió con estado %d"
)

#' Devuelve un mensaje formateado
#' @param key  clave dentro de err_msgs
#' @param ...  valores para sprintf


msg <- function(key, ...) {
  if (!exists(key, err_msgs))
    stop("Mensaje inexistente (key error): ", key)
  do.call(sprintf, c(list(err_msgs[[key]]), ...))
}
