library(shiny)
library(datasets)
library(ggplot2)
library(gridExtra)

shinyServer(function(input, output) {
   
    # When application startup, input$ui_hp and input$ui_wt are 0
    # We do not do prediction when initial startup
    
    # Prediction model
    model <- lm(mpg ~ cyl+hp+wt+am, mtcars)
    
    # Graph
    baseplot_am_mpg <- 
        ggplot(mtcars) + 
        geom_point(aes(am, mpg, colour = factor(am)), size = 3) +
        geom_smooth(aes(am, mpg), method = "lm") +
        ggtitle("Transmission Type vs MPG") +
        scale_color_hue(labels = c("0 (automatic)","1 (manual)"))
    baseplot_cyl_mpg <- 
        ggplot(mtcars) + 
        geom_point(aes(cyl, mpg, colour = factor(cyl)), size = 3) +
        geom_smooth(aes(cyl, mpg), method = "lm") +
        ggtitle("Cylinder count vs MPG")
    baseplot_hp_mpg <- 
        ggplot(mtcars) + 
        geom_point(aes(hp, mpg, colour = hp), size = 3) +
        scale_colour_gradient(low = "blue") +
        geom_smooth(aes(hp, mpg), method = "lm") +
        ggtitle("Horse Power vs MPG")
    baseplot_wt_mpg <- 
        ggplot(mtcars) + 
        geom_point(aes(wt, mpg, colour = wt), size = 3) +
        scale_colour_gradient(low = "blue") +
        geom_smooth(aes(wt, mpg), method = "lm") +
        ggtitle("Weight vs MPG")
    
    
    # Reactive variable
    reactive_am <- reactive({
        if (input$ui_am == "Automatic"){
            0
        }else{
            1
        }
    })
    reactive_cyl <- reactive({
        as.numeric(input$ui_cyl)
    })
    reactive_hp <- reactive({
        if(is.numeric(input$ui_hp)){
            as.numeric(input$ui_hp)
        }
        else{
            0
        }
    })
    reactive_wt <- reactive({
        if(is.numeric(input$ui_wt)){
            as.numeric(input$ui_wt)
        }
        else{
            0
        }
    })
    reactive_pred_input <- reactive({
        data.frame(
            cyl = reactive_cyl(),
            hp = reactive_hp(),
            wt = reactive_wt(),
            am = reactive_am()
        )
    })
    reactive_pred_output <- reactive({
        predict(model, reactive_pred_input())
    })
    reactive_plot_am_mpg <- reactive({
        baseplot_am_mpg + geom_vline(xintercept = reactive_am())
    })
    reactive_plot_cyl_mpg <- reactive({
        baseplot_cyl_mpg + geom_vline(xintercept = reactive_cyl())
    })
    reactive_plot_hp_mpg <- reactive({
        baseplot_hp_mpg + geom_vline(xintercept = reactive_hp())
    })
    reactive_plot_wt_mpg <- reactive({
        baseplot_wt_mpg + geom_vline(xintercept = reactive_wt())
    })
    reactive_plot_combine <- reactive({
        # print graph, 2 x 2
        grid.arrange(
            reactive_plot_am_mpg(), reactive_plot_cyl_mpg(), 
            reactive_plot_hp_mpg(), reactive_plot_wt_mpg(), 
            nrow=2, ncol=2)
    })
    
    
    output$ui_predicted <- renderText({
        # Check for input
        hp_isNumeric = is.numeric(input$ui_hp)
        wt_isNumeric = is.numeric(input$ui_wt)
        if(hp_isNumeric== FALSE){
            return("Error : \"Horse power\" should be numeric.")
        }
        if(wt_isNumeric== FALSE){
            return("Error : \"Weight\" should be numeric.")
        }
        if(input$ui_hp == 0 | input$ui_wt == 0){
            return("")
        }
        
        # Print output
        paste(
            "<h3>Estimated MPG:<b>", 
            reactive_pred_output(),
            "</b></h3><br/>",
            "<p>Graphs below illustrate the relationship between predictors
                and mpg.</p>",
            "<p>All predictors are <em>inversely proportional</em> towards
                mpg except for transmission type predictor as it is a factor
                variable. You may refers to the <strong>blue</strong> line
                on the graph for better understanding on the relationship.</p>",
            "<p><strong>Black</strong> vertical line on the graph 
                represents your input predictors. This shows roughly how 
                your car's rank in general for each predictors.</p>")
    })
    
    output$ui_plot <- renderPlot({
        # Check for input
        hp_isNumeric = is.numeric(input$ui_hp)
        wt_isNumeric = is.numeric(input$ui_wt)
        if(hp_isNumeric== FALSE){
            return("Error : \"Horse power\" should be numeric.")
        }
        if(wt_isNumeric== FALSE){
            return("Error : \"Weight\" should be numeric.")
        }
        if(input$ui_hp == 0 | input$ui_wt == 0){
            return("")
        }
        
        reactive_plot_combine()
    })
})
