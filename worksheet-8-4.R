# Libraries
library(ggplot2)
library(dplyr)

# Data
species <- read.csv('data/species.csv', stringsAsFactors = FALSE)
animals <- read.csv('data/animals.csv', na.strings = '', stringsAsFactors = FALSE)

# User Interface
in1 <- selectInput(inputId = 'pick_species',
                   label = 'Pick a Species',
                   choices = unique(species[['id']]))
in2 <- sliderInput('slider_months',
                   label = 'Month range',
                   min = 1, max = 12, value = c(1:12))
		   

side <- sidebarPanel('Options', in1, in2)
out2 <- plotOutput('species_plot')
main <- mainPanel(out2)
tab <- tabPanel(title = 'Species',
                sidebarLayout(side, main))
ui <- navbarPage('Portal Project', tab)

# Server
server <- function(input, output) {
  reactive_data_frame <- reactive({
    months <- seq(input[['slider_months']][1],
                  input[['slider_months']][2])
    animals %>%
      filter(species_id == input[['pick_species']]) %>%
      filter(month %in% months)
  })
  output[['species_name']] <- renderText(
    species %>%
      filter(id == input[['pick_species']]) %>%
      select(genus, species) %>%
      paste(collapse = ' ')
  )
  output[['species_plot']] <- renderPlot(
    ggplot(reactive_data_frame(), aes(year)) +
      geom_bar()
  )
  output[['species_table']] <- renderDataTable(reactive_data_frame())
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
