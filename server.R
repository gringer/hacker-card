#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(digest)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  gridData <- reactiveValues();
  gridData$Labels <- NULL;
  gridData$Dims <- NULL;

  drawGrid <- function(){
    gridDims <- gridData$Dims;
    gridLabels <- gridData$Labels;
    par(mar=c(4,4,4,4));
    plot(NA, xlim=c(0,1), ylim=c(0,1), axes=FALSE,
         main=sprintf("%s Conference Bingo\n[Word list hash: %s]",
                      input$cName, gridData$Digest), 
         xlab="", ylab="", cex.main=2);
    rect(0, 0, 1, 1, lwd=3);
    for(xp in (1:gridDims[1]-1)){
      for(yp in (1:gridDims[2]- 1)){
        rect(xp/gridDims[1], yp/gridDims[2], 
             (xp+1)/gridDims[1], (yp+1)/gridDims[2]);
        gridText <- gridLabels[yp*gridDims[2]+xp+1];
        text((xp+0.5)/gridDims[1], (yp+0.5)/gridDims[2],
             gridText, cex = min(3,max(0.5,(15/gridDims[1])/sqrt(nchar(gridText)))));
      }
    }
  }
   
  output$bingoGrid <- renderPlot({
    wordList <- sort(unlist(strsplit(input$wordList,"\n")));
    ## make labels
    gridDims <- as.numeric(unlist(strsplit(input$style,"x")));
    gridLabels <- sample(wordList, prod(gridDims), replace = length(wordList) < prod(gridDims));
    gridLabels[ceiling(length(gridLabels)/2)] <- paste0("FREE\n",input$freeWord);
    gridData$Dims <- gridDims;
    gridData$Labels <- gridLabels;
    gridData$Digest <- substring(digest(c(input$freeWord, wordList), "sha512"),1,12);
    ## draw grid
    drawGrid();
    box(which="figure");
  }, width=600, height=600)
  
  output$bingoBoard.pdf <- downloadHandler(
    filename = function(){
      fName <- sprintf("bingo_%s_%s_%s.pdf",input$style,
                       gsub(" ","-",input$cName),
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
  
  output$bingoBoard.png <- downloadHandler(
    filename = function(){
      fName <- sprintf("bingo_%s_%s_%s.png",input$style,
                       gsub(" ","-",input$cName),
                       format(Sys.Date(),"%Y-%b-%d"));
      cat("Writing to file: ",fName, "\n");
      return(fName);
    },
    content = function(con){
      png(con, width=1024, height=1024, pointsize = 24);
      drawGrid();
      dev.off();
    },
    contentType = "image/png"
  );
  
  
})
