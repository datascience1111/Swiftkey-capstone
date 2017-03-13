#ui.r

library(shiny)

shinyUI(fluidPage(
    
    titlePanel("Coursera Data Science Capstone Project"),
    h4("Travis Porter"),
    h4("10 March 2017"),
    
    
    textInput("text", label = h3("Text input"), value = "", placeholder = "Enter up to three words..."),
    
    submitButton("Make Prediction"),
    
    
    hr(),
    
    titlePanel("Prediction Summary"),
    verbatimTextOutput(("text1"))
    
    
))

