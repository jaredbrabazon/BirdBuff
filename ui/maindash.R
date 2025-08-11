f7TabLayout(
  #setup left and right panels
  source(file.path("ui", "panels.R"), local = TRUE)$value,
  
  #setup top navbar
  navbar = f7Navbar(
    title = HTML("<h1><i class='bi bi-binoculars'></i> BirdBuff</h1>"),
    hairline = TRUE,
    shadow = TRUE,
    leftPanel = TRUE,
    rightPanel = TRUE
  ),
  #setup tabs
  f7Tabs(animated = TRUE, 

#shuffle tabs
f7Tab(
  tabName = "home",
  icon = f7Icon("house_fill"),
  active = TRUE,
  source(file.path("ui", "hometab.R"), local = TRUE)$value
),
  f7Tab(
  tabName = "globalshuffle",
  icon = f7Icon("shuffle"),
  active = FALSE,
  shinyWidgets::dropMenu(f7Button(inputId = "shuffle_dropmenu", label = "ShuffleBird Parameters (Click Me!)", color = "teal", fill = T),
                         
                         
                         tags$div(style='max-height: 69vh; overflow-y: auto;',
                                  f7Segment(container = "segment", rounded = T,
                                            tags$strong(tags$h2(icon(style = "color:#298582;", "crow"),"Global Birds")),
                                            tags$h3("Choose Media Type"),
                                  f7Radio(
                                    inputId = "media_shuffle",
                                    label = "Media Type:",
                                    selected = "Photos", 
                                    choices = c(`<i class="fa-solid fa-photo-film"></i>` = "Photos", `<i class="fa-solid fa-music"></i>` = "Audio")
                                  ),
                                  f7Stepper(inputId = "nshuffle", label= tags$h3("How many slides per shuffle?"),min = 1, max = 50, value = 10, step = 1,color = "grey", rounded = T),
                                  tags$br()
                                  )
                         )
  ),
source(file.path("ui", "shuffletab.R"), local = TRUE)$value
),
f7Tab(tabName = "userchoice",
      icon = f7Icon("rectangle_stack_badge_person_crop"),
      active = FALSE,
      shinyWidgets::dropMenu(f7Button(inputId = "userchoice_dropmenu", label = "Set Up Personal BirdStack! (Click Me)", color = "teal", fill = T),
                             
                             tags$div(style='max-height: 70vh; overflow-y: auto;',
                                      f7Segment(container = "segment", rounded = T,
                                                
                                                tags$strong(tags$h2(icon(style = "color:#298582;", "crow"),"Bird Selection ")),
                                                tags$p("Choose birds for your BirdBuff Session")
                                      ),
                                      f7Radio(
                                        inputId = "media_user",
                                        label = "Media Type:",
                                        selected = "Photos",
                                        choices = c(`<i class="fa-solid fa-photo-film"></i>` = "Photos", `<i class="fa-solid fa-music"></i>` = "Audio")
                                      ),
                                      f7Stepper(inputId = "nbirds_user", label= tags$h3("Max number of media per bird:"),min = 1, max = 10, value = 5, step = 1,color = "grey", rounded = T),
                                      tags$br(),
                                      tags$br(),
                                      f7Toggle(inputId = "randorating_user", label = tags$p("Show media by top rating? (default on)"),color = "lime", checked = TRUE),
                                      tags$br(),
                                      tags$hr(),
                                      selectInput("data1", label="", choices = NULL, multiple =TRUE),
                                      tags$br(),
                                      uiOutput("data2"),
                                      tags$br(),
                                      #selectizeInput('uiselectuserchoice', label="Select Birds:", choices = NULL, multiple =TRUE),
                                      tags$br(),
                                      f7Button(inputId = "getebirdsuser", label = "Submit!", color = "lime", fill = T),
                             
                                      theme = "material",
                                      placement = "bottom-start",
                                      hideOnClick = T
                             )),
      source(file.path("ui", "userchoicetab.R"), local = TRUE)$value
),
f7Tab(tabName = "pinmap",
      icon = f7Icon("map_pin_ellipse",f7Badge("*API", color = "blue")), 
      active = FALSE,
      shinyWidgets::dropMenu(f7Button(inputId = "pinmap_dropmenu", label = "Get Birds via Pin-Map! (Click Me)", color = "teal", fill = T),
                             
                             
                             tags$div(style='max-height: 65vh; overflow-y: auto;',
                                      f7Segment(container = "segment", rounded = T,
                                                
                                                tags$strong(tags$h2(icon(style = "color:#298582;", "crow"),"Birds within Past 30 Days ")),
                                                tags$h3("Choose Location on map"),
                                                #tags$p("(Click marker tool on map. Place marker by double tapping on desired location. This grabs sightings within 50km of point.) Keep scrolling beyond map for more options.")
                                                tags$p("Click on map to place the blue marker where you want to search for birds!")
                                      ),
                                      f7Flex(leafletOutput(outputId = "mapselector")),
                                      f7Radio(inputId = "pinmapfrequency", 
                                              label = "Select desired pull for location:",
                                              choices = c("All Birds-Past 30 Days", #ebirdregion
                                                          "Notable Birds-Past 30 Days"), #ebirdnotable
                                              selected = "All Birds-Past 30 Days"),
                                      f7Radio(
                                        inputId = "media_map",
                                        label = "Media Type:",
                                        selected = "Photos",
                                        choices = c(`<i class="fa-solid fa-photo-film"></i>` = "Photos", `<i class="fa-solid fa-music"></i>` = "Audio")
                                      ),
                                      tags$br(),
                                      f7Stepper(inputId = "nbirds", label= tags$h3("Max number of media per bird:"),min = 1, max = 10, value = 5, step = 1,color = "grey", rounded = T),
                                      tags$br(),
                                      tags$br(),
                                      f7Toggle(inputId = "randorating_maps", label = tags$p("Show media by top rating? (default on)"),color = "lime", checked = TRUE),
                                      tags$br(),
                                      tags$br(),
                                      f7Button(inputId = "getebirds", label = "Submit!", color = "lime", fill = T),
                                      
                                      theme = "material",
                                      placement = "bottom-start"
                             )
      ),
source(file.path("ui", "pinmaptab.R"), local = TRUE)$value,
uiOutput(outputId = "managepinmap")

),
f7Tab(tabName = "regioncodes",
      icon = f7Icon("map",f7Badge("*API", color = "blue")),
      active = FALSE,
      shinyWidgets::dropMenu(f7Button(inputId = "regions_dropmenu", label = "Get Birds via Regions! (Click Me)", color = "teal", fill = T),
                             
                             
                             tags$div(style='max-height: 65vh; overflow-y: auto;',
                                      f7Segment(container = "segment", rounded = T,
                                                
                                                tags$strong(tags$h2(icon(style = "color:#298582;", "crow"),"Choose birds by regions!")),
                                                tags$p("Stop at the desired level. To reset, click and delete selected item.")   
                                                ),
                                      uiOutput("regioncodename"),
                                      selectInput("regiondata1", label="", choices = NULL, multiple =FALSE),
                                      tags$br(),
                                      uiOutput("regiondata2"),
                                      tags$br(),
                                      uiOutput("regiondata3"),
                                      tags$br(),
                                      f7Radio(inputId = "regionsfrequency", 
                                                      label = "Select desired pull for region:",
                                                      choices = c("All Birds-All Time", #ebirdregionspecies
                                                                  "All Birds-Past 30 Days", #ebirdregion
                                                                  "Notable Birds-Past 30 Days"), #ebirdnotable
                                                                  #"All Birds-Specific Date"), #ebirdhistorical 
                                                      selected = "All Birds-All Time"),
                                      #uiOutput("dates"),
                                      #tags$br(),
                                      f7Radio(
                                        inputId = "media_regions",
                                        label = "Media Type:",
                                        selected = "Photos",
                                        choices = c(`<i class="fa-solid fa-photo-film"></i>` = "Photos", `<i class="fa-solid fa-music"></i>` = "Audio")
                                      ),
                                      tags$br(),
                                      f7Stepper(inputId = "nbirds_regions", label= tags$h3("Max number of media per bird:"),min = 1, max = 10, value = 5, step = 1,color = "grey", rounded = T),
                                      tags$br(),
                                      tags$br(),
                                      f7Toggle(inputId = "randorating_regions", label = tags$h3("Show media by top rating? (default on)"),color = "lime", checked = TRUE),
                                      tags$br(),
                                      tags$br(),
                                      tags$br(),
                                      f7Button(inputId = "getebirds_regions", label = "Submit!", color = "teal", fill = T),
                                      
                                      theme = "material",
                                      placement = "bottom-start"
                             )
      ),
source(file.path("ui", "regioncodestab.R"), local = TRUE)$value,
uiOutput(outputId = "manageregions")
)

  )
)