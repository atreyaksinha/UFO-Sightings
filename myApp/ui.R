library(rsconnect)
library(shiny)
library(leaflet)
library(tidyverse)
library(plotly)

ui <- fluidPage(
  
  sidebarLayout(
    
    # sidebar -------------------------------------------------------------
    sidebarPanel(
      
      HTML(
        paste(h1("UFO Sightings in USA and Canada"),
              '<br/>',
              h5("A map of UFO Sightings in USA and Canada that were reported between "),
              h5("January 01, 2016 and September 30, 2016."), 
              '<br/>')
      ),
      
      sliderInput("latitude", "latitude", min = 18, max = 80, value = c(18, 80)),
      
      sliderInput("longitude", "longitude", min = -164, max = -61, value = c(-164, -61)),
      
      checkboxGroupInput("Shape", 
                         "Shapes Reported Seen:", 
                         c("Spherical", "Cylindrical", "Light", "Circle", "Rectangular", "Fireball", "Triangular", "Formation", "Unknown", "Other"),
                         c("Spherical", "Cylindrical", "Light", "Circle", "Rectangular", "Fireball", "Triangular", "Formation", "Unknown", "Other")
      )
    ),
    
    # main panel ----------------------------------------------------------
    mainPanel(
      leafletOutput("ufosightings", height = 500),
      hr()
    )
  )
)