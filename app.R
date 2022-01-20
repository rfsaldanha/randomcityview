library(shiny)
library(shinyMobile)
library(maps)

# Cities data base
cities <- maps::world.cities


# Get random city coordinates function
random_city <- function(cities_db = cities){
  res <- cities_db[sample(1:nrow(cities_db), 1),]
  return(res)
}



shinyApp(
  ui = f7Page(
    title = "Random city view",
    f7SingleLayout(
      navbar = f7Navbar(
        title = "Random city view",
        hairline = TRUE,
        shadow = TRUE
      ),
      toolbar = f7Toolbar(
        position = "bottom",
        f7Link(label = "Link 1", href = "https://www.google.com"),
        f7Link(label = "Link 2", href = "https://www.google.com")
      ),
      # main content
      f7Shadow(
        intensity = 16,
        hover = TRUE,
        f7Card(
          title = "Card header"
        )
      )
    )
  ),
  server = function(input, output) {
    
  }
)