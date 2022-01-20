library(shiny)
library(shinyMobile)



shinyApp(
  ui = f7Page(
    title = "My app",
    f7SingleLayout(
      navbar = f7Navbar(
        title = "Single Layout",
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