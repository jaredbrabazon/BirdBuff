#shuffle values
birdpulls_shuffle <- reactiveValues(
  counter= 1,  
  bird_ids = NULL,
  html = NULL
)


#this turns on and off the flash card cover
observeEvent(input$coverbttn,{
  shinyjs::toggleElement(selector = "div.cover-image-phone")
})

#previous button on shuffle
observeEvent(input$prevbttn,{
  if(birdpulls_shuffle$counter == 1){
    NULL
  } else{
    birdpulls_shuffle$counter <- birdpulls_shuffle$counter -1
  }
  
})

#next button on shuffle
observeEvent(input$nextbttn,{
  if(birdpulls_shuffle$counter == input$nshuffle){
    NULL
  } else{
    birdpulls_shuffle$counter <- birdpulls_shuffle$counter +1
  }
})


##shuffleoutput
observeEvent(input$refreshshuffle,{
  shinyjs::show("shufflecard")
  birdpulls_shuffle$counter <- 1
  if(input$media_shuffle == "Photos"){
    birdpulls_shuffle$bird_ids <- dbGetQuery(db, paste0("select catalog_number from photos ORDER BY RANDOM() LIMIT ", input$nshuffle, ";"))
  } else if(input$media_shuffle == "Audio"){
    birdpulls_shuffle$bird_ids <- dbGetQuery(db, paste0("select catalog_number from audio ORDER BY RANDOM() LIMIT ", input$nshuffle, ";"))
  }
  #update these cover divs to have a class that has the pixel height rather than from a div id
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
  
  birdpulls_shuffle$html <- map_df(.x =birdpulls_shuffle$bird_ids, ~make_slides(.x))
})

#shuffle text at top
output$swiper_shuffle_text <- renderUI({
  tags$h3(paste0(birdpulls_shuffle$counter,"/", nrow(birdpulls_shuffle$html)))
})

#Produce the iframe UI for shuffle
output$swiper_shuffle <- renderUI({
  req(!is.null(birdpulls_shuffle$html))
  
  HTML(birdpulls_shuffle$html$catalog_number[birdpulls_shuffle$counter])
  
})