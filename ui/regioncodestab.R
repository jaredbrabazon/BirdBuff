shinyjs::hidden(tags$div(id = "regionsslider",
                         f7Card( 
                           uiOutput(outputId = "regions_text"),
                           tags$div( 
                             uiOutput(outputId = "regions_frames"),
                             HTML("<div id='coverregions', class='cover-image-phone'><i class='bi bi-binoculars-fill' style='color:white';></i></div>")
                           ),
                           footer = tags$div(class="parent",
                                             tags$div(class = "daughter",actionBttn(inputId = "prevbttnregions", label = NULL,icon = icon(name = "crow", class = "flip-horizontal"), style = "bordered", color = "danger")),
                                             tags$div(class = "middle", actionBttn(inputId = "coverbttnregions", label = NULL,icon = HTML("<i class='bi bi-binoculars'></i>"), style = "bordered", color = "success")),
                                             tags$div(class = "daughter",actionBttn(inputId = "nextbttnregions", label = NULL,icon = icon(name = "crow"), style = "bordered", color = "primary"))
                           )
                         )
)
)