library(shiny)
library(shinyMobile)
library(shinyjs)
library(RSQLite)
library(shinyWidgets)
library(tidyverse)
library(leaflet)
library(leaflet.esri)
library(rebird)

#grab global-objects
source(file.path("ui", "globalobjects.R"), local = TRUE)$value

#####UI
ui <- f7Page(
#allow shiny JS
  useShinyjs(),
  source(file.path("ui", "css.R"), local = TRUE)$value,
  
  
  #f7page setup
    title = "BirdBuff", options = list(color ="#298582", theme = c("ios"), dark = FALSE, pullToRefresh =FALSE),
  source(file.path("ui", "maindash.R"), local = TRUE)$value
  )

####Server
server <- function(input, output, session) {

  source(file.path("server", "panels-server.R"), local = TRUE)$value
  source(file.path("server", "shuffletab-server.R"), local = TRUE)$value
  source(file.path("server", "pinmaptab-server.R"), local = TRUE)$value
  source(file.path("server", "regioncodestab-server.R"), local = TRUE)$value
  source(file.path("server", "userchoice-server.R"), local = TRUE)$value
  
  }

shinyApp(ui, server)