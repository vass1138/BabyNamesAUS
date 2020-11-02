#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(tidyverse)

#
# Run-first code
#
source("../scripts/load_data_sa.R")
data <- df_sa
data$State <- as.factor(data$State)

get_filtered_data <- function(input,data) {
  
  if (input$state != "ALL") {
    names_data <- data %>% 
      filter(State==input$state & Gender==input$gender)
  } else {
    names_data <- data %>%
      filter(Gender==input$gender)
  }  
}

# Define server logic required to draw a histogram
function(input, output,session) {
  
  names_data <- reactive({
    req(input$state,input$gender)
    get_filtered_data(input,data)
  })

  observeEvent(c(input$state,input$gender),{
      # updateSelectInput(session = session,
      #                   inputId = "name",
      #                   choices = names_data$Name) 
    
    print(paste0("data: ",count(names_data())))
    
      if (exists("names_data") == TRUE) {
        
        name_prefix <- str_to_upper(str_trim(input$firstname))  
      
        if (nchar(name_prefix) > 0) {
          
          names_filtered <- names_data() %>%
            filter(grepl(paste0("^",name_prefix),Name)) 
          
        } else {
          names_filtered <- names_data() 
        }
        
        names_filtered <- names_filtered %>%
          select(Name) %>%
          unique() %>%
          as.list()
          
        print(paste0("filter: ",name_prefix," count: ",length(names_filtered)))
      
        updateSelectizeInput(session,
                             'firstname',
                             choices = names_filtered,
                             server = TRUE) 
        
      }
  })
  
  
  output$name_plot <- renderPlot({
    
    if ((input$update_plot == 0) || (is.na(input$firstname))) {
      return()
    }

    names_data() %>%
      filter(Name==isolate(input$firstname)) %>%
        ggplot(aes(Year,Count)) +
          geom_point()
  })
}
