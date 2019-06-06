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
  
  pca.data <-
    eventReactive(c(input$domainChoice, input$countryChoice), {
      pca <- df.pca  %>% filter(euro_domeniu_nume == input$domainChoice)
      
      if (input$countryChoice != 'all countries') {
        pca <- pca %>% filter(country == input$countryChoice)
      }
      
      pca
      
    })
  
  
  
  
  output$plot.timeline <- renderPlot({
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
    df <- ranking.data()$df
    width.bar <- ranking.data()$width.bar
    print(head(df))
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
    data <- pca.data()
    
    if (input$pca_vector == 'pc1.2') {
      plot_ly(
        data,
        x =  ~ PC1,
        y =  ~ PC2,
        color =  ~ group,
        colors = cols,
        type = 'scatter',
        text = ~ paste(name, party)
      ) %>% layout(xaxis = list(range = c(min.pc1*1.1,max.pc1*1.1)),
                   yaxis = list(range = c(min.pc2*1.1,max.pc2*1.1)))
      
      
    } else  if (input$pca_vector == 'pc2.3') {
      plot_ly(
        data,
        x =  ~ PC3,
        y =  ~ PC2,
        color =  ~ group,
        colors = cols,
        type = 'scatter',
        text = ~ paste(name, party)
      )%>% layout(xaxis = list(range = c(min.pc3*1.1,max.pc3*1.1)),
                  yaxis = list(range = c(min.pc2*1.1,max.pc2*1.1)))
    }
    
    
    
  })
  
  
  
  
  
}
