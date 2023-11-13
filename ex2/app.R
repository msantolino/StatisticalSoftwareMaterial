library(shiny)


ui <- fluidPage(
  
  # App title ----
  titlePanel(title="Normal density"),
  mainPanel(
    img(src='gauss.jpg', align = "left",height="25%", width="25%",),
    ### the rest of your code
  ),
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of simulations ----
      sliderInput(inputId = "simulations",
                  label = "sample size:",
                  min = 100,
                  max = 10000,
                  value = 1000)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Density plot ----
      plotOutput(outputId = "distPlot")
      
    )
  )
)




# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of simulations
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$simulationss) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({
    
    simulations    <- input$simulations
    sampls <- rnorm(simulations, 25,100)
    
   plot(density(sampls), xlab = "Simulated values from normal distribution",
         main = "Density plot")
    
  })
  
}
shinyApp(ui = ui, server = server)
