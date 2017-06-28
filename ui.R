library(shiny)

shinyUI(fluidPage(
  titlePanel("Hacker Card"),
  sidebarLayout(
    sidebarPanel(
      textInput("cName","Name", placeholder = "Audrey Hacker"),
      textInput("dayJob","Day Job", placeholder = "Conflict Resolution Negotiator"),
      fluidRow(
        column(6,radioButtons("style", "Hacker Style", choices = c("3x3","5x5"))),
        column(6,downloadButton("hackerCard.pdf", label="Make PDF"),
               downloadButton("hackerCard.png", label="Make PNG"))),
      tags$div(tags$label("Hacker Skill")),
      tags$textarea(id="skills", rows=10, cols=30)
      
    ),
    mainPanel(
       htmlOutput("cardText", inline = TRUE)
    )
  )
))