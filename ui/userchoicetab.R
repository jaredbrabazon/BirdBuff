shinyjs::hidden(tags$div(id = "userslider",
                         f7Card(
                           uiOutput(outputId = "user_text"),
                           tags$div( 
                             uiOutput(outputId = "user_frames"),
                             HTML("<div id='coveruser', class='cover-image-phone'><i class='bi bi-binoculars-fill' style='color:white';></i></div>")
                           ),
                           footer = tags$div(class="parent",
                                             tags$div(class = "daughter",actionBttn(inputId = "prevbttnuser", label = NULL,icon = icon(name = "crow", class = "flip-horizontal"), style = "bordered", color = "danger")),
                                             tags$div(class = "middle", actionBttn(inputId = "coverbttnuser", label = NULL,icon = HTML("<i class='bi bi-binoculars'></i>"), style = "bordered", color = "success")),
                                             tags$div(class = "daughter",actionBttn(inputId = "nextbttnuser", label = NULL,icon = icon(name = "crow"), style = "bordered", color = "primary"))
                           )
                         )
)
)
