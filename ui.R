
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  headerPanel("To Default or Not to Default?"),
  mainPanel(
    tabsetPanel(
      
      tabPanel("Data",
               dataTableOutput("data")
      ),
      
      tabPanel("Histogram",
               # Select box for variable selection 
               selectInput("select", label = h3("Select box"), 
                           choices = list("Balance" = 1, "Income" = 2), 
                           selected = 1),
               
               
               # Sidebar with a slider input for number of bins
               sidebarLayout(
                 sidebarPanel(
                   sliderInput("bins",
                               "Number of bins:",
                               min = 1,
                               max = 50,
                               value = 30)
                 ),
                 
                 # Show a plot of the generated distribution
                 mainPanel(
                   plotOutput("distPlot")
                 )
               )
      ),
      
      tabPanel("Model",
               # Numeric input for training set size
               numericInput("portion", label = h3("Choose Training Set Size (%)"), value = 60,min = 0, max = 99),
               # Group of checkboxes to select variables
               
               checkboxGroupInput("variables", label = h3("Select Variables:"), 
                                  choices = c("Student" = "student", "Balance" = "balance", "Income" = "income"),
                                  selected = "income"),
               # Reactive action button
               actionButton("exec", "Run"),
               # Outputs for variables used, confusion matrix and model metrics
               textOutput("vars"),
               tableOutput("table"),
               tableOutput("sens")
      ),
      tabPanel("About",
               mainPanel(
                 includeMarkdown("about.md")
               )
      )
    )
  )
))
