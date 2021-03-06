library(shiny)
library(shinyMobile)
library(arrow)
library(dplyr)
library(maps)
library(leaflet)

# Cities data base
cities_db <- open_dataset(sources = "cities.feather", format = "feather")
country_vec <- cities_db %>%
  distinct(country) %>%
  arrange(country) %>%
  collect() %>%
  pull(country)
n <- nrow(cities_db)


# Get random city coordinates function
random_city <- function(cities = cities_db, country_sel = "Any"){
  if(country_sel == "Any"){
    seed <- as.integer(runif(n = 1, min = 1, max = 7427243))
    res <- cities %>%
      filter(id == seed) %>%
      collect()
  } else {
    res <- cities %>%
      filter(country == country_sel) %>%
      collect() %>%
      slice_sample(n = 1)
  }
  return(res)
}





shinyApp(
  ui = f7Page(
    title = "Random city view",
    f7SingleLayout(
      navbar = f7Navbar(
        title = f7Float(side = "left", uiOutput(outputId = "city_info")),
        f7Col(
          width = 3,
          f7Float(side = "right", f7Button(inputId = "go_btn", label = "Change!", rounded = TRUE, outline = TRUE, fill = FALSE))
        )
      ),
      toolbar = f7Toolbar(
        position = "bottom",
        f7SmartSelect(
          inputId = "base_map",
          label = "Base map",
          selected = "Esri.WorldImagery",
          choices = c("Esri.WorldImagery", "OpenStreetMap", "Stamen", "Stamen.Watercolor"),
          openIn = "popup"
        ),
        f7SmartSelect(
          inputId = "country",
          label = "Country",
          selected = "Any",
          choices = c("Any", country_vec),
          openIn = "popup"
        )
      ),
      leafletOutput(outputId = "map", height = "100%")
    )
  ),
  server = function(input, output) {
    # Map function
    map <- function(){
      
      city <- random_city(country = input$country)
      
      map <- leaflet() |>
        addProviderTiles(input$base_map) |>
        setView(lng = city$lon, lat = city$lat, zoom = 16) |>
        addMiniMap(toggleDisplay = TRUE)
      
      # Update city info
      output$city_info <- renderUI({
        h3(paste0(city$name, ", ", city$country))
      })
      
      return(map)
    }
    
    # Load map on load
    output$map <- renderLeaflet(map())
    
    # Refresh map with button
    observeEvent(input$go_btn, {
      output$map <- renderLeaflet(map())
    })
    
    
    
  }
)
