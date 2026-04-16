main_server <- function(input, output, session) {
  os <- .Platform$OS.type

  sv <- shiny::reactiveValues(
    user_id = NA_character_,
    username = NULL,
    is_admin = FALSE,
    is_signed_in = FALSE,
    new_registration = NULL
  )
  rv <- shiny::reactiveValues()
  pool <- db_connect(os)
  shiny::onStop(function() {
    pool::poolClose(pool)
  })

  auth_server("auth", sv = sv, rv = rv, pool = pool)
  player_signup_server("player_signup", sv = sv, rv = rv, pool = pool)
  replay_upload_server("replay_upload", sv = sv, rv = rv, pool = pool)

  observe({
    sv$user_id <- NA_character_
    sv$username <- NULL
    sv$is_admin <- FALSE
    sv$is_signed_in <- FALSE
    sv$new_registration <- NULL
  }) |>
    bindEvent(input$sign_out)

  observe({
    switch_tab("auth")
  }) |>
    bindEvent(input$goto_auth)

  output$header_user <- shiny::renderUI({
    if (sv$is_signed_in) {
      shiny::tags$span(
        paste0("Signed in as ", sv$username),
        shiny::actionButton(
          "sign_out",
          label = "Sign out",
          class = "btn-sm",
          style = "margin-left: 6px;"
        )
      )
    } else {
      shiny::tags$span(
        "Not signed in",
        shiny::actionButton(
          "goto_auth",
          label = "Sign in",
          class = "btn-sm",
          style = "margin-left: 6px;"
        )
      )
    }
  }) |>
    bindEvent(sv$is_signed_in)
}
