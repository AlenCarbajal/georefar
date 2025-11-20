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
  helpers = list(
    NOT_LIST_OF_LISTS = "'queries_list' debe ser una lista de listas.",
    EMPTY_QUERY_LIST = "'queries_list' está vacía, no se realizarán consultas."
  ),
  
  
  # Mensajes de error para get_endpoint
  get_endpoint = list(
    NA_PARAMS         = "GET no admite NAs. Los parámetros siguientes tienen NAs:%s",
    EMPTY_QUERY       = "La consulta devolvió una lista vacía",
    BAD_STATUS        = "El servidor respondió con estado %d",
    INVALID_PARAMS    = "Parámetro(s) no reconocido(s) para el endpoint '%s': %s.",
    EMPTY_RESPOSE     = "La consulta devolvió una lista vacía"
  ),

  # Mensajes de error para POST por lotes
  post = list(
    BULK_POST_REQUESTS = list(
      NO_BATCHES_CREATED    = "No se pudieron crear lotes de consultas para '%s', aunque la lista de consultas no estaba vacía.",
      INVALID_PARAMS        = "Consulta %d en 'queries_list' para %s contiene parámetro(s) no reconocido(s): ",
      MAX_PARAM             = "En la consulta %d, el parámetro 'max' debe ser un número entre 0 y %d.",
      INICIO_PARAM          = "En la consulta %d, el parámetro 'inicio' debe ser un número positivo.",
      MAX_INICIO_SUM        = "En la consulta %d, la suma de 'max' e 'inicio' no debe superar %d.",
      BASE_COMBINE_ERROR    = "La consulta POST completa para '%s' (%d consultas originales en %d lotes)",
      ERROR_LOTE            = "Error en el lote %d para '%s': %s",
      ERROR_DESCONOCIDO     = "Error desconocido o respuesta inesperada en el lote %d para '%s'. Clase del objeto: %s"
    )
  )
)

# Parámetros válidos por endpoint
BASE_VALID_PARAMS <- c('campos','aplanar','max','inicio','exacto','formato','orden')
UT_BASE_VALID_PARAMS <- BASE_VALID_PARAMS %+% c('id','nombre')

VALID <- list(
  PARAMS = list(
    aglomerados                   = UT_BASE_VALID_PARAMS,

    provincias                    = UT_BASE_VALID_PARAMS  %+% c('interseccion'),
    departamentos                 = UT_BASE_VALID_PARAMS  %+% c('provincia','interseccion'),
    municipios                    = UT_BASE_VALID_PARAMS  %+% c('provincia','interseccion'),
    gobiernos_locales             = UT_BASE_VALID_PARAMS  %+% c('provincia','interseccion','categoria'),
    
    asentamientos                 = UT_BASE_VALID_PARAMS  %+% c('provincia','departamento','municipio','localidad_censal','categoria'),
    localidades                   = UT_BASE_VALID_PARAMS  %+% c('provincia','departamento','municipio','localidad_censal'),
    calles                        = UT_BASE_VALID_PARAMS  %+% c('provincia','departamento','localidad_censal','categoria'),

    localidades_censales          = UT_BASE_VALID_PARAMS  %+% c('provincia','departamento','municipio'),
    fracciones_censales           = BASE_VALID_PARAMS     %+% c('id','provincia','departamento'),
    radios_censales               = BASE_VALID_PARAMS     %+% c('id','provincia','departamento','fraccion_censal'),
    
    direcciones                   = BASE_VALID_PARAMS     %+% c('provincia','departamento','localidad_censal','direccion','localidad','desplazar'),
    ubicacion                     = c('campos','aplanar','formato','lat','lon','division'),

    establecimientos_educativos   = UT_BASE_VALID_PARAMS  %+% c('provincia','departamento','gestion'),
    instituciones_universitarias  = UT_BASE_VALID_PARAMS  %+% c('provincia','departamento','gestion','universidad')
  ),
  ENTITIES = 
    c(
      'aglomerados',
      'provincias',
      'departamentos',
      'municipios',
      'gobiernos_locales',
      'asentamientos',
      'localidades',
      'localidades_censales',
      'fracciones_censales',
      'radios_censales',
      'calles',
      'direcciones',
      'ubicacion',
      'establecimientos_educativos',
      'instituciones_universitarias'
    ),
  FORMATS = c("csv", "json", "geojson", "ndjson") # TODO: verificar
)
