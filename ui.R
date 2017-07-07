library(shiny)

shinyUI(fluidPage(
  titlePanel("GovHacker Card"),
  sidebarLayout(
    sidebarPanel(
      fluidRow(column(6,textInput("cName","Name", 
                                  placeholder = "Audrey Hacker")),
               column(6,selectInput(
                 "picBase","Image Name",
                 choices=c("alice", "bob", "bride", "builder",
                           "businessman", "charlie", "chef",
                           "conductor", "cowboy", "criminal",
                           "dave", "devil", "duck", "graduate",
                           "groom", "guard", "jester", "judge",
                           "maninblack", "mexican", "nun", "nurse",
                           "person",
                           "physician", "pilot", "police", "priest",
                           "sailor", "santa", "surgeon"))
               )),
      checkboxGroupInput("faceOptions","Options",
                         choices = c("evil","good","male","mirrored",
                                     "monitor","saturated","shield",
                                     "sword")),
      textInput("dayJob","Day Job", placeholder = "Conflict Negotiator"),
      fluidRow(
        column(6,tags$div(tags$label("Hacker Skill")),
               tags$textarea(id="skill", rows=3, cols=20)),
        column(3,downloadButton("hackerCard.pdf", label="Make PDF"),
               downloadButton("hackerCard.png", label="Make PNG")))
      
    ),
    mainPanel(
       imageOutput("myImage", inline = TRUE)
    )
  )
))