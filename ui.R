

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Model Selector"),
  
  # Sidebar with a slider input for number of models 
  sidebarLayout(
    sidebarPanel(
       sliderInput("models","Number of models:",
                   min = 1,
                   max = 20,
                   value = 10),
       checkboxInput("show_table","Display Table",value=TRUE)

    ),
    
    # Show the best models by rank. Show in graph and in table format
    mainPanel(
    h3("Model Ranking"),
        plotOutput("plot1"),
    h5("Percent increase in RMSE between the first and last model in the group"),
        textOutput("percent_inc") ,
        tableOutput('mytable')
   

 
    
            )
  )
))


