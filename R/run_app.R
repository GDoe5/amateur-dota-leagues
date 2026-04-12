runApp <- function() {
  shiny::addResourcePath(
    "www",
    system.file("www", package = "amateur-dota-leagues")
  )
  shiny::shinyApp(ui = main_ui, server = main_server)
}
