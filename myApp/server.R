library(rsconnect)
library(shiny)
library(leaflet)
library(tidyverse)
library(lubridate)
library(htmltools)
library(RColorBrewer)
library(plotly)

# import previously cleaned data
ufo <- read.csv("./myApp/UFOCoords.csv")
head(ufo)
# define a colour palette for map
colour_palette <- colorFactor(
  palette="Set3",
  domain=c("Cylindrical", "Light", "Circle", "Spherical", "Rectangular", "Fireball", "Triangular", "Formation", "Unknown", "Other")
)

tmp <- ufo %>% 
  mutate(colour = colour_palette(Shape)) %>% 
  select(Shape, colour) %>% 
  unique()

col_pal <- tmp$colour
names(col_pal) <- tmp$Shape

server <- function(input, output) {
  
  # create the reactive long/lat box that will update based on sliders
  sightings <- reactive({
    
    ufo %>% 
      filter(
        Shape %in% input$Shape,
        lat >= input$latitude[1],
        lat <= input$latitude[2],
        lng >= input$longitude[1],
        lng <= input$longitude[2]
      )
    
    
  })
  
  output$ufosightings <- renderLeaflet({
    
    # create the base map
    leaflet() %>% 
      addTiles() %>% 
      addRectangles(
        lng1=input$longitude[1], lat1=input$latitude[1],
        lng2=input$longitude[2], lat2=input$latitude[2],
        fillColor = "transparent"
      ) %>% 
      addLegend(
        "bottomright",
        pal = colour_palette,
        values = c("Spherical", "Cylindrical", "Light", "Circle", "Rectangular", "Fireball", "Triangular", "Formation", "Unknown", "Other"),
        title = "Shape Reported",
        opacity = 1)
    
  })  
  
  observe({
    
    # code to have markers render based on input
    leafletProxy("ufosightings", data = sightings()) %>%
      clearMarkers() %>% 
      addCircleMarkers(
        lng = ~lng,
        lat = ~lat,
        radius = 5,
        color = ~colour_palette(Shape),
        fillColor = ~colour_palette(Shape),
        fillOpacity = 1,
        popup = ~paste("Shape:", Shape, "<br>",
                       "Lat:", lat, "<br>",
                       "Long:", lng, "<br>",
                       "Date:", Date)
      )
  })
}