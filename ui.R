library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Customer Segment Profiler"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("customer_segment", 
                  label = "Select Customer Segment to display:",
                  choices = c("All Customers", "Loyalists", "Family Shoppers", "Bargain Hunters", "Credit Inclined", "Regulars"),
                  selected = "All Customers"),
      selectInput("var", 
                  label = "Select Customer Dimension to display:",
                  choices = c("Recency", "Frequency", "Monetary Value"),
                  selected = ""),
      sliderInput("bins", 
                  label = "Select number of bins for histogram:",
                  min = 1, max = 20, value = 10),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      img(src = "Elicit_final.png", height="50%", width="50%"),
      br(),
      a("www.elicitinsights.com", href="http://www.elicitinsights.com", target="_blank")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    ) 
  )
))