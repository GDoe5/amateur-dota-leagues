replay_upload_ui <- function(id) {
  shiny::tagList(
    shinyjs::useShinyjs(),
    bs4Dash::box(
      title = "Replay upload",
      width = 12,
      solidHeader = TRUE,
      collapsible = FALSE,
      fluidRow(
        column(
          width = 12,
          fileInput(
            NS(id, "replay_upload"),
            label = "Upload replay",
            multiple = TRUE,
            accept = ".dem",
            buttonLabel = "Browse...",
          ),
          actionButton(
            NS(id, "submit"),
            label = "Submit",
            icon = icon("upload"),
            disabled = TRUE
          )
        )
      ),
      fluidRow(
        DT::DTOutput(
          NS(id, "matches")
        ),
        DT::DTOutput(
          NS(id, "players")
        ),
        DT::DTOutput(
          NS(id, "draft")
        )
      )
    )
  )
}

replay_upload_server <- function(id, sv, rv) {
  shiny::moduleServer(id, function(input, output, session) {
    modrv <- shiny::reactiveValues(
      result = list(
        dplyr::tibble(),
        dplyr::tibble(),
        dplyr::tibble()
      )
    )

    reticulate::source_python("scripts/fn_gem.py")

    observe({
      req(input$replay_upload)
      updateActionButton(
        inputId = "submit",
        disabled = FALSE
      )
    }) |>
      bindEvent(input$replay_upload)

    observe({
      req(input$submit != 0)
      updateActionButton(
        inputId = "submit",
        disabled = TRUE
      )
      modrv$result <- parse_replay(input$replay_upload$datapath)
    }) |>
      bindEvent(input$submit, ignoreInit = TRUE)

    output$matches <- DT::renderDT({
      # req(modrv$result)
      out <- DT::datatable(
        modrv$result[[1]]
      )
      return(out)
    }) |>
      bindEvent(modrv$result)
    output$players <- DT::renderDT({
      # req(modrv$result)
      out <- DT::datatable(
        modrv$result[[2]]
      )
      return(out)
    }) |>
      bindEvent(modrv$result)
    output$draft <- DT::renderDT({
      # req(modrv$result)
      out <- DT::datatable(
        modrv$result[[3]]
      )
      return(out)
    }) |>
      bindEvent(modrv$result)
  })
}
