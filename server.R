library(shiny)

elicit_gray <- '#646464'
elicit_lt_blue <- '#6E92A8'
elicit_navy_blue <- '#35434D'
elicit_blue_gray <- '#646B86'
elicit_blue_gray_2 <- '#C0C3D0'
elicit_blue_gray_3 <- '#A0A5B8'
elicit_blue_gray_4 <- '#4B5064'
elicit_blue_gray_5 <- '#323543'
JCP_CG1 <- '#AD2664'
JCP_CG2 <- '#D71920'
JCP_CG3 <- '#9A949B'
JCP_CG4 <- '#648EAF'
JCP_CG5 <- '#66CDF5'
JCP_CG6 <- '#94AF29'
JCP_CG7 <- '#C6981E'
JCP_CG8 <- '#D3CC3B'
JCP_CG9 <- '#F7931D'
JCP_CG10 <- '#F6A1A4'
JCP_CG11 <- '#00A7A4'

JCP_Color <- c(JCP_CG1, JCP_CG2, JCP_CG3, JCP_CG4, JCP_CG5, JCP_CG6, JCP_CG7, JCP_CG8, JCP_CG9, JCP_CG10, JCP_CG11)

cust_dataset <- read.csv("data/profile_smpl_100k.csv", header=TRUE, strip.white = TRUE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$distPlot <- renderPlot({
    
    #Subset the customer dataset file by CG number. If CG is set to 0, use the full dataset.
    if (input$customer_segment == "All Customers") {
      data <- cust_dataset
      color = elicit_gray
    }
    else {
      segment <- switch(input$customer_segment,
                  "Loyalists" = 1, "Family Shoppers" = 2, 
                  "Bargain Hunters" = 3, "Credit Inclined" = 4, 
                  "Regulars" = 5, "Trend Seekers" = 6)
      data <-subset(cust_dataset,subset=(cust_dataset$CUSTOMER_SEGMENT_NB==segment))
      color = JCP_Color[as.numeric(segment)]
    }
    
    cg_name <- input$customer_segment
#     cg_name <- switch(input$customer_segment,
#                       "All" = "All Customers",
#                       "1" = "Group 1",
#                       "2" = "Group 2",
#                       "3" = "Group 3",
#                       "4" = "Group 4",
#                       "5" = "Group 5",
#                       "6" = "Group 6",
#                       "7" = "Group 7",
#                       "8" = "Group 8",
#                       "9" = "Group 9",
#                       "10" = "Group 10")
    
    x <- switch(input$var, 
                 "Frequency" = data$CD21A_FREQ_3_YR_NB,
                 "Recency" = data$CD20_RCNCY_DD_NB,
                 "Monetary Value" = data$CD22_MNTRY_VAL_AM)
    
    # UPDATE - need to set max boundary based on quantile of distribution
    max <- switch(input$var,
                        "Frequency" = 100,
                        "Recency" = 1095,
                        "Monetary Value" = 250)
    
    x <- x[x >= 0]
    x <- x[x <= max]
    
    newhist <- hist(x, breaks=input$bins)
    newhist$density = newhist$counts/sum(newhist$counts)
    
    plot(newhist, ann=TRUE, ylim=c(0,1), 
      main=paste(paste("Histogram of", input$var, sep=" "), cg_name, sep=" : "),
      xlab=input$var, ylab="% of Population", col=color, freq=F, border=NULL)
  })
  
})