library(shiny)

shinyUI(fluidPage(
  titlePanel("GovHacker Card"),
  sidebarLayout(
    sidebarPanel(
      textInput("cName","Name", placeholder = "Audrey Hacker"),
      textInput("dayJob","Day Job", placeholder = "Conflict Resolution Negotiator"),
      selectInput("picBase","Image Name",
                  choices=c("alice", "bob", "bride", "builder",
                            "businessman", "charlie", "chef",
                            "conductor", "cowboy", "criminal",
                            "dave", "devil", "duck", "graduate",
                            "groom", "guard", "jester", "judge",
                            "maninblack", "mexican", "nun", "nurse",
                            "physician", "pilot", "police", "priest",
                            "sailor", "santa", "surgeon")),
      fluidRow(
        column(6,downloadButton("hackerCard.pdf", label="Make PDF"),
               downloadButton("hackerCard.png", label="Make PNG"))),
      tags$div(tags$label("Hacker Skill")),
      tags$textarea(id="skills", rows=10, cols=30)
      
    ),
    mainPanel(
       imageOutput("myImage", inline = TRUE)
    )
  )
))