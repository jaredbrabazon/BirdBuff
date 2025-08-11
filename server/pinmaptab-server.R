#### pin map page
#pin map values
birdpulls_map <- reactiveValues(
  counter= 1,
  long = NULL,
  ebird_table = tibble(),
  bird_ids = tibble()
)

current_marker <- reactiveVal(NULL)

#Map for pin selection (need to double tap for pin placement)
output$mapselector <- renderLeaflet({
  basegroups <- c("Topographic", "Imagery")
  
  
  leaflet(options = leafletOptions(preferCanvas = FALSE)) %>%
    addEsriBasemapLayer(esriBasemapLayers[[basegroups[1]]], group = basegroups[1]) %>%
    addEsriBasemapLayer(esriBasemapLayers[[basegroups[2]]], group = basegroups[2]) %>%
    addLayersControl( position = "bottomright",
                      baseGroups = basegroups, options = layersControlOptions(collapsed = FALSE))
    # addDrawToolbar(position = "topleft",
    #                markerOptions = drawMarkerOptions(markerIcon = makeAwesomeIcon(icon= "crow", library = "fa", iconColor = '#298582', markerColor = "white")),
    #                polylineOptions = FALSE,
    #                polygonOptions = FALSE,
    #                circleOptions =  FALSE,
    #                rectangleOptions =  FALSE,
    #                circleMarkerOptions =  FALSE,   
    #                singleFeature = TRUE)
})

observeEvent(input$mapselector_click, {
  click <- input$mapselector_click
  
  # Remove the existing marker if there is one
  if (!is.null(current_marker())) {
    leafletProxy("mapselector") %>% removeMarker(layerId = "single_marker")
  }
  
  # Add the new marker
  leafletProxy("mapselector") %>%
    addAwesomeMarkers(lng = click$lng, lat = click$lat, layerId = "single_marker")
  
  # Update the current marker
  current_marker(c(click$lng, click$lat))
})

#this turns on and off the flash card cover
observeEvent(input$coverbttnmap,{
  shinyjs::toggleElement(selector = "div.cover-image-phone")
})

#change flash card pixel height
observeEvent(input$coverpixels,{
  shinyjs::runjs(sprintf("document.getElementById('covermap').style.height = '%spx';", input$coverpixels))
})

#apply new color to flash card
observeEvent(input$applycolor,{
  req(input$coverhex)
  shinyjs::runjs(sprintf("document.getElementById('covermap').style.backgroundImage = 'linear-gradient(%s, black)';", input$coverhex))
})


#previous button on map
observeEvent(input$prevbttnmap,{
  if(birdpulls_map$counter == 1){
    NULL
  } else{
    birdpulls_map$counter <- birdpulls_map$counter -1
  }
  
})

#next button on map
observeEvent(input$nextbttnmap,{
    if(birdpulls_map$counter == length(birdpulls_map$html)){
      NULL
    } else{
      birdpulls_map$counter <- birdpulls_map$counter +1
    }
})

# observeEvent(input$mapselector_draw_new_feature$geometry$coordinates,{
#   if(input$mapselector_draw_new_feature$geometry$coordinates[[1]] > 180){
#     print("-above 180 below")
#     print(input$mapselector_draw_new_feature$geometry$coordinates[[1]] -360)
#   } else if(input$mapselector_draw_new_feature$geometry$coordinates[[1]] < -180){
#     print("below-180 below")
#     print(input$mapselector_draw_new_feature$geometry$coordinates[[1]] +360)
#   }
#   print("orig below")
#   print(input$mapselector_draw_new_feature$geometry$coordinates[[1]])
# })

observeEvent(input$getebirds,{
  if(is.null(birdbuff$api)){
    f7Dialog(id = "apiwarning", title = "Need an API to use this tool!", text = "Enter API on left menu page of app!",type = "alert")
  } else if(is.null(input$mapselector_click)){
    f7Dialog(id = "mapclicker", title = "Oops, looks like we didn't get a lat/long...", text = "Be sure to place a marker on the map!",type = "alert")
  } else {
    #correct long wrapping only works within one world +/-
    # if(input$mapselector_draw_new_feature$geometry$coordinates[[1]] > 180){
    #   long<- input$mapselector_draw_new_feature$geometry$coordinates[[1]] -360
    # } else if(input$mapselector_draw_new_feature$geometry$coordinates[[1]] < -180){
    #   long<-input$mapselector_draw_new_feature$geometry$coordinates[[1]] +360
    # } else{
    #   long<-input$mapselector_draw_new_feature$geometry$coordinates[[1]]
    # }
    if(input$mapselector_click$lng > 180){
      long<- input$mapselector_click$lng -360
    } else if(input$mapselector_click$lng < -180){
      long<-input$mapselector_click$lng +360
    } else{
      long<-input$mapselector_click$lng
    }
   
    #if longitude is different from previous selection, pull new data, otherwise keep old eBird pull - to minimize api usage
    if(identical(birdpulls_map$long, long)){
      NULL
    } else{
    birdpulls_map$long <- long
    if(input$pinmapfrequency == "All Birds-Past 30 Days"){
    birdpulls_map$ebird_table <- ebirdgeo(lat = input$mapselector_click$lat, 
                                          lng = long,
                                          dist = 50, # in km
                                          back = 30,
                                          key = birdbuff$api
    ) %>% select(any_of(c("speciesCode", "comName")))
    } else if(input$pinmapfrequency ==  "Notable Birds-Past 30 Days"){
    birdpulls_map$ebird_table <- ebirdnotable(key = birdbuff$api,
                                              lat = input$mapselector_draw_new_feature$geometry$coordinates[[2]], 
                                              lng = long,
                                              dist = 50, # in km
                                              back = 30)%>% select(any_of(c("speciesCode", "comName")))
    }
    }
    
    if(nrow(birdpulls_map$ebird_table)== 0){
      f7Dialog(id = "pinmapwarning", title = "Hmmm.. Couldn't spot any birds here..", text = "Try pointing your binoculars to a new location. It seems no eBird users have seen birds within 50 km of this location in the past 30 days.",type = "alert")
      
    } else {
      f7Dialog(id="ebirdpointgrab", title = "Got it!", text = "Pecking around eBird to see what we find!", type = "confirm")
      hideDropMenu("pinmap_dropmenu", session = session)
    
      #make function to create html link for iframe
      make_slides <-function(bird_id){
        if(input$device == "phone"){
          paste0("<div class='container'>
            <iframe src='https://macaulaylibrary.org/asset/",bird_id,"/embed' height='385px' width='100%' frameborder='0' allowfullscreen></iframe>
            </div>")
        } else if(input$device == "tablet"){
          paste0("<div class='container'>
            <iframe src='https://macaulaylibrary.org/asset/",bird_id,"/embed' height='600px' width='100%' frameborder='0' allowfullscreen></iframe>
            </div>")
        } else{
          paste0("<div class='container'>
            <iframe src='https://macaulaylibrary.org/asset/",bird_id,"/embed' height='750px' width='100%' frameborder='0' allowfullscreen></iframe>
            </div>")
        }
      }
      
      #sql pull for top rated
    if(input$randorating_maps == "TRUE"){
    if(input$media_map == "Photos"){
      birdpulls_map$bird_ids <- dbGetQuery(db, paste0("SELECT speciesCode, rating, catalog_number, comName, familyComName
                                                      FROM (
                                                        SELECT *,
                                                               ROW_NUMBER() OVER (PARTITION BY speciesCode ORDER BY rating DESC) as row_num
                                                        FROM birdlist join photos using(birdlist_id)
                                                      )
                                                      where speciesCode in ('",str_flatten(birdpulls_map$ebird_table$speciesCode, collapse = "','"),"')
                                                      and row_num <= ",input$nbirds,"
                                                      ORDER BY RANDOM();"))%>% mutate(html = make_slides(bird_id = catalog_number))
      
    } else if(input$media_map == "Audio"){
      birdpulls_map$bird_ids <- dbGetQuery(db, paste0("SELECT speciesCode, rating, catalog_number, comName, familyComName
                                                      FROM (
                                                        SELECT *,
                                                               ROW_NUMBER() OVER (PARTITION BY speciesCode ORDER BY rating DESC) as row_num
                                                        FROM birdlist join audio using(birdlist_id)
                                                      )
                                                      where speciesCode in ('",str_flatten(birdpulls_map$ebird_table$speciesCode, collapse = "','"),"')
                                                      and row_num <= ",input$nbirds,"
                                                      ORDER BY RANDOM();"))%>% mutate(html = make_slides(bird_id = catalog_number))
    }
    } else { #sql pull for random
      if(input$media_map == "Photos"){
        birdpulls_map$bird_ids <- dbGetQuery(db, paste0("SELECT speciesCode, rating, catalog_number, comName, familyComName
                                                      FROM (
                                                        SELECT *,
                                                               ROW_NUMBER() OVER (PARTITION BY speciesCode ORDER BY RANDOM()) as row_num
                                                        FROM birdlist join photos using(birdlist_id)
                                                      )
                                                      where speciesCode in ('",str_flatten(birdpulls_map$ebird_table$speciesCode, collapse = "','"),"')
                                                      and row_num <= ",input$nbirds,"
                                                      ORDER BY RANDOM();"))%>% mutate(html = make_slides(bird_id = catalog_number))
        
      } else if(input$media_map == "Audio"){
        birdpulls_map$bird_ids <- dbGetQuery(db, paste0("SELECT speciesCode, rating, catalog_number, comName, familyComName
                                                      FROM (
                                                        SELECT *,
                                                               ROW_NUMBER() OVER (PARTITION BY speciesCode ORDER BY RANDOM()) as row_num
                                                        FROM birdlist join audio using(birdlist_id)
                                                      )
                                                      where speciesCode in ('",str_flatten(birdpulls_map$ebird_table$speciesCode, collapse = "','"),"')
                                                      and row_num <= ",input$nbirds,"
                                                      ORDER BY RANDOM();"))%>% mutate(html = make_slides(bird_id = catalog_number))
      }
    }
      birdpulls_map$html <- birdpulls_map$bird_ids$html
      birdpulls_map$counter <- 1
      shinyjs::show("pinmapslider")
      
    }
  }

})


observeEvent(nrow(birdpulls_map$ebird_table) >1,{
  output$managepinmap <- renderUI({
    req(nrow(birdpulls_map$ebird_table) >1)
      shinyWidgets::dropMenu(f7Button(inputId = "pinmaprefine_dropmenu", label = "Filter Birds", color = "gray", fill = T),
                             tags$div(style='max-height: 65vh; overflow-y: auto;',
                                      f7Segment(container = "segment", rounded = T,
                             tags$div(
                                                multiInput(
                               inputId = "pinmapbirdchoice",
                               label = tags$h3("Refine Birdlist for Area:"),
                               choices= sort(unique(birdpulls_map$ebird_table$comName)),
                               options = list(
                                 enable_search = TRUE,
                                 non_selected_header = "Choose between:",
                                 selected_header = "You have selected:"
                               ),
                               width = "95%"
                             ),
                             tags$p(style="text-muted", "To return to full bird list for map location, remove all selections and hit the update button below!"),
                             f7Button(inputId = "pinmap_selection", label =  "Update Birdlist", color = "lime", fill = T),
                             tags$br()
                             )),
                             theme = "material",
                             placement = "top-start",
                             hideOnClick = T
      )
      )                      
  })
})
#update birdlist based on refinement
observeEvent(input$pinmap_selection,{
  if(length(input$pinmapbirdchoice) == 0){
    birdpulls_map$html <- birdpulls_map$bird_ids$html
  } else {
    birdpulls_map$html <- (birdpulls_map$bird_ids %>% filter(comName %in% input$pinmapbirdchoice) %>% select(html))$html
  }
  f7Dialog(id = "updatebirds", title = "Birds updated!", text = "Note that not all birds have photos or audio, so there is a chance that a bird will not show up, although the chance is slim!",type = "alert")
  birdpulls_map$counter <- 1
  hideDropMenu(id = "pinmaprefine_dropmenu")
})

output$map_text <- renderUI({
  tags$h3(paste0(birdpulls_map$counter,"/",length(birdpulls_map$html), " (", length(birdpulls_map$ebird_table$speciesCode), " of ", input$pinmapfrequency,  " for selected location)"))
  
  })
output$map_frames <- renderUI({
  req(nrow(birdpulls_map$bird_ids) != 0)
  HTML((birdpulls_map$html)[birdpulls_map$counter])
  
})