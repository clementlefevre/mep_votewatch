# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).

library(shinythemes)
library(plotly)

# Use a fluid Bootstrap layout
fluidPage(
  # Give the page a title
  theme = shinytheme("journal"),
  img(src = 'eu_logo.png', align = "left", width = 70),
 
  titlePanel("MEP Votes - Term 8 (2014-19) - Principal Component Analysis"),
  
  # Generate a row with a sidebar
  sidebarLayout(
    # Define the sidebar with one input
    sidebarPanel(
      radioButtons("scope", "Scope",
                   c(
                     "Members" = "members",
                     "Party" = "party"
                   ),selected = 'party'),
      
      
      uiOutput('countryChoice'),
      uiOutput('memberChoice'),
      plotOutput("plot.timeline"),
      plotOutput("plot.ranking")
    ),
    
    # Create a spot for the barplot
    mainPanel(tabsetPanel(
      tabPanel("Plot",    fixedRow(column(
        width = 12,
        selectInput(
          "domainChoice",
          "Choose a Domain",
          choices = sort(unique(df.pca$euro_domeniu_nume)),
          selected = 'all domains'
        )
        
      )),
      
      plotlyOutput("plot.pca")),
      tabPanel(
        'About',
        h3("Idea"),
        p("Following ",a(href = "https://www.economist.com/graphic-detail/2019/06/01/centrist-liberals-gained-the-most-power-in-the-eu-parliament", "this article from the Economist"),", i tried to figure out how to visualize the votes of the Members of the EU Parliament. The Economist used two criteria, ie. Pro/Anti-EU & Left/Right :"),
        img(src = 'the_economist.png'),
        tags$br(),
        tags$br(),
        p(" i was interested to see whether using the raw voting history would produce the same pattern."),
        
        h3("Methodology"),
        p("The data source is the website of the NGO ",a(href="https://www.votewatch.eu/","MEP Votes Watch"), "that retrieves all voting history of the MEP. With the voting history of all MEP, i proceeded to a Principal Component Analysis on the MEP/Votes matrix."),
p("To achieve this, i converted the vote result into a numerical value : ",strong("in favour"), ": +1 point,",strong(" absent"),": 0 point, ",strong("abstained"),": -1 point, and",strong("against")," : - 2 points."),
p('The explained variance on the first PC vector is, depending on the domain, between 91 and 98 %.'),
        downloadButton("downloadData", label = "Download MEP Term 8 data")
      )
    ))
    
  )
)