main_ui <- function() {
  library(bs4Dash)
  library(shiny)
  dashboardPage(
    title = "Tournament",
    fullscreen = TRUE,
    header = dashboardHeader(
      title = dashboardBrand(title = "Tournament", color = "primary"),
      rightUI = shiny::uiOutput("header_user")
    ),
    sidebar = dashboardSidebar(
      skin = "light",
      bs4SidebarMenu(
        id = "tabs",
        bs4SidebarMenuItem(
          "Log-in/ Register",
          tabName = "auth",
          icon = icon("address-card")
        ),
        bs4SidebarMenuItem(
          "Player sign-up",
          tabName = "player_sign_up",
          icon = icon("address-card")
        ),
        bs4SidebarMenuItem(
          "Upload replays",
          tabName = "replay_upload",
          icon = icon("upload")
        )
      )
    ),
    body = dashboardBody(
      tags$head(
        tags$link(
          rel = "stylesheet",
          type = "text/css",
          href = "www/custom.css"
        ),
        tags$script(src = "www/custom.js")
      ),
      tabItems(
        tabItem(
          tabName = "auth",
          auth_ui("auth")
        ),
        tabItem(
          tabName = "player_sign_up",
          player_signup_ui("player_signup")
        ),
        tabItem(
          tabName = "replay_upload",
          replay_upload_ui("replay_upload")
        )
      )
    )
  )
}
