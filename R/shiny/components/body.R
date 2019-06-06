###################
# body.R
# 
# Create the body for the ui. 
# If you had multiple tabs, you could split those into their own
# components as well.
###################
body <- dashboardBody(
  tabItems(
    
    ########################
    # First tab content
    ########################
    tabItem(
      tabName = "dashboard",
      fluidRow(
        
      
        # PLOT THE THTINGS
        
  selectInput(
         "memberChoice",
         "Choose a member",
         choices = split(df.members$id, df.members$name),
         
         selected = ""),
       box(plotOutput("plot.timeline")),
       box(plotOutput("plot.ranking")),
  box(plotlyOutput("plot.pca"))
     
         )
        
      
    ),
    
    ########################
    # Second tab content
    ########################
    tabItem(
      tabName = "widgets",
      h2("Widgets tab content")
    )
  )
)

