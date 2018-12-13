#################################################
#               Basic Text Analysis             #
#################################################

library(shiny)
library(text2vec)
library(tm)
library(tokenizers)
library(wordcloud)
library(slam)
library(stringi)
library(magrittr)
library(tidytext)
library(dplyr)
library(tidyr)


shinyUI(fluidPage(
  
  titlePanel("Assginmnet 1:Shiny App around the UDPipe NLP workflow "),
  
  # Input in sidepanel:
  sidebarPanel(
    
    fileInput("file", "Upload text file"),
    
    fileInput("udpipefile", "Upload Udpipe file"),
    
    checkboxGroupInput("POS", "POS:",
                       c("Adjective " = "JJ",
                         "Noun" = "NN",
                         "proper noun" ="NNP",
                         "adverb" = "RB",
                          "verb"="VB")
                       ),
    submitButton(text = "Apply Changes", icon("refresh"))
    
  ),
  
  # Main Panel:
  mainPanel( 
    tabsetPanel(type = "tabs",
                #
                tabPanel("Overview",h4(p("How to use this App")),
                         
                         p("To use this app you need a document corpus in txt file format. Make sure each document is separated from another document with a new line character.
                           To do basic Text Analysis in your text corpus, click on Browse in left-sidebar panel and upload the txt file. Once the file is uploaded it will do the computations in 
                           back-end with default inputs and accordingly results will be displayed in various tabs.", align = "justify"),
                         p("If you wish to change the input, modify the input in left side-bar panel and click on Apply changes. Accordingly results in other tab will be refreshed
                           ", align = "Justify"),
                         h5("Note"),
                         p("You might observe no change in the outputs after clicking 'Apply Changes'. Wait for few seconds. As soon as all the computations
                           are over in back-end results will be refreshed",
                           align = "justify"),
                         #, height = 280, width = 400
                         verbatimTextOutput("start")),
                
                tabPanel("First result",h4(p("Output")),
                         
                         
                         #, height = 280, width = 400
                          verbatimTextOutput("data"),
                          verbatimTextOutput("wordcloud")
                         )
                    )
    )
)
  )
