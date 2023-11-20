
# Load packages ----
library(shiny)
library(maps)
library(mapproj)

# Source helper function ----
source("helpers.R")

# Read data ----
counties <- readRDS("data/counties.rds")

# User interface ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
        information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(plotOutput("map"))
  )
)

# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)

    #legend_title <- str_c( "% ", str_extract(input$var, "(?<=\\s).+"))

    color <- switch(input$var, 
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")

    legend_title <- switch(input$var, 
                   "Percent White" = "% White",
                   "Percent Black" = "% Black",
                   "Percent Hispanic" = "% Hispanic",
                   "Percent Asian" = "% Asian")

    percent_map(data, color, legend_title, input$range[1], input$range[2])
  })
}

# Run app ----
shinyApp(ui, server)

# ui <- fluidPage(
#   titlePanel("censusVis"),
  
#   sidebarLayout(
#     sidebarPanel(
#       helpText("Create demographic maps with information form the 2010 US Census"),
#       selectInput("var",
#                   label = "Choose a variable to display",
#                   choices = list("Percent White",
#                                  "Percent Black",
#                                  "Percent Hispanic",
#                                  "Percent Asian"),
#                   selected = "Percent White"),
      
#       sliderInput("range",
#                 label = "Range of interest:",
#                 min = 0, max = 100, value = c(0, 100))
#     ),
    
#     mainPanel(
#       textOutput("selected_var"),
#       textOutput("min_max")
#     )
#   )
# )
  
# # Define server logic ----
# server <- function(input, output) {
#   output$selected_var <- renderText({ 
#     str_c("You have selected ", input$var)
#   })
#   output$min_max <- renderText({
#     str_c("You have chosen a range that goes from ", input$range[1], " to ", input$range[2])
#     })
    
# }

# # Run the app ----
# shinyApp(ui = ui, server = server)



