###################
# server.R
#
# For all your server needs
###################


library(plotly)
library(gridExtra)


server <- function(input, output, session) {
  ranking.data <-
    eventReactive(c(input$memberChoice), {
      ranking <- NULL
      ranking$df <-
        df.ranking %>% mutate(color.percent.presence = ifelse(member_id == input$memberChoice, 'red', '#CDE2B8'))
      ranking$df <-
        ranking$df %>% mutate(color.number.presence = ifelse(member_id == input$memberChoice, 'red', '#a1b6ba'))
      ranking$df <-
        ranking$df %>% mutate(width.bar = ifelse(member_id == input$memberChoice, 10, 1))
      
      
      ranking$width.bar <- ranking$df  %>% pull(width.bar)
      ranking
      
    })
  
  output$countryChoice = renderUI({
    if (input$scope == 'members') {
      selectInput(
        "countryChoice",
        "Choose a country",
        choices = c('all countries', all.countries),
        
        selected = "all countries"
      )
    } else {
      return(NULL)
    }
  })
  
  output$memberChoice = renderUI({
    if (input$scope == 'members') {
      members.id.country = pca.data() %>% pull(member_id)
      df.members.selected <-
        df.members %>% filter(id %in% members.id.country)
      
      
      selectInput(
        "memberChoice",
        "Choose a member",
        choices = split(df.members.selected$id, df.members.selected$name)
        
      )
      
      
    } else{
      return(NULL)
    }
  })
  
  output$selected_mep <- renderText({
    req(input$memberChoice)
    name_detail <-
      df.members %>% filter(id == input$memberChoice) %>% pull(name)
    paste0('Voting history for : ', name_detail)
  })
  
  
  pca.data <-
    eventReactive(c(input$domainChoice, input$countryChoice), {
      data <- df.pca  %>% filter(euro_domeniu_nume == input$domainChoice)
      
      if (input$countryChoice != 'all countries') {
        data <- data %>% filter(country == input$countryChoice)
      }
      
      data
      
    })
  
  
  
  
  output$plot.timeline <- renderPlot({
    if (input$scope == 'party') {
      return(NULL)
    }
    
    
    req(input$memberChoice)
    p <-
      ggplot(
        df.session.votes %>% filter(member_id == input$memberChoice),
        aes(
          x = as.factor(week.date.vote),
          y = n,
          fill = status
        )
      ) + geom_bar(stat = 'identity') + scale_x_discrete(breaks = sessions$x.dates.axis.breaks,
                                                         limits = as.factor(sessions$dates)) + theme(axis.text.x = element_text(angle = 90, hjust = 0),
                                                                                                     legend.position = "top") + scale_fill_manual("", values = c("Absent" = "#bd3c30", "Present" = '#3182bd')) +
      xlab('') + ylab('votes')
    
    p
  })
  
  output$plot.ranking <- renderPlot({
    if (input$scope == 'party') {
      return(NULL)
    }
    
    
    df <- ranking.data()$df
    width.bar <- ranking.data()$width.bar
    
    df$name <-
      factor(df$name, levels = (df$name[order(df$presence.ratio)]))
    p.percent.votes <-
      ggplot(df,
             aes(name, presence.ratio, fill = color.percent.presence)) + geom_bar(width =
                                                                                    width.bar,
                                                                                  stat = 'identity',
                                                                                  position = "identity") + theme(
                                                                                    axis.text.y = element_blank(),
                                                                                    axis.ticks.y = element_blank(),
                                                                                    axis.title.y = element_blank(),
                                                                                    legend.position = 'none'
                                                                                  ) + coord_flip() + scale_fill_identity()
    
    
    df$name <-
      factor(df$name, levels = (df$name[order(df$votes.count)]))
    
    p.voted.count <-
      ggplot(df, aes(name, votes.count, fill = color.number.presence)) + geom_bar(width =
                                                                                    width.bar,
                                                                                  stat = 'identity',
                                                                                  position = "identity") + theme(
                                                                                    axis.text.y = element_blank(),
                                                                                    axis.ticks.y = element_blank(),
                                                                                    axis.title.y = element_blank(),
                                                                                    legend.position = 'none'
                                                                                  ) + coord_flip() + scale_fill_identity()
    
    p <-
      grid.arrange(p.voted.count,
                   p.percent.votes,
                   ncol = 2,
                   heights = c(1, 1))
    p
  })
  
  output$plot.pca <- renderPlotly({
    if (input$scope == 'members')
    {
      df <- pca.data()
      req(input$memberChoice)
      
      
      df <-
        df %>% mutate(size_marks = ifelse(member_id == input$memberChoice, 300, 10))
      

      
      plot_ly(
        df,
        x =  ~ PC2,
        y =  ~ PC1,
        color =  ~ group,
        #alpha = 1,
        #opacity = ~alpha_mark,
        colors = cols,
        type = 'scatter',
        mode = 'markers',
        text = ~ paste(name, party),
        size =  ~ size_marks
      
        
       
      )  %>%
        layout(yaxis = list(range = c(min.pc1 * 1.1, max.pc1 * 1.1)),
               xaxis = list(range = c(min.pc2 * 1.1, max.pc2 * 1.1)))
      
    } else if (input$scope == 'party') {
      df <-
        df.pca.party %>% filter(euro_domeniu_nume == input$domainChoice)
      
      
      plot_ly(
        df,
        x =  ~ PC2,
        y =  ~ PC1,
        color =  ~ group,
        #alpha = 0.6,
        colors = cols,
        type = 'scatter',
        mode = 'markers',
        text = ~ party,
        size =  ~ size
        
      )  %>%
        layout(yaxis = list(range = c(min(df$PC1) * 1.1, max(df$PC1) * 1.1)),
               xaxis = list(range = c(min(df$PC2) * 1.1, max(df$PC2) * 1.1)))
    }
    
    
    
  })
  
  
  
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("MEP_data_term8", "zip", sep = ".")
    },
    content = function(fname) {
      all.files = paste0('data/', list.files('data/'))
      
      zip(zipfile = fname, files = all.files)
    },
    contentType = "application/zip"
  )
  
  
  
  
  
}
