#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinycustomloader)
library(DT)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Baby Names in Australia"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("state", h3("Select state"), 
                  choices = list(
                    "All" = "ALL",
                    "NSW" = "NSW",
                    "QLD" = "QLD", 
                    "SA" = "SA"),
                  selected = 1),
      selectInput("gender", h3("Select gender"), 
                choices = list(
                  "Male" = "MALE",
                  "Female" = "FEMALE"),
                selected = 1),
      selectizeInput('firstname',
                     label="Select Name",
                     choices = NULL,
                     options=list(maxOptions=5,
                                  placeholder="Enter name")
                     ),
      # selectInput(inputId = "name",
      #             label = "Select Name",
      #             choices = NULL),
      actionButton("update_plot","Update")
    ),
    
    # Show a plot of the generated distribution
    mainPanel({
      withLoader(plotOutput(outputId = "name_plot"))
    }
    )
  )
))
