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
  
  output$distPlot <- renderPlot({
    
    simulations    <- input$simulations
    sampls <- rnorm(simulations, 25,100)
    
   plot(density(sampls), xlab = "Simulated values from normal distribution",
         main = "Density plot")
    
  })
  
}
shinyApp(ui = ui, server = server)
