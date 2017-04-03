#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ModelMetrics)
library(dplyr)
# generate a data.frame containing a model identifier, randomly generated model predictions and observed data, and RMSE 
set.seed(3)
model_num=rep(1:20,each=10)
predictions<-matrix(rnorm(200), nrow=200,byrow = TRUE)
actual<-matrix(rnorm(200), nrow=200,byrow = TRUE)

# Put results in a data frame 
data<-data.frame(model_num,predictions,actual)   

#Calcualte model RMSE 
#install.packages("ModelMetrics")
#library(ModelMetrics)
#library(dplyr)
results<- data %>%
        group_by(model_num) %>%
        summarise(
                RMSE = rmse(predictions,actual)
        )

results<-as.data.frame(results)

 #sort best model by RMSE
results<- results[with(results, order(RMSE)), ]
 #round to 3 decimal places
results<-format(results, digits = 3)
results$RMSE<-as.numeric(results$RMSE)


# Define server logic required to create table with model rankings
shinyServer(function(input, output) {
  
        # Plot RMSE for top models
        output$plot1 <- renderPlot({
        dataY<-results$RMSE[1:input$models]
        xlab="Model"
        ylab="RMSE"
        plot(c(1:input$models),dataY,xlim=c(0,input$models),xaxt="n", xlab=xlab,ylab=ylab)
        axis(1, at=1:input$models, labels=results$model_num[1:input$models])
        })

        mytable<- reactive({
        if(input$show_table==TRUE){
                table =  results[1:input$models,]
                table
        }    
   
        })
        
        output$mytable<-renderTable({mytable()}) 
        
        # calculate percent increase
       percent_inc<- reactive({
        best<-as.numeric(results$RMSE[1])
        worst<-results$RMSE[input$models]
        perc_change<-((worst-best)/best )*100
        inc<-round(perc_change, 2)       
        inc
        })

       output$percent_inc<-renderText({percent_inc()})
       
})      
        
        

