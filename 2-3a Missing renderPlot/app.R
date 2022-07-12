# Load packages ----------------------------------------------------------------

library(shiny)
library(ggplot2)
library(dplyr)

# Load data --------------------------------------------------------------------

load("movies.RData")

# Define UI --------------------------------------------------------------------

ui <- fluidPage(
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
                  selected = "audience_score"),
      
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
                  selected = "critics_score"),
      
      checkboxGroupInput(inputId = "selected_title_type", 
                         label = "Select title type:", 
                         choices = levels(movies$title_type),
                         selected = levels(movies$title_type))
    ),
    
    mainPanel(
      plotOutput(outputId = "scatterplot"),
      tableOutput(outputId = "summary table")
    )
  )
)

# Define server ----------------------------------------------------------------

server <- function(input, output, session) {
  
  output$scatterplot <- ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
    geom_point()
  
}


# Calculate New Variable--------------------------------------------------------
movies <- movies %>% 
  mutate(score_ratio=audience_score/critics_score)

# Create a Shiny app object ----------------------------------------------------

shinyApp(ui = ui, server = server)
