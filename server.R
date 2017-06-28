library(shiny)
library(digest)

## Titles: 

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  gridData <- reactiveValues();
  gridData$Labels <- NULL;
  gridData$Dims <- NULL;

  drawPlot <- function(){
    gridDims <- gridData$Dims;
    par(mar=c(4,4,4,4));
    plot(NA, xlim=c(0,1), ylim=c(0,1), axes=FALSE,
         main="Hacker Card", 
         xlab="", ylab="", cex.main=2);
    rect(0, 0, 1, 1, lwd=3);
    for(xp in (1:gridDims[1]-1)){
      for(yp in (1:gridDims[2]- 1)){
        rect(xp/gridDims[1], yp/gridDims[2], 
             (xp+1)/gridDims[1], (yp+1)/gridDims[2]);
      }
    }
    text(0,0,"Name");
    mtext(1, 1, cex=0.71,
          text = "http://card.gringene.org [source: https://github.com/gringer/hacker-card]");
    box(which="figure");
  }
   
  output$cardText <- renderUI({
    list(
      tags$div(style="border: 1px solid; padding: 1em",
        tags$h1(style="text-align:center", "Hacker Card"),
        tags$h2("Name:"), input$cName,
        tags$h2("Day job:"), input$dayJob,
        tags$h2("Hacker skill:"), input$skills,
        tags$p("Make your own at ",
               tags$a(href="http://card.gringene.org",
               "card.gringene.org"))
      ));
  })
  
  output$hackerCard.pdf <- downloadHandler(
    filename = function(){
      fName <- sprintf("hackerCard_%s_%s.pdf",input$cName,
                       format(Sys.Date(),"%Y-%b-%d"));
      cat("Writing to file: ",fName, "\n");
      return(fName);
      },
    content = function(con){
      pdf(con, width=8, height=8);
      drawGrid();
      dev.off();
    },
    contentType = "text/pdf"
  );
  
  output$hackerCard.png <- downloadHandler(
    filename = function(){
      fName <- sprintf("hackerCard_%s_%s.png",input$cName,
                       format(Sys.Date(),"%Y-%b-%d"));
      cat("Writing to file: ",fName, "\n");
      return(fName);
    },
    content = function(con){
      png(con, width=1024, height=1024, pointsize = 18);
      drawGrid();
      dev.off();
    },
    contentType = "image/png"
  );
  
  
})
