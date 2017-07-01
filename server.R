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
    tikzString <- paste(input$picBase,"female","shirt=red",sep=",");
    personName <- ifelse(input$cName=="",
                         "Audrey Hacker",input$cName);
    personJob <- ifelse(input$dayJob=="",
                        "Conflict Resolution Negotiator",input$dayJob);
    personSkills <- gsub("\n","\\\\\n",input$skills);
    cat(
"     \\documentclass[11pt,a4paper]{memoir}
      
      \\setstocksize{55mm}{85mm} % UK Stock size
      \\setpagecc{55mm}{85mm}{*}
      \\settypeblocksize{45mm}{75mm}{*}
      \\setulmargins{5mm}{*}{*}
      \\setlrmargins{5mm}{*}{*}
      \\usepackage{xcolor}
      
      \\setheadfoot{0.1pt}{0.1pt}
      \\setheaderspaces{1pt}{*}{*}

      \\checkandfixthelayout[fixed]
      
      \\pagestyle{empty}
      
      \\usepackage{pstricks}
      \\usepackage{xcolor}
      \\usepackage{tikzpeople}

      \\begin{document}
      \\begin{Spacing}{0.75}%
      \\noindent",
sprintf("\\textbf{%s}\\\\",personName),
      sprintf("\\tiny %s\\\\", 
              "GovHacker"),"
      \\rule{74mm}{.3mm}\\\\
      \\begin{minipage}[t]{20mm}
      \\vspace{-0mm}%",
      paste0("\\tikz{\\node[",tikzString,
             ",minimum height=28mm]{}}"),
"     \\end{minipage}
      \\hspace{1mm}
      \\begin{minipage}[t]{47mm}
      \\vspace{-0mm}%
      \\begin{flushleft}
      {\\scriptsize
        \\begin{Spacing}{1}%",
        sprintf("\\textbf{%s}\\\\",personJob),
        sprintf("\\hspace{5mm}%s\\vspace{2mm}\\\\",personSkills),"
        \\end{Spacing}
      }
      {\\tiny
        \\begin{tabular}{rl}
        {\\color{gray}web} & https://fqdn/\\\\
        {\\color{gray}email} & helena@univ.edu\\\\
        {\\color{gray}email} & hxr42@gmail.com\\\\
        {\\color{gray}mobile} & +1 123 456 7890\\\\
        \\end{tabular}
        \\vspace*{2mm}
      }
      \\end{flushleft}
      \\end{minipage}
      \\end{Spacing}
      \\end{document}
",
      file=infile, sep="\n");
    system(command = paste("pdflatex","-output-directory",
                           outdir,infile,"-interaction nonstopmode"),
           ignore.stdout = TRUE);
    system(command = paste("pdftoppm -png",
                           "-singlefile", paste0(infileBase,".pdf"),
                           "-scale-to-x",850,
                           "-scale-to-y",550,outfileBase));
    unlink(paste0(infileBase,".tex"));
    unlink(paste0(infileBase,".aux"));
    unlink(paste0(infileBase,".pdf"));
    
    # Return a list containing the filename
    list(src = outfile,
         contentType = 'image/png',
         width = 425,
         height = 275,
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
