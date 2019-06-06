# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
library(plotly)

# Use a fluid Bootstrap layout
fluidPage(# Give the page a title
  titlePanel("Telephones by region"),
  
  # Generate a row with a sidebar
  sidebarLayout(
    # Define the sidebar with one input
    sidebarPanel(
      #hr(),
      #helpText("Data from AT&T (1961) The World's Telephones."),
      selectInput(
        "countryChoice",
        "Choose a country",
        
        choices = c('all countries', all.countries),
        
        selected = "all countries"
      ),
      
      selectInput(
        "groupChoice",
        "Choose a group",
        choices = unique(df.members$group),
        
        selected = ""
      ),
      
      selectInput(
        "memberChoice",
        "Choose a member",
        choices = split(df.members$id, df.members$name),
        
        selected = ""
      ),
      plotOutput("plot.timeline"),
      plotOutput("plot.ranking")
    ),
    
    # Create a spot for the barplot
    mainPanel(
      selectInput(
        "domainChoice",
        "Choose a Domain",
        choices = unique(df.pca$euro_domeniu_nume),
        selected = 'Agriculture'
      ),
      
      radioButtons(
        "pca_vector",
        "",
        c("PC1-PC2" = "pc1.2", "PC2-PC3" = "pc2.3"),
        selected = 'pc1.2'
      ),
      plotlyOutput("plot.pca")
    )
    
  ))