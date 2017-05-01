library(shiny)

defaultWords = c("Unpublished", "Megabase", "Game-changer", "Obsolete", "Error rate",
                 "N50", "CRISPR", "R9.5", "1D²", "Epigenetic", "Equality",
                 "E. coli", "Lambda", "Pilot study", "Poretools", "Albacore",
                 "Full-length contig", "Wet lab", "Dry lab", "Bioinformatician",
                 "BioRXiv", "Twitter", "Blog", "Back to basics", "Canu",
                 "Clinic", "Field");

shinyUI(fluidPage(
  titlePanel("Conference Bingo"),
  sidebarLayout(
    sidebarPanel(
      textInput("cName","Conference Name", value="London Calling 2017"),
      fluidRow(
        column(6,radioButtons("style", "Bingo Style", choices = c("3x3","5x5"))),
        column(6,downloadButton("bingoBoard.pdf", label="Make PDF"),
               downloadButton("bingoBoard.png", label="Make PNG"))),
      textInput("freeWord","Free Word", value="Grab-bag trinket"),
      tags$div(tags$label("Word List")),
      tags$textarea(id="wordList", rows=10, cols=30, 
                    paste(sort(defaultWords),collapse="\n"))
      
    ),
    mainPanel(
       plotOutput("bingoGrid", inline = TRUE)
    )
  )
))
