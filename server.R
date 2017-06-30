library(shiny)
library(digest)

## Titles: 

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  gridData <- reactiveValues();
  gridData$Labels <- NULL;
  gridData$Dims <- NULL;

  output$myImage <- renderImage({
    if(is.null(input$picBase)){
      return();
    }
    # A temp file to save the output.
    # This file will be removed later by renderImage
    outdir <- tempdir();
    infile <- tempfile(fileext='.tex');
    outfile <- tempfile(fileext='.png');
    infileBase <- sub("\\.tex$","",infile);
    outfileBase <- sub("\\.png$","",outfile);
    tikzString <- paste(input$picBase,"female","shirt=red",
                        "mirrored",sep=",");
    cat("\\documentclass{article}",
        "\\usepackage[paperwidth=2cm,paperheight=2cm,margin=0cm]{geometry}",
        "\\usepackage{tikzpeople}",
        "\\begin{document}",
        "\\begin{center}",
        paste0("\\tikz{\\node[",tikzString,
               ",minimum height=\\textheight-6pt]{}}"),
        "\\end{center}",
        "\\end{document}",
        file=infile, sep="\n");
    system(command = paste("pdflatex","-output-directory",outdir,infile), 
           ignore.stdout = TRUE);
    system(command = paste("pdftoppm -png",
                           "-singlefile", paste0(infileBase,".pdf"),
                           "-scale-to-x",250,
                           "-scale-to-y",250,outfileBase));
    unlink(paste0(infileBase,".tex"));
    unlink(paste0(infileBase,".aux"));
    unlink(paste0(infileBase,".pdf"));
    
    # Return a list containing the filename
    list(src = outfile,
         contentType = 'image/png',
         width = 250,
         height = 250,
         alt = "This is alternate text")
  }, deleteFile = TRUE)
  
     
  output$cardText <- renderUI({
    list(
      tags$div(style="border: 1px solid; padding: 1em",
        tags$h1(style="text-align:center", "GovHacker Card"),
        tags$h2("Name:"), input$cName,
        tags$h2("Day job:"), input$dayJob,
        tags$h2("Hacker skill:"), input$skills,
        imageOutput("myImage"),
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
