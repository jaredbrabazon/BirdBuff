create_nested_list <- function(df) {
  outer_split <- split(df, df[[1]])
  nested_list <- lapply(outer_split, function(x) {
    setNames(as.list(x[[3]]), x[[2]])
  })
  return(nested_list)
}


#regions page
birdpulls_regions<- reactiveValues(
  country = create_nested_list(dbGetQuery(db,"select continent_name, country_name, country_code from country join continent using (continent_id);")),
  subnat1 = NULL,#create_nested_list(dbGetQuery(db,"select country_name, subnational1_name, subnational1_code from country join subnational1 using (country_id);")),
  subnat2 = NULL,#create_nested_list(dbGetQuery(db,"select subnational1_name, subnational2_name, subnational2_code from subnational1 join subnational2 using (subnational1_id);")),
  counter= 1,
  regioncode =NULL,
  ebird_table = tibble(),
  bird_ids = tibble()
)

observe({
  updateSelectizeInput(session = session, server =T, "regiondata1", "Select a Country:", choices = birdpulls_regions$country,selected = "US", options = list(maxOptions =300))
  })

# observe({
#   print(birdpulls_regions$regioncode)
#   # print(paste("country:", input$regiondata1, is.null(input$regiondata1)))
#   # print(paste("sub1:", input$sub1, is.null(input$sub1)))
#   # print(paste("sub2:", input$sub2, is.null(input$sub2)))
# })

output$regioncodename <-renderUI({
  tags$h3(style = "color: orange;", paste0("Your selected location is: '", birdpulls_regions$regioncode,"'"))
})

observeEvent(input$regiondata1,{
  #if sub1 and sub2 are not chosen use the country
  if(is.null(input$sub2) && is.null(input$sub1)){
    birdpulls_regions$regioncode <-input$regiondata1
  }
})
observeEvent(input$sub1,{
  #if sub1 is chosen but not sub2 choose sub1
  if(is.null(input$sub2) && !is.null(input$sub1)){
    birdpulls_regions$regioncode <- input$sub1
  }
})

observeEvent(input$sub2,{
  #if sub1 and sub2 are chosen choose sub2
  if(!is.null(input$sub2) && !is.null(input$sub1)){
    birdpulls_regions$regioncode <- input$sub2
  }
})


## input dependent on the choices in `data1`
output$regiondata2 <- renderUI({
  birdpulls_regions$subnat1<- dbGetQuery(db,paste0("select subnational1_name, subnational1_code from country join subnational1 using (country_id) where country_code = '",input$regiondata1,"';"))
  selectizeInput("sub1", label ="Select Subnational1 (e.g., State or Region):", multiple = T, choices = split(birdpulls_regions$subnat1$subnational1_code,birdpulls_regions$subnat1$subnational1_name), options = list(
    maxItems = 1
  ))
})

## input dependent on the choices in `data1`
output$regiondata3 <- renderUI({
  birdpulls_regions$subnat2<- dbGetQuery(db,paste0("select subnational2_name, subnational2_code from subnational1 join subnational2 using (subnational1_id) where subnational1_code = '",input$sub1,"';"))
  selectizeInput("sub2", label ="Select Subnational2 (e.g., County or Subregion):",multiple = T, choices = split(birdpulls_regions$subnat2$subnational2_code,birdpulls_regions$subnat2$subnational2_name), options = list(
    maxItems = 1
  ))
})


#this turns on and off the flash card cover
observeEvent(input$coverbttnregions,{
  shinyjs::toggleElement(selector = "div.cover-image-phone")
})

#change flash card pixel height
observeEvent(input$coverpixels,{
  shinyjs::runjs(sprintf("document.getElementById('coverregions').style.height = '%spx';", input$coverpixels))
})

#apply new color to flash card
observeEvent(input$applycolor,{
  req(input$coverhex)
  shinyjs::runjs(sprintf("document.getElementById('coverregions').style.backgroundImage = 'linear-gradient(%s, black)';", input$coverhex))
})


#previous buttonon regions
observeEvent(input$prevbttnregions,{
  if(birdpulls_regions$counter == 1){
    NULL
  } else{
    birdpulls_regions$counter <- birdpulls_regions$counter -1
  }
  
})

#next buttonon regions
observeEvent(input$nextbttnregions,{
  if(birdpulls_regions$counter == length(birdpulls_regions$html)){
    NULL
  } else{
    birdpulls_regions$counter <- birdpulls_regions$counter +1
  }
})

# output$dates <- renderUI({
#   req(input$regionsfrequency == "All Birds-Specific Date")
#   
#   f7DatePicker(inputId = "dateregions", 
#                label = "Select date:", 
#                multiple = FALSE,
#                value = Sys.Date(),
#                dateFormat = "yyyy-mm-dd", 
#                maxDate = Sys.Date(),
#                minDate = "2010-01-01",
#                closeByOutsideClick = FALSE,
#                openIn = "popover"
#                 )
# })

observeEvent(input$getebirds_regions,{
  if(is.null(birdbuff$api)){
    f7Dialog(id = "apiwarning2", title = "Need an API to use this tool!", text = "Enter API on left menu page of app!",type = "alert")
  } else{

    if(input$regionsfrequency == "All Birds-All Time"){
      birdpulls_regions$ebird_table <- ebirdregionspecies(key = birdbuff$api,
                                                          location = birdpulls_regions$regioncode)%>% 
                                        left_join(dbGetQuery(db, "select speciesCode, comName from birdlist;"))%>%
                                        select(any_of(c("speciesCode", "comName")))
    } else if(input$regionsfrequency == "All Birds-Past 30 Days"){
      birdpulls_regions$ebird_table <- ebirdregion(key = birdbuff$api,
                                                   loc = birdpulls_regions$regioncode,
                                                   back = 30
                                                    )%>% select(any_of(c("speciesCode", "comName")))
    } else if(input$regionsfrequency == "Notable Birds-Past 30 Days"){
      birdpulls_regions$ebird_table <- ebirdnotable(key = birdbuff$api,
                                                    region = birdpulls_regions$regioncode,
                                                    back = 30)%>% select(any_of(c("speciesCode", "comName")))
    } 
    
    # else if(input$regionsfrequency == "All Birds-Specific Date"){
    #   birdpulls_regions$ebird_table <- ebirdhistorical(key = birdbuff$api,
    #                                                    loc = birdpulls_regions$regioncode,
    #                                                    date = input$dateregions)%>% select(any_of(c("speciesCode", "comName")))
    # }
    
    
    if(nrow(birdpulls_regions$ebird_table)== 0){
      f7Dialog(id = "regionswarning2", title = "Hmmm.. Couldn't spot any birds here..", text = "Try pointing your binoculars to a new location or change the pull request. It seems eBird can't find any birds for your request.",type = "alert")
      
    } else {
      f7Dialog(id="ebirdregionsgrab", title = "Got it!", text = "Pecking around eBird to see what we find!", type = "confirm")
      hideDropMenu("regions_dropmenu", session = session)
      
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
      if(input$randorating_regions == "TRUE"){
        if(input$media_regions == "Photos"){
          birdpulls_regions$bird_ids <- dbGetQuery(db, paste0("SELECT speciesCode, rating, catalog_number, comName, familyComName
                                                      FROM (
                                                        SELECT *,
                                                               ROW_NUMBER() OVER (PARTITION BY speciesCode ORDER BY rating DESC) as row_num
                                                        FROM birdlist join photos using(birdlist_id)
                                                      )
                                                      where speciesCode in ('",str_flatten(birdpulls_regions$ebird_table$speciesCode, collapse = "','"),"')
                                                      and row_num <= ",input$nbirds_regions,"
                                                      ORDER BY RANDOM();"))%>% mutate(html = make_slides(bird_id = catalog_number))
          
        } else if(input$media_regions == "Audio"){
          birdpulls_regions$bird_ids <- dbGetQuery(db, paste0("SELECT speciesCode, rating, catalog_number, comName, familyComName
                                                      FROM (
                                                        SELECT *,
                                                               ROW_NUMBER() OVER (PARTITION BY speciesCode ORDER BY rating DESC) as row_num
                                                        FROM birdlist join audio using(birdlist_id)
                                                      )
                                                      where speciesCode in ('",str_flatten(birdpulls_regions$ebird_table$speciesCode, collapse = "','"),"')
                                                      and row_num <= ",input$nbirds_regions,"
                                                      ORDER BY RANDOM();"))%>% mutate(html = make_slides(bird_id = catalog_number))
        }
      } else { #sql pull for random
        if(input$media_regions == "Photos"){
          birdpulls_regions$bird_ids <- dbGetQuery(db, paste0("SELECT speciesCode, rating, catalog_number, comName, familyComName
                                                      FROM (
                                                        SELECT *,
                                                               ROW_NUMBER() OVER (PARTITION BY speciesCode ORDER BY RANDOM()) as row_num
                                                        FROM birdlist join photos using(birdlist_id)
                                                      )
                                                      where speciesCode in ('",str_flatten(birdpulls_regions$ebird_table$speciesCode, collapse = "','"),"')
                                                      and row_num <= ",input$nbirds_regions,"
                                                      ORDER BY RANDOM();"))%>% mutate(html = make_slides(bird_id = catalog_number))
          
        } else if(input$media_regions == "Audio"){
          birdpulls_regions$bird_ids <- dbGetQuery(db, paste0("SELECT speciesCode, rating, catalog_number, comName, familyComName
                                                      FROM (
                                                        SELECT *,
                                                               ROW_NUMBER() OVER (PARTITION BY speciesCode ORDER BY RANDOM()) as row_num
                                                        FROM birdlist join audio using(birdlist_id)
                                                      )
                                                      where speciesCode in ('",str_flatten(birdpulls_regions$ebird_table$speciesCode, collapse = "','"),"')
                                                      and row_num <= ",input$nbirds_regions,"
                                                      ORDER BY RANDOM();"))%>% mutate(html = make_slides(bird_id = catalog_number))
        }
      }
      birdpulls_regions$html <- birdpulls_regions$bird_ids$html
      birdpulls_regions$counter <- 1
      shinyjs::show("regionsslider")
      
    }
  }
  
})


observeEvent(nrow(birdpulls_regions$ebird_table) >1,{
  output$manageregions <- renderUI({
    req(nrow(birdpulls_regions$ebird_table) >1)
    shinyWidgets::dropMenu(f7Button(inputId = "regionsrefine_dropmenu", label = "Filter Birds", color = "gray", fill = T),
                           tags$div(style='max-height: 65vh; overflow-y: auto;',
                                    f7Segment(container = "segment", rounded = T,
                                              tags$div(
                                                multiInput(
                                                  inputId = "regionsbirdchoice",
                                                  label = tags$h3("Refine Birdlist for Region:"),
                                                  choices= sort(unique(birdpulls_regions$ebird_table$comName)),
                                                  options = list(
                                                    enable_search = TRUE,
                                                    non_selected_header = "Choose between:",
                                                    selected_header = "You have selected:"
                                                  ),
                                                  width = "95%"
                                                ),
                                                tags$p(style="text-muted", "To return to full bird list for map location, remove all selections and hit the update button below!"),
                                                f7Button(inputId = "regions_selection", label =  "Update Birdlist", color = "lime", fill = T),
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
observeEvent(input$regions_selection,{
  if(length(input$regionsbirdchoice) == 0){
    birdpulls_regions$html <- birdpulls_regions$bird_ids$html
  } else {
    birdpulls_regions$html <- (birdpulls_regions$bird_ids %>% filter(comName %in% input$regionsbirdchoice) %>% select(html))$html
  }
  f7Dialog(id = "updatebirdsregion", title = "Birds updated!", text = "Note that not all birds have photos or audio, so there is a chance that a bird will not show up, although the chance is slim!",type = "alert")
  birdpulls_regions$counter <- 1
  hideDropMenu(id = "regionsrefine_dropmenu")
})

output$regions_text <- renderUI({
  tags$h3(paste0(birdpulls_regions$counter,"/",length(birdpulls_regions$html), " (", length(birdpulls_regions$ebird_table$speciesCode), " of ", input$regionsfrequency, " at ", birdpulls_regions$regioncode, ")"))
  
})
output$regions_frames <- renderUI({
  req(nrow(birdpulls_regions$bird_ids) != 0)
  HTML((birdpulls_regions$html)[birdpulls_regions$counter])
  
})