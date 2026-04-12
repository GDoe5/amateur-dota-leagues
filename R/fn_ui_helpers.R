preference_input <- function(
  label,
  ns_id,
  input_id
) {
  shiny::fluidRow(
    column(
      width = 5,
      label
    ),
    column(
      width = 7,
      shinyWidgets::radioGroupButtons(
        NS(ns_id, input_id),
        choiceNames = c("", "", "", "", ""),
        choiceValues = c(
          "Strongly prefer (+++)",
          "Prefer (++)",
          "I don't mind (+)",
          "Not prefer (--)",
          "Strongly not prefer (---)"
        ),
        checkIcon = list(
          yes = icon("square-check"),
          no = icon("square")
        ),
        justified = TRUE
      )
    )
  )
}

switch_tab <- function(tab_name) {
  shinyjs::runjs(paste0('$("[data-value=\'', tab_name, '\']").tab("show")'))
}
