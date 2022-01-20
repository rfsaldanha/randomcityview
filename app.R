library(shiny)
library(shinyMobile)
library(maps)
library(leaflet)
library(leaflet.providers)

# Cities data base
cities <- maps::world.cities

# Base map providers
base_map_providers <- providers_default()[["providers"]]

# Get random city coordinates function
random_city <- function(cities_db = cities, country = "Any"){
  if(country == "Any"){
    res <- cities_db[sample(1:nrow(cities_db), 1),]
  } else {
    res <- subset(cities_db, country.etc == country)
    res <- res[sample(1:nrow(res), 1),]
  }
  
  return(res)
}





shinyApp(
  ui = f7Page(
    title = "Random city view",
    f7SingleLayout(
      navbar = f7Navbar(
        title = uiOutput(outputId = "city_info"),
        hairline = TRUE,
        shadow = TRUE
      ),
      toolbar = f7Toolbar(
        position = "bottom",
        f7SmartSelect(
          inputId = "base_map",
          label = "Base map",
          selected = "Esri.WorldImagery",
          choices = base_map_providers,
          openIn = "popup"
        ),
        f7Button(inputId = "go_btn", label = "Change!", rounded = TRUE, outline = TRUE, fill = FALSE),
        f7SmartSelect(
          inputId = "country",
          label = "Country",
          selected = "Any",
          choices = c("Any", sort(unique(cities$country.etc))),
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
        addProviderTiles(
          input$base_map,
          options = providerTileOptions(noWrap = TRUE)
        ) |>
        setView(lng = city$long, lat = city$lat, zoom = 16)
      
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