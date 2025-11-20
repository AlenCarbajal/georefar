#' Descargar Datos Geográficos Completos
#'
#' Permite descargar listados completos de entidades geográficas en diversos formatos.
#' Accede al endpoint /{filename} de la georef-ar-api.
#' Si existe GEOREFAR_TOKEN en el Renviron lo usará para hacer la consulta (aunque generalmente no es necesario para estos endpoints públicos).
#'
#' @param entidad Cadena de texto. La entidad geográfica a descargar.
#'        Valores posibles: "provincias", "departamentos", "municipios",
#'        "localidades", "localidades-censales", "asentamientos", "calles", "cuadras".
#' @param formato Cadena de texto. El formato deseado para el archivo.
#'        Valores posibles: "csv", "json", "geojson", "ndjson".
#' @param path_to_save Cadena de texto opcional. Ruta completa (incluyendo nombre de archivo y extensión)
#'        donde guardar el archivo descargado. Si es NULL (por defecto), la función devolverá el contenido
#'        parseado (para json/geojson/ndjson) o un data frame (para csv).
#'        Si se especifica una ruta, la función guardará el archivo y devolverá la ruta del archivo guardado.
#' @return Dependiendo de 'path_to_save' y 'formato':
#'         - Si 'path_to_save' se especifica: la ruta al archivo guardado (invisiblemente).
#'         - Si 'path_to_save' es NULL:
#'           - Para "csv": un data.frame.
#'           - Para "json", "geojson", "ndjson": una lista o estructura de R parseada desde JSON.
#'           - Si la descarga o parseo falla, genera un error.
#' @export
#' @rdname get_geodata_dump
#'
#' @references [georef-ar-api/descargas](https://datosgobar.github.io/georef-ar-api/open-api/#/Recursos/get__filename_)
#' @examples
#' \dontrun{
#'   # Obtener provincias en formato GeoJSON como objeto R
#'   provincias_geojson <- get_geodata_dump(entidad = "provincias", formato = "geojson")
#'
#'   # Guardar departamentos en formato CSV
#'   get_geodata_dump(entidad = "departamentos", formato = "csv", path_to_save = "deptos.csv")
#' }

library(httr2)

get_geodata_dump <- function(entidad, formato, path_to_save = NULL) {

  check_internet()

  if (!entidad %in% valid_entidades) {
    stop(paste("Entidad no v\u00e1lida. Opciones disponibles:", paste(valid_entidades, collapse = ", ")))
  }
  if (!formato %in% valid_formatos) {
    stop(paste("Formato no v\u00e1lido. Opciones disponibles:", paste(valid_formatos, collapse = ", ")))
  }

  filename <- paste0(entidad, ".", formato)
  url <- paste0(base_url, filename)

  token <- Sys.getenv("GEOREFAR_TOKEN")

  req <- request(url) |>
    req_error(is_error = ~ resp_status(.x) != 200, body = httr2_error_handler)

  if (!is.null(token) && token != "") {
    req <- req |> req_auth_bearer_token(token)
  }

  response <- req_perform(req)

  if (!is.null(path_to_save)) {
    assertthat::assert_that(is.character(path_to_save), length(path_to_save) == 1,
                            msg = "'path_to_save' debe ser una cad\u00e1na de texto con la ruta del archivo.")
    tryCatch({
      writeBin(resp_body_raw(response), path_to_save)
      message(paste("Archivo guardado en:", path_to_save))
      return(invisible(path_to_save))
    }, error = function(e) {
      stop(paste("Error al guardar el archivo:", e$message))
    })
  } else {
    # Si no se guarda, intentar parsear según el formato
    content_text <- resp_body_string(response, encoding = "UTF-8")
    if (formato == "csv") {
      return(utils::read.csv(text = content_text, stringsAsFactors = FALSE))
    } else if (formato %in% VALID$FORMATS) {
      return(jsonlite::fromJSON(content_text, flatten = TRUE))
    } else {
      warning("Formato no soportado para parseo directo, devolviendo contenido como texto.", call. = FALSE)
      return(content_text)
    }
  }
}
