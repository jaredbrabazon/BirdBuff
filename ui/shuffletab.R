tags$div(
  shinyjs::hidden(tags$div(id = "shufflecard",
  #Shuffle tab
  f7Card( uiOutput(outputId = "swiper_shuffle_text"),
          tags$div(
            uiOutput(outputId = "swiper_shuffle"),
            HTML("<div id='cover', class='cover-image-phone'><i class='bi bi-binoculars-fill' style='color:white';></i></div>")
          ),
          footer = tags$div(class="parent",
                            tags$div(class = "daughter",actionBttn(inputId = "prevbttn", label = NULL,icon = icon(name = "crow", class = "flip-horizontal"), style = "bordered", color = "danger")),
                            tags$div(class = "middle", actionBttn(inputId = "coverbttn", label = NULL,icon = HTML("<i class='bi bi-binoculars'></i>"), style = "bordered", color = "success")),
                            tags$div(class = "daughter",actionBttn(inputId = "nextbttn", label = NULL,icon = icon(name = "crow"), style = "bordered", color = "primary"))
          )
  )
  )
  ),
  tags$div(tags$h3("Get Random Shuffle (Global):"),tags$div(style= "margin: 0% 2%;",actionBttn(inputId = "refreshshuffle", label = NULL,icon = tags$h3(icon("shuffle"), ), style = "simple", color = "warning")))
)