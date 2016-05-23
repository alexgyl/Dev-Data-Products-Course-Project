
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ISLR)
library(caret)
library(e1071)

shinyServer(function(input, output) {
  data(Default)
  
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    # You can access the value of the widget with input$select, e.g.
    # Selecting which histogram to view
    if(input$select == 1){
      var = "balance"
    }
    else{
      var = "income"
    }
    x    <- Default[,var]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'blue', border = 'white', main = paste("Histogram of", var), xlab = var)
    
  })
  
  # Display the data table for the "Default" data set from ISLR
  output$data = renderDataTable(Default)
  # Reactive input from the push button
  finalRes = eventReactive(input$exec,{
    set.seed(1234)
    # Choosing data proportioning size
    prob = input$portion/100
    trainIn = createDataPartition(Default$default, p = prob, list = FALSE) 
    train = Default[trainIn,]
    test = Default[-trainIn,]
    # Creation of model
    finalTrain = train[,c(input$variables,"default")]
    finalTest = test[,c(input$variables,"default")]
    model = train(default~., method = "glm",data = finalTrain)
    predictions = predict(object = model, finalTest)
    output$vars = renderText({paste("Confusion Matrix for Logisitic Regression of the variables:", paste(input$variables,sep = "", collapse = ", "))})
    output$sens = renderTable({as.table(confusionMatrix(predictions,finalTest$default)$byClass)})
    confusionMatrix(predictions,finalTest$default)$table
    
  })
  # Render table outputs for confusion matrix
  output$table = renderTable({finalRes()})
  
})
