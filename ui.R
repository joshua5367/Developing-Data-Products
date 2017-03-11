library(shiny)

shinyUI(fluidPage(
    
    titlePanel("Car MPG Estimator"),
    
    sidebarLayout(
        sidebarPanel(
            selectInput(
                inputId = "ui_cyl",
                label = "Number of cylinder:",
                choices = c(4,6,8),
                multiple = FALSE
            ),
            
            selectInput(
                inputId = "ui_am",
                label = "Transmission type:",
                choices = c("Automatic", "Manual"),
                multiple = FALSE
            ),
            
            numericInput(
                inputId = "ui_hp",
                label = "Horse power:",
                min = 1,
                max = 1000,
                value = 0
            ),
            
            numericInput(
                inputId = "ui_wt",
                label = "Weight (kPound):",
                min = 1,
                max = 50,
                value = 0
            ),
            
            submitButton(
                "Estimate"
            )
        ),
        
        mainPanel(
            
            span("This application estimates the mpg of a car based on
                 the transmission type, cylinder count, horse power and
                 weight of the car."),
            br(),
            span("Horse power and weight of car should be in numeric."),
            br(),
            strong("*note: application needs a few second to generate
                 output."),
            
            hr(),
            
            
            htmlOutput(
                outputId = "ui_predicted"
            ),
            
            htmlOutput(
                outputId = "ui_plotDescription"
            ),
            
            plotOutput("ui_plot")
        )
    )
))
