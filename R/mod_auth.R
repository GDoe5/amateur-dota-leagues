auth_ui <- function(id) {
  shiny::tagList(
    shinyjs::useShinyjs(),
    bs4Dash::tabBox(
      title = "Authentication",
      width = 12,
      solidHeader = TRUE,
      collapsible = FALSE,
      shiny::tabPanel(
        title = "Sign in",
        fluidRow(
          column(
            width = 3,
            textInput(
              NS(id, "signin_username"),
              label = "Username",
              value = "",
              updateOn = "blur"
            ),
            passwordInput(
              NS(id, "signin_password"),
              label = "Password",
              value = "",
              placeholder = "8-20 characters",
              updateOn = "blur"
            ),
            actionButton(
              NS(id, "signin"),
              label = "Sign in"
            ),
            textOutput(
              NS(id, "signin_error_message")
            )
          )
        )
      ),
      shiny::tabPanel(
        title = "Create account",
        fluidRow(
          column(
            width = 3,
            textInput(
              NS(id, "register_username"),
              label = "Username",
              value = "",
              updateOn = "blur"
            ) |>
              shiny::tagAppendAttributes(maxnchar = 30),
            passwordInput(
              NS(id, "register_password"),
              label = "Password",
              value = "",
              placeholder = "8-20 characters",
              updateOn = "blur"
            ) |>
              shiny::tagAppendAttributes(maxnchar = 20),
            passwordInput(
              NS(id, "register_confirm_password"),
              label = "Confirm password",
              value = "",
              updateOn = "blur"
            ) |>
              shiny::tagAppendAttributes(maxnchar = 20),
            actionButton(
              NS(id, "register"),
              label = "Register"
            ),
            textOutput(
              NS(id, "register_error_message")
            )
          )
        )
      )
    )
  )
}

auth_server <- function(id, sv, rv, pool) {
  shiny::moduleServer(id, function(input, output, session) {
    observe({
      output$signin_error_message <- renderText("")

      if (
        nchar(input$signin_username) == 0 |
          nchar(input$signin_password) == 0
      ) {
        output$signin_error_message <- renderText(
          "Enter username and password."
        )
        return()
      }

      user <- DBI::dbGetQuery(
        pool,
        glue::glue_sql(
          "
          SELECT
            *
          FROM
            db.users
          WHERE 
            username = {input$signin_username}",
          .con = pool
        )
      )

      if (
        nrow(user) == 0 |
          !bcrypt::checkpw(input$signin_password, user$password_hash)
      ) {
        output$signin_error_message <- renderText(
          "Invalid username or password."
        )
        return()
      }

      showNotification(
        paste0(
          "Signed-in. Hi ",
          user$username,
          "!"
        ),
        type = "message"
      )

      sv$user_id <- user$id
      sv$username <- user$username
      sv$is_admin <- user$is_admin
      sv$is_signed_in <- TRUE

      switch_tab("replay_upload")
    }) |>
      bindEvent(input$signin)

    observe({
      output$register_error_message <- renderText("")

      if (nchar(input$register_password) < 8) {
        output$register_error_message <- renderText("Password too short.")
        return()
      }

      if (nchar(input$register_password) > 20) {
        output$register_error_message <- renderText(
          "Password too long. How did you even do that?"
        )
        return()
      }

      if (nchar(input$register_username) == 0) {
        output$register_error_message <- renderText("Enter a username.")
        return()
      }

      if (nchar(input$register_username) > 30) {
        output$register_error_message <- renderText(
          "Username too long. How did you even do that?"
        )
        return()
      }

      if (input$register_password != input$register_confirm_password) {
        output$register_error_message <- renderText("Passwords do not match.")
        return()
      }

      hashed_password <- bcrypt::hashpw(input$register_password)

      tryCatch(
        {
          sv$user_id <- DBI::dbGetQuery(
            pool,
            glue::glue_sql(
              "
              INSERT INTO db.users (username, password_hash)
              VALUES ({input$register_username}, {hashed_password})
              RETURNING id          
              ",
              .con = pool
            )
          )
          sv$new_registration <- TRUE
        },
        error = function(e) {
          if (stringr::str_detect(e$message, "unique constraint")) {
            output$register_error_message <- renderText(
              "Username already taken!"
            )
          } else {
            output$register_error_message <- renderText(
              paste0("Registratrion failed, contact admin. ", e$message)
            )
          }
        }
      )

      if (!isTruthy(sv$new_registration)) {
        return()
      }

      sv$username <- input$register_username
      sv$is_signed_in <- TRUE

      showModal(
        modalDialog(
          size = "s",
          paste0(
            "Account created & signed-in. Welcome ",
            input$register_username,
            "!"
          ),
          br(),
          "Set your player and caster profiles?",
          footer = shiny::tagList(
            actionButton(
              NS(id, "goto_home"),
              label = "Later"
            ),
            actionButton(
              NS(id, "goto_player_sign_up"),
              label = "Yes"
            )
          )
        )
      )
    }) |>
      bindEvent(input$register)

    observe({
      removeModal()
      switch_tab("replay_upload")
    }) |>
      bindEvent(input$goto_home)

    observe({
      removeModal()
      switch_tab("player_sign_up")
    }) |>
      bindEvent(input$goto_player_sign_up)

    observe({
      if (sv$is_signed_in) {
        # Clear and disable inputs
        updateTextInput(session, "signin_username", value = "")
        updateTextInput(session, "signin_password", value = "")
        updateTextInput(session, "register_username", value = "")
        updateTextInput(session, "register_password", value = "")
        updateTextInput(session, "register_confirm_password", value = "")

        shinyjs::disable("signin_username")
        shinyjs::disable("signin_password")
        shinyjs::disable("signin")
        shinyjs::disable("register_username")
        shinyjs::disable("register_password")
        shinyjs::disable("register_confirm_password")
        shinyjs::disable("register")
      } else {
        # Enable inputs
        shinyjs::enable("signin_username")
        shinyjs::enable("signin_password")
        shinyjs::enable("signin")
        shinyjs::enable("register_username")
        shinyjs::enable("register_password")
        shinyjs::enable("register_confirm_password")
        shinyjs::enable("register")
      }
    }) |>
      bindEvent(sv$is_signed_in)
  })
}
