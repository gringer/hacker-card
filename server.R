library(shiny)

shinyServer(function(input, output) {
  
  gridData <- reactiveValues();
  gridData$Labels <- NULL;
  gridData$Dims <- NULL;
  
  makeFile <- function(outfile){
    infile <- tempfile(fileext='.tex');
    outdir <- tempdir();
    infileBase <- sub("\\.tex$","",infile);
    outfileBase <- sub("\\.(png|pdf)$","",outfile);
    faceOptions <- debounce(reactive({input$faceOptions}), 500);
    cName <- debounce(reactive({input$cName}), 500);
    dayJob <- debounce(reactive({input$dayJob}), 500);
    skill <- debounce(reactive({input$skill}), 500);
    optionString <- c(faceOptions(),"female");
    if("male" %in% optionString){
      optionString <- setdiff(optionString, c("male", "female"));
    }
    print(optionString);
    tikzString <- sub(",$","",paste(input$picBase,optionString,sep=",",
                                    collapse=","));
    print(tikzString);
    personName <- ifelse(cName()=="",
                         "Audrey Hacker",cName());
    personJob <- ifelse(dayJob()=="",
                        "Conflict Negotiator",
                        dayJob());
    personSkill <- skill();
    print(personSkill);
    personName <- sub("[%\\].*$","",personName);
    personJob <- sub("[%\\].*$","",personJob);
    personSkill <- sub("[%\\].*$","",personSkill);
    cat(
      "     \\documentclass[11pt,a4paper]{memoir}
      
      \\setstocksize{55mm}{85mm} % UK Stock size
      \\setpagecc{55mm}{85mm}{*}
      \\settypeblocksize{45mm}{75mm}{*}
      \\setulmargins{5mm}{*}{*}
      \\setlrmargins{5mm}{*}{*}
      \\usepackage{xcolor}
      
      \\nonstopmode
      \\setheadfoot{0.1pt}{0.1pt}
      \\setheaderspaces{1pt}{*}{*}
      
      \\checkandfixthelayout[fixed]
      
      \\pagestyle{empty}
      
      \\usepackage{pstricks}
      \\usepackage{xcolor}
      \\usepackage{tikzpeople}
      \\usepackage{tabularx}
      
      \\newcolumntype{L}{>{\\arraybackslash}p{3.5cm}}
      
      \\begin{document}
      \\noindent",
      sprintf("\\textbf{%s}\\\\",personName),
      sprintf("\\tiny %s\\\\", 
              "GovHacker"),"
      \\rule{65mm}{.3mm}\\\\
      \\begin{minipage}[t]{20mm}
      \\vspace{2mm}%",
      paste0("\\tikz{\\node[",tikzString,
             ",minimum height=20mm]{}}"),
      "     \\end{minipage}
      \\hspace{1mm}
      \\begin{minipage}[t]{47mm}
      \\vspace{-0mm}%
      \\begin{flushleft}
      {
      \\
      \\begin{tabular}{lL}",
        sprintf("{\\color{gray}Day Job} & %s\\\\",personJob),
        "\\rule{0pt}{0.5em}\\\\",
        sprintf("\\color{gray}Hacker Skill} & \\multicolumn{1}{m{3.5cm}}{%s}\\\\",personSkill),"
      
      \\vspace*{2mm}
      \\end{tabular}
  }
      \\end{flushleft}
      \\end{minipage}
      \\end{Spacing}
      \\end{document}
      ",
      file=infile, sep="\n");
    system(command = paste("pdflatex","-output-directory",
                           outdir,infile,"-interaction batchmode"),
           ignore.stdout = TRUE);
    unlink(paste0(infileBase,".tex"));
    unlink(paste0(infileBase,".aux"));
    unlink(paste0(infileBase,".log"));
    if(grepl("\\.png$", outfile)){
      system(command = paste("pdftoppm -png",
                             "-singlefile", paste0(infileBase,".pdf"),
                             "-scale-to-x",850,
                             "-scale-to-y",550,outfileBase));
      unlink(paste0(infileBase,".pdf"));
    } else {
      file.rename(paste0(infileBase,".pdf"), outfile);
    }
  }

  output$myImage <- renderImage({
    if(is.null(input$picBase)){
      return();
    }
    # A temp file to save the output.
    # This file will be removed later by renderImage
    outfile <- tempfile(fileext='.png');
    makeFile(outfile);
    
    # Return a list containing the filename
    list(src = outfile,
         contentType = 'image/png',
         width = 425,
         height = 275,
         alt = "This text appears if the image can't be displayed")
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
      personName <- ifelse(input$cName=="",
                           "Audrey Hacker",input$cName);
      fName <- sprintf("hackerCard_%s_%s.pdf",personName,
                       format(Sys.Date(),"%Y-%b-%d"));
      return(fName);
      },
    content = function(con){
      makeFile(con);
    },
    contentType = "text/pdf"
  );
  
  output$hackerCard.png <- downloadHandler(
    filename = function(){
      personName <- ifelse(input$cName=="",
                           "Audrey Hacker",input$cName);
      fName <- sprintf("hackerCard_%s_%s.png",personName,
                       format(Sys.Date(),"%Y-%b-%d"));
      cat("Writing to file: ",fName, "\n");
      return(fName);
    },
    content = function(con){
      makeFile(con);
    },
    contentType = "image/png"
  );
  
  
})
