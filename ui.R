library(shiny)

shinyUI(fluidPage(
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
      tags$a(href="https://www.meetup.com/Wellington-R-Users-Group-WRUG/events/243964046/",
             actionButton("visitButton", label = "WRUG Meetup Page")),
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
      titlePanel("GovHacker Card"),       
       tags$a(href="https://github.com/gringer/hacker-card",
              tags$img(style="position: absolute; top: 0; right: 0; border: 0;",
                  alt="Fork me on GitHub",
                  src="https://s3.amazonaws.com/github/ribbons/forkme_right_green_007200.png")),
       imageOutput("myImage", inline = TRUE)
    )
  )
))
