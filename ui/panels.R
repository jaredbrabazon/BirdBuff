panels = tagList(
  f7Panel(title = "Visual Options", side = "right", theme = "light",
          tags$div(style="margin: 0% 5%;",
                   f7Slider(inputId = "coverpixels", label= tags$h3("Flash Card Height"),min =  0, max =  400, value = 160, step = 1, scale = FALSE, vertical = TRUE),
                   f7ColorPicker(inputId = "coverhex", label = tags$h3("Flash Card Color"), value = "#0a2d40",placeholder = "Select Color Here"),
                   actionBttn(inputId = "applycolor", label = "Apply Color",icon = icon("palette"), style = "bordered", color = "warning"),
                   f7Radio(inputId = 'device', label = tags$div(style = "text-align:center;", tags$h3("Device"), HTML("<i class='fa-solid fa-mobile-screen-button'></i> or <i class='fa-solid fa-tablet-screen-button'></i> or <i class='bi bi-laptop'></i>")), choices = c("phone", "tablet", "computer"), selected = "phone")
          )
  ),
  f7Panel(id = "setuppanel", title = "API Setup", side = "left", theme = "light",
          f7Password(inputId = "api", label = "Paste your eBird API Key!", value = NULL, placeholder = "Your eBird API here"),
          f7Button(inputId = "login",fill = T,  label = "Submit",color = "#298582"),
          tags$br(),
          f7Button(inputId = "ebirdinfo", label = "What's this API thing?", outline = TRUE, fill = FALSE)
          
          )
          
  )
