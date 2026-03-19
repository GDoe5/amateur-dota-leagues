main_server <- function(input, output, session) {
  rv <- reactiveValues()
  options(shiny.maxRequestSize = 200 * 1024^2)

  player_signup_server("player_signup", sv = sv, rv = rv)
  replay_upload_server("replay_upload", sv = sv, rv = rv)
}
