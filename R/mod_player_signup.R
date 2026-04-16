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
            choices = ranks,
            multiple = FALSE,
            selected = "",
            options = list(
              placeholder = "Select rank..."
            )
          ),
          textInput(
            NS(id, "player_mmr"),
            label = "MMR",
            value = NULL,
          ) |>
            shinyjs::disabled()
        ),
        column(
          width = 6,
          fluidRow(
            column(width = 5, strong("Role preferences")),
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
      ),
      fluidRow(
        column(
          width = 12,
          actionButton(
            NS(id, "save"),
            label = "Save"
          ) |>
            shinyjs::disabled(),
          textOutput(NS(id, "save_message"))
        )
      )
    )
  )
}

player_signup_server <- function(id, sv, rv, pool) {
  shiny::moduleServer(id, function(input, output, session) {
    observe({
      if (input$player_rank == "Immortal") {
        shinyjs::enable("player_mmr")
      } else {
        shinyjs::disable("player_mmr")
        updateTextInput(
          inputId = "player_mmr",
          label = "MMR",
          value = NULL
        )
      }
    }) |>
      bindEvent(input$player_rank)

    existing_data <- reactive({
      out <- DBI::dbGetQuery(
        pool,
        glue::glue_sql(
          "
          SELECT
            *
          FROM
            db.players
          WHERE
            user_id = {sv$user_id}
          AND
            valid_to > NOW()
          ",
          .con = pool
        ),
      ) |>
        dplyr::as_tibble()
      return(out)
    })

    observe({
      # req(nrow(existing_data()) > 0)
      updateTextInput(
        inputId = "player_nickname",
        value = existing_data()$nickname
      )
      updateTextInput(
        inputId = "player_discord",
        value = existing_data()$discord
      )
      updateCheckboxInput(
        inputId = "player_standin",
        value = existing_data()$stand_in
      )
      updateTextInput(
        inputId = "player_id",
        value = existing_data()$dota_player_id
      )
      updateSelectizeInput(
        inputId = "player_rank",
        selected = existing_data()$rank
      )
      updateTextInput(
        inputId = "player_mmr",
        value = existing_data()$mmr,
      )
      shinyWidgets::updateRadioGroupButtons(
        inputId = "pos_1_preference",
        selected = existing_data()$pos_1_pref
      )
      shinyWidgets::updateRadioGroupButtons(
        inputId = "pos_2_preference",
        selected = existing_data()$pos_2_pref
      )
      shinyWidgets::updateRadioGroupButtons(
        inputId = "pos_3_preference",
        selected = existing_data()$pos_3_pref
      )
      shinyWidgets::updateRadioGroupButtons(
        inputId = "pos_4_preference",
        selected = existing_data()$pos_4_pref
      )
      shinyWidgets::updateRadioGroupButtons(
        inputId = "pos_5_preference",
        selected = existing_data()$pos_5_pref
      )
    }) |>
      bindEvent(sv$user_id)

    observe({
      if (sv$is_signed_in) {
        shinyjs::enable("save")
      } else {
        shinyjs::disable("save")
      }
    }) |>
      bindEvent(sv$is_signed_in)

    observe({
      output$save_message <- renderText("")
      new_row <- dplyr::tibble(
        user_id = as.integer(sv$user_id),
        discord = input$player_discord,
        nickname = input$player_nickname,
        dota_player_id = input$player_id,
        rank = input$player_rank,
        mmr = as.integer(input$player_mmr),
        pos_1_pref = as.integer(input$pos_1_preference),
        pos_2_pref = as.integer(input$pos_2_preference),
        pos_3_pref = as.integer(input$pos_3_preference),
        pos_4_pref = as.integer(input$pos_4_preference),
        pos_5_pref = as.integer(input$pos_5_preference),
        stand_in = as.logical(input$player_standin)
      )

      existing_check <- existing_data() |>
        dplyr::select(-id, -valid_from, -valid_to)

      if (identical(existing_check, new_row)) {
        output$save_message <- renderText("No changes made.")
        return()
      }

      if (nrow(existing_data() > 0)) {
        DBI::dbExecute(
          pool,
          glue::glue_sql(
            "
          UPDATE
            db.players 
          SET
            valid_to = NOW()
          WHERE
            id = {existing_data()$id}
          ",
            .con = pool
          )
        )
      }

      DBI::dbWriteTable(
        pool,
        name = glue::glue_sql("db.players"),
        value = new_row,
        append = TRUE,
        overwrite = FALSE
      )
    }) |>
      bindEvent(input$save)
  })
}
