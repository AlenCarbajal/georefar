# API Limits for batch POST requests
GEOREFAR_API_MAX_QUERIES_PER_BATCH <- 1000
GEOREFAR_API_MAX_SUM_MAX_PARAM_PER_BATCH <- 5000
LIMIT_MAX <- 5000
LIMIT_MAX_INICIO <- 10000

# Base URL de la API de georef-ar
base_url <- "https://apis.datos.gob.ar/georef/api/"

#' Mensajes de error
ERR_MSGS <- list(
  
  # Mensajes de error para get_endpoint
  helpers = list(),
  
  
  # Mensajes de error para get_endpoint
  get_endpoint = list(
    NA_PARAMS        = "GET no admite NAs. Los parámetros siguientes tienen NAs:%s",
    EMPTY_QUERY   = "La consulta devolvió una lista vacía",
    BAD_STATUS    = "El servidor respondió con estado %d",
    INVALID_PARAMS = "Parámetro(s) no reconocido(s) para el endpoint '%s': %s."
  ),

  # Mensajes de error para POST por lotes
  post = list(
    BULK_POST_REQUESTS = list(
      NO_BATCHES_CREATED = "No se pudieron crear lotes de consultas para '%s', aunque la lista de consultas no estaba vacía.",
      INVALID_PARAMS     = "Consulta %d en 'queries_list' para %s contiene parámetro(s) no reconocido(s): ",
      MAX_PARAM          = "En la consulta %d, el parámetro 'max' debe ser un número entre 0 y %d.",
      INICIO_PARAM       = "En la consulta %d, el parámetro 'inicio' debe ser un número positivo.",
      MAX_INICIO_SUM     = "En la consulta %d, la suma de 'max' e 'inicio' no debe superar %d."
    )
  )
)

# Parámetros válidos por endpoint
  BASE_VALID_PARAMS <- c('campos','aplanar','max','inicio','exacto','formato','orden')
  UT_BASE_VALID_PARAMS <- BASE_VALID_PARAMS %+% c('id','nombre', 'interseccion')

  VALID <- list(
    PARAMS = list(
      provincias = UT_BASE_VALID_PARAMS,
      municipios = UT_BASE_VALID_PARAMS %+% c('provincia'),
      departamentos = UT_BASE_VALID_PARAMS %+% c('provincia'),
      localidades_censales = UT_BASE_VALID_PARAMS %+% c('provincia','departamento','municipio'),
      asentamientos = UT_BASE_VALID_PARAMS %+% c('provincia','departamento','municipio','localidad_censal'),
      localidades = UT_BASE_VALID_PARAMS %+% c('provincia','departamento','municipio','localidad_censal'),
      calles = BASE_VALID_PARAMS %+% c('provincia','departamento','localidad_censal','categoria'),
      direcciones = BASE_VALID_PARAMS %+% c('provincia','departamento','localidad_censal','direccion','localidad'),
      ubicacion = c('campos','aplanar','formato','lat','lon')
    ),
    ENTITIES = 
      c(
        "provincias",
        "departamentos",
        "municipios",
        "localidades",
        "localidades-censales",
        "asentamientos",
        "calles",
        "direcciones",
        "ubicacion"
      ),
    FORMATS = c("csv", "json", "geojson", "ndjson") # TODO: verificar
  )

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
