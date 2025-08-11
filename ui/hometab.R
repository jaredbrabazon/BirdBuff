f7Card(tags$div(style="margin: 0% 5%", tags$div(style="margin: 0% 20%", tags$img(src='https://live.staticflickr.com/65535/54191442255_bba4d7f07c_n.jpg', width="100%")),
                tags$div(
         tags$h2(style="text-align: center;", "Welcome to BirdBuff!"),
         tags$hr(),
         tags$p("This app was created to help give you easy access to study birds all around the world. Check out the app layout below!"),
         tags$p("This app has four major tabs:"),
         tags$ol(
           tags$li(tags$p(f7Icon("shuffle"),tags$strong(" ShuffleBird Tab:"), "This tab allows you to pull a random selection of birds from the world. Test out your global id skills here! This tab does not require an API key to use.")),
           tags$li(tags$p(f7Icon("rectangle_stack_badge_person_crop"),tags$strong(" User Choice Tab:"), " This tab allows you to build your own adventure. Choose what birds throughtout the world that you would like to study. This tab does not require an API key to use.")),
           tags$li(tags$p(f7Icon("map_pin_ellipse",f7Badge("*API", color = "blue")),HTML("&nbsp;"),tags$strong( "Pin-Map Tab:"), " This tab allows you to select a specific location on a map. Using your API Key, the app will ask eBird what birds have been within 50km of this location in the past 30 days. You can even refine your bird search to just the few birds you would like to brush up on. Please not that not all birds will have photos or audio, however, most do. This tab requires an API Key in order to work.")),
           tags$li(tags$p(f7Icon("map",f7Badge("*API", color = "blue")),HTML("&nbsp;"),tags$strong( "Regions Tab:"), " This tab allows you to select birds seen within different regions of the world at different frequencies. This tab requires an API key."))
         ),
         tags$p("Have an upcoming vacation and want to know what you might see? Try BirdBuffing! Want to get a good grasp on warbler calls? Try Birdbuffing! On the upper left menu, you can enter an eBird API key to get full use of this app. On the upper right menu, you can find tools to alter the view of the app. You can also alter the height and look of the cover card and even set the size to match your type of device. Due to varying sizes of images and user devices, you may need to play with the settings to get the app to work best for your setup."),
         tags$p("To learn more about getting a free eBird API key, see the menu on the upper left panel of the app. This is also the location where you can enter your API key once you've received one. Hint: By using the google password manager on chrome, you can save your API to make it easier to set up the app at each use."),
         HTML("<h3 style='text-align: center';><i class='bi bi-binoculars'></i> Now it's time to get BirdBuffing!</h3>")
       )
       ))