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
library(igraph)
library(ggraph)
library(ggplot2)


shinyUI(fluidPage(
  
  titlePanel("Assginmnet 1:Shiny App around the UDPipe NLP workflow "),
  
  # Input in sidepanel:
  sidebarPanel(
    
    fileInput("file", "Upload text file"),
    
    fileInput("udpipefile", "Upload Udpipe file"),
    
    checkboxGroupInput("POSselected", "POS:",
                       c("Adjective " = "ADJ",
                         "Noun" = "NOUN",
                         "proper noun" ="PRON",
                         "adverb" = "ADV",
                          "verb"="VERB")
                       ,
                       selected = c("ADJ","NOUN","PRON")
                       ),
    submitButton(text = "Apply Changes", icon("refresh"))
    
  ),
  
  # Main Panel:
  mainPanel( 
    tabsetPanel(type = "tabs",
                
                tabPanel("Overview",h4(p("How to use this App")),
                         
                         p("To use this app you need a document corpus in txt file format. Make sure each document is separated from another document with a new line character.
                           To do basic NLP function in your text corpus, click on Browse in left-sidebar panel and upload the txt file of a particular language and Udpipe file of that particular language. Once the file is uploaded it will do the computations in 
                           back-end with default inputs and accordingly results will be displayed in various tabs.", align = "justify"),
                         p("If you wish to change the input, modify the input in left side-bar panel and click on Apply changes. Accordingly results in other tab will be refreshed
                           ", align = "Justify"),
                         h5("Note"),
                         p("You might observe no change in the outputs after clicking 'Apply Changes'. Wait for few seconds. As soon as all the computations
                           are over in back-end results will be refreshed",
                           align = "justify"),
                        
                         downloadButton('downloadData1', 'Download Nokia Lumia reviews txt file'),br(),br(),
                         p("Please note that download will not work with RStudio interface. Download will work only in web-browsers. So open this app in a web-browser and then download the example file. For opening this app in web-browser click on \"Open in Browser\" "),
                         br(),
                         
                         downloadButton('downloadData2', 'Download english udpipe file'),br(),br(),
                         p("Please note that download will not work with RStudio interface. Download will work only in web-browsers. So open this app in a web-browser and then download the example file. For opening this app in web-browser click on \"Open in Browser\" "),
                         br(),
                         
                         verbatimTextOutput("start")),
                    
                       tabPanel("Table of annotated documents", 
                         dataTableOutput('datatableOutput')),      
                
                
                        tabPanel("Frequency of occurrence",
                                 h4(p("UPOS (Universal Parts of Speech)\n frequency of occurrence")),
                          plotOutput('posFreq')
                         ),
                        
                        tabPanel("Most occurance",
                                 h4(p("Most occurance of a word based on the POS selection from checkbox")),
                         verbatimTextOutput("selectedPOS"),
                         plotOutput('mostOcc'),
                         h4(p("Word Cloud based on the occurance")),
                         plotOutput('wordCloudFre')
                        ) ,
                        
                       tabPanel('co-occurrences',h4(p("co-occurrences")),
                                plotOutput('cooccureance')
                        )
                    
                    )
    )
  )
)
