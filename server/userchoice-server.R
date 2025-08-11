#### user page
birdpulls_user <- reactiveValues(
  userchoices = dbGetQuery(db,"select distinct speciesCode, comName, familyComName from birdlist join photos using(birdlist_id) order by familyComName;"),
  counter= 1,
  bird_ids = tibble()
)


observe({
  updateSelectizeInput(session = session, server =T, "data1", "Select Bird Group/s", choices = sort(unique(birdpulls_user$userchoices$familyComName)), options = list(maxOptions =3000))
  })

## input dependant on the choices in `data1`
output$data2 <- renderUI({
  multiInput(
    inputId = "data2",
    label = tags$h3("Select one or many Common Family Names:"),
    choices= split(birdpulls_user$userchoices$speciesCode[birdpulls_user$userchoices$familyComName %in% input$data1],
                   birdpulls_user$userchoices$comName[birdpulls_user$userchoices$familyComName %in% input$data1]),
    options = list(
      enable_search = TRUE,
      non_selected_header = "Choose between:",
      selected_header = "You have selected:"
    ),
    width = "95%"
  )
})


#this turns on and off the flash card cover
observeEvent(input$coverbttnuser,{
  shinyjs::toggleElement(selector = "div.cover-image-phone")
})

#change flash card pixel height
observeEvent(input$coverpixels,{
  shinyjs::runjs(sprintf("document.getElementById('coveruser').style.height = '%spx';", input$coverpixels))
})

#apply new color to flash card
observeEvent(input$applycolor,{
  req(input$coverhex)
  shinyjs::runjs(sprintf("document.getElementById('coveruser').style.backgroundImage = 'linear-gradient(%s, black)';", input$coverhex))
})


#previous button on map
observeEvent(input$prevbttnuser,{
  if(birdpulls_user$counter == 1){
    NULL
  } else{
    birdpulls_user$counter <- birdpulls_user$counter -1
  }
  
})

#next button on map
observeEvent(input$nextbttnuser,{
  if(birdpulls_user$counter == length(birdpulls_user$html)){
    NULL
  } else{
    birdpulls_user$counter <- birdpulls_user$counter +1
  }
})

observeEvent(input$getebirdsuser,{
 
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
      #run sql base on random or top rated media choice
      #Top rated sql pull
      if(input$randorating_user == "TRUE"){
      if(input$media_map == "Photos"){
        
        birdpulls_user$bird_ids <- dbGetQuery(db, paste0("SELECT speciesCode, rating, catalog_number, comName, familyComName
                                                      FROM (
                                                        SELECT *,
                                                               ROW_NUMBER() OVER (PARTITION BY speciesCode ORDER BY rating DESC) as row_num
                                                        FROM birdlist join photos using(birdlist_id)
                                                      )
                                                      where speciesCode in ('",str_flatten(input$data2, collapse = "','"),"')
                                                      and row_num <= ",input$nbirds_user,"
                                                      ORDER BY RANDOM();"))%>% mutate(html = make_slides(bird_id = catalog_number))
        
      } else if(input$media_map == "Audio"){
        birdpulls_user$bird_ids <- dbGetQuery(db, paste0("SELECT speciesCode, rating, catalog_number, comName, familyComName
                                                      FROM (
                                                        SELECT *,
                                                               ROW_NUMBER() OVER (PARTITION BY speciesCode ORDER BY rating DESC) as row_num
                                                        FROM birdlist join audio using(birdlist_id)
                                                      )
                                                      where speciesCode in ('",str_flatten(input$data2, collapse = "','"),"')
                                                      and row_num <= ",input$nbirds_user,"
                                                      ORDER BY RANDOM();"))%>% mutate(html = make_slides(bird_id = catalog_number))
      }
      } else { #random media pull
        if(input$media_map == "Photos"){
          birdpulls_user$bird_ids <- dbGetQuery(db, paste0("SELECT speciesCode, rating, catalog_number, comName, familyComName
                                                      FROM (
                                                        SELECT *,
                                                               ROW_NUMBER() OVER (PARTITION BY speciesCode ORDER BY RANDOM()) as row_num
                                                        FROM birdlist join photos using(birdlist_id)
                                                      )
                                                      where speciesCode in ('",str_flatten(input$data2, collapse = "','"),"')
                                                      and row_num <= ",input$nbirds_user,"
                                                      ORDER BY RANDOM();"))%>% mutate(html = make_slides(bird_id = catalog_number))
          
        } else if(input$media_map == "Audio"){
          birdpulls_user$bird_ids <- dbGetQuery(db, paste0("SELECT speciesCode, rating, catalog_number, comName, familyComName
                                                      FROM (
                                                        SELECT *,
                                                               ROW_NUMBER() OVER (PARTITION BY speciesCode ORDER BY RANDOM()) as row_num
                                                        FROM birdlist join audio using(birdlist_id)
                                                      )
                                                      where speciesCode in ('",str_flatten(input$data2, collapse = "','"),"')
                                                      and row_num <= ",input$nbirds_user,"
                                                      ORDER BY RANDOM();"))%>% mutate(html = make_slides(bird_id = catalog_number))
        }
      }
      
      birdpulls_user$html <- birdpulls_user$bird_ids$html
      birdpulls_user$counter <- 1
      f7Dialog(id = "updateuserbirdsalert", title = "Birds updated!", text = "Getting all your birds pulled together!",type = "alert")
      shinyWidgets::hideDropMenu("userchoice_dropmenu", session = session)
      shinyjs::show("userslider")
})


output$user_text <- renderUI({
  tags$h3(paste0(birdpulls_user$counter,"/",length(birdpulls_user$html), " (", length(unique(birdpulls_user$bird_ids$comName)), " birds selected)"))
  
})
output$user_frames <- renderUI({
  req(nrow(birdpulls_user$bird_ids) != 0)
  HTML((birdpulls_user$html)[birdpulls_user$counter])
  
})