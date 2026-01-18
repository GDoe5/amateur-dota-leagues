player_signup_ui <- function(id) {
  shiny::tagList(
    shinyjs::useShinyjs(),
    bs4Dash::box(
      title = "Player sign-up",
      width = 12,
      solidHeader = TRUE,
      collapsible = FALSE,
      fluidRow(
        column(
          width = 3,
          textInput(
            NS(id, "player_nickname"),
            label = "Nickname",
            value = NA_character_
          ),
          textInput(
            NS(id, "player_discord"),
            label = "Discord username",
            value = NA_character_
          ),
          checkboxInput(
            NS(id, "player_standin"),
            label = "Available as a stand-in?",
            value = FALSE
          )
        ),
        column(
          width = 3,
          textInput(
            NS(id, "player_id"),
            label = "Dota player ID",
            value = NA_character_
          ),
          selectizeInput(
            NS(id, "player_rank"),
            label = "Rank",
            choices = c("1", "2", "3"),
            selected = NA_character_,
            multiple = FALSE
          )
        ),
        column(
          width = 6,
          fluidRow(
            column(width = 5, strong("Farming priority preferences")),
            column(
              width = 3,
              div("Strongly prefer"),
              style = "text-align: left;"
            ),
            column(
              width = 4,
              div("Strongly not prefer", style = "text-align: right;")
            )
          ),
          preference_input("Position 1 (Carry)", id, "pos_1_preference"),
          preference_input("Position 2 (Mid)", id, "pos_2_preference"),
          preference_input("Position 3 (Offlane)", id, "pos_3_preference"),
          preference_input("Position 4 (Soft Support)", id, "pos_4_preference"),
          preference_input("Position 5 (Hard Support)", id, "pos_5_preference")
        )
      )
    )
  )
}

player_signup_server <- function(id) {}
