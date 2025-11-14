check_internet <- function(){
  attempt::stop_if_not(.x = curl::has_internet(),
                        msg = "No se detectó acceso a internet. Por favor chequea tu conexión.")
}
