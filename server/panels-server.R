#change flash card pixel height
observeEvent(input$coverpixels,{
  shinyjs::runjs(sprintf("document.getElementById('cover').style.height = '%spx';", input$coverpixels))
})

#apply new color to flash card
observeEvent(input$applycolor,{
  req(input$coverhex)
  shinyjs::runjs(sprintf("document.getElementById('cover').style.backgroundImage = 'linear-gradient(%s, black)';", input$coverhex))
})

#show ebird instructions
observeEvent(input$ebirdinfo,{
  f7Dialog(id = "warning", title = "API Info!", text = tags$div(HTML("<h3 class='text-muted'>To use this app, you need a valid eBird API Key. Don't worry, an API Key is free! An API key is simply a code that links to your eBird account that gives you access to pull certain data from eBird. How do you get one?
                                                                                             <ol type='1'>
                                                                                             <li> Make an eBird account.</li> 
                                                                                             <li> Follow the link below to request a free API key. You will need to login with your eBird account.</li> 
                                                                                             <li> Choose the API choice and not the EBD. eBird asks you to fill out a form. In the form state that you are using the data privately to study birds in an app.</li>
                                                                                             </ol>
                                                                                             That's it! With an API key, you can use this app to tailor your BirdBuffing to best suit your needs. Whether that is to learn the birds for an upcoming vacation or to brush up on what calls are from which warbler in your area, BirdBuffing can help you out! Enjoy!</h3>"),
                                                                       f7Link(href = "https://ebird.org/api/keygen", label = " Get eBird API Key Here!", icon = icon("crow"))),type = "alert")
  
})


#global values
birdbuff <- reactiveValues(
  api = NULL
)

#assign api upon login button
observeEvent(input$login,{
  if(nchar(input$api) > 2){
    birdbuff$api <- input$api
    f7Dialog(id="apienter", title = "API entered!", text = "Tapping into eBird now!", type = "confirm")
    
  } else{
    f7Dialog(id="apifail", title = "Try Again", text = "Doesn't seem like a valid API Key was entered, get a valid API Key and try again.", type = "alert")
  }
})