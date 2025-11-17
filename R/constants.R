# API Limits for batch POST requests
GEOREFAR_API_MAX_QUERIES_PER_BATCH <- 1000
GEOREFAR_API_MAX_SUM_MAX_PARAM_PER_BATCH <- 5000
LIMIT_MAX <- 5000
LIMIT_MAX_INICIO <- 10000

# Base URL de la API de georef-ar
base_url <- "https://apis.datos.gob.ar/georef/api/"

#' Mensajes de error
ERR_MSGS <- list(
  endpoints = list(
    calles = list(),
    departamentos = list(),
    localidades = list(),
    provincias = list()
    ),
    helpers = list(),
    get_endpoint = list(
      GET_NA        = "GET no admite NAs. Los parámetros siguientes tienen NAs:%s",
      EMPTY_QUERY   = "La consulta devolvió una lista vacía",
      BAD_STATUS    = "El servidor respondió con estado %d"
    )
    ),
    post = list(
    bulk_post_request = list(
      INVALID_PARAM  = "Consulta %d en 'queries_list' para '%s' contiene parámetro(s) no reconocido(s): %s. Parámetros válidos son: %s.",
      MAX_PARAM      = "En la consulta %d, el parámetro 'max' debe ser un número entre 0 y %d.",
      INICIO_PARAM   = "En la consulta %d, el parámetro 'inicio' debe ser un número positivo.",
      MAX_INICIO_SUM= "En la consulta %d, la suma de 'max' e 'inicio' no debe superar %d."
    )
    )
  )

  PARAMS <- list(
    departamentos = c("id", "nombre", "provincia", "interseccion", "orden", "aplanar", "campos", "max", "inicio", "exacto"),
    localidades = c("id", "nombre", "provincia", "departamento", "interseccion", "orden", "aplanar", "campos", "max", "inicio", "exacto"),
    provincias = c("id", "nombre", "interseccion", "orden", "aplanar", "campos", "max", "inicio", "exacto"),
    calles = c("id", "nombre", "localidad", "provincia", "interseccion", "orden", "aplanar", "campos", "max", "inicio", "exacto"),
)

# Listas de valores válidos para descarga_completa
valid_entidades <- c("provincias", "departamentos", "municipios",
                       "localidades", "localidades-censales", "asentamientos",
                       "calles", "cuadras")
valid_formatos <- c("csv", "json", "geojson", "ndjson")

#' Devuelve un mensaje formateado
#' @param key  clave dentro de err_msgs
#' @param ...  valores para sprintf
err_msg <- function(modulo, categoria, key, ...) {
  if (!exists(categoria, ERR_MSGS))
    stop("Categoría inexistente (key error): ", categoria)
  mod_err_msgs <- ERR_MSGS[[modulo]]
  cat_err_msgs <- mod_err_msgs[[categoria]]
  
  if (!exists(key, cat_err_msgs))
    stop("Mensaje inexistente (key error): ", key)
  do.call(sprintf, c(list(cat_err_msgs[[key]]), ...))
}
