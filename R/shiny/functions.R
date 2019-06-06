###################
# functions.R
# 
# Need some functions for your ui logic or server?? Define em' here.
###################



plot.ranking <- function(df,member_id){
  
  member_id.value <- df[]
  p <-ggplot(df,aes(presence.ratio))+ geom_histogram()
  p
}




