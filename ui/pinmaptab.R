## Map Tab

      shinyjs::hidden(tags$div(id = "pinmapslider",
                               f7Card( 
                               uiOutput(outputId = "map_text"),
      tags$div( 
        uiOutput(outputId = "map_frames"),
        HTML("<div id='covermap', class='cover-image-phone'><i class='bi bi-binoculars-fill' style='color:white';></i></div>")
      ),
      footer = tags$div(class="parent",
                        tags$div(class = "daughter",actionBttn(inputId = "prevbttnmap", label = NULL,icon = icon(name = "crow", class = "flip-horizontal"), style = "bordered", color = "danger")),
                        tags$div(class = "middle", actionBttn(inputId = "coverbttnmap", label = NULL,icon = HTML("<i class='bi bi-binoculars'></i>"), style = "bordered", color = "success")),
                        tags$div(class = "daughter",actionBttn(inputId = "nextbttnmap", label = NULL,icon = icon(name = "crow"), style = "bordered", color = "primary"))
      )
      )
      )
      )
