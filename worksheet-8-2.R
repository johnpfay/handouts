# Data
species <- read.csv('data/species.csv', stringsAsFactors = FALSE)
animals <- read.csv('data/animals.csv', na.strings = '', stringsAsFactors = FALSE)

# User Interface
#Create a dropdown list (i.e, a selectInput object)
in1 <- selectInput(inputId = "pick_species",
                   label = 'Pick a species',
                   choices = unique(species[['id']])) #could also use "species$id"

#Create the object to display the output object; label it 'species_id'
out1 <- textOutput('species_id')

#Create a tab object; allows user to flib though panels and add the above in1 object - and out1
tab <- tabPanel(title = 'Species', in1, out1)

#Create the user interface ,adding the tab panel
ui <- navbarPage(title = 'Portal Project', tab)

# Server
server <- function(input, output) {
  output[['species_id']] <- renderText(input[['pick_species']])

  
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
