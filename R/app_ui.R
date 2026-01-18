main_ui <- function() {
  library(bs4Dash)
  library(shiny)
  dashboardPage(
    title = "Tournament",
    fullscreen = TRUE,
    header = dashboardHeader(
      title = dashboardBrand(title = "Tournament", color = "primary")
    ),
    sidebar = dashboardSidebar(
      skin = "light",
      bs4SidebarMenu(bs4SidebarMenuItem(
        "Player sign-up",
        tabName = "player_sign_up",
        icon = icon("address-card")
      ))
    ),
    body = dashboardBody(
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
        tags$script(src = "custom.js")
      ),
      tabItems(
        tabItem(
          tabName = "player_sign_up",
          player_signup_ui("player_signup")
        )
      )
    )
  )
}
