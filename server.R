#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  set.seed=13120018   
  
  dataset <- reactive({
    if (is.null(input$file)) {return(NULL)}
    else {
      text  = readLines(input$file$datapath)
      text = text[text!=""]
      
      if (length(text[text !=""]) == 0 ) stop (print("Null Vector :( "))
      
      if (length(text) == 1) {
        textdf = data_frame(text0 = text) %>% 
          unnest_tokens(text, text0, token = "sentences")
      } else {
        textdf = data_frame(text = text)  
      }
      
    }
    return(textdf)
  })
  
  
  dtm_tcm =  reactive({
    
    textb = dataset()$Document
    ids = dataset()$Doc.id
    
    dtm.tcm = dtm.tcm.creator(text = textb,
                              id = ids,
                              std.clean = TRUE,
                              std.stop.words = TRUE,
                              stop.words.additional = unlist(strsplit(input$stopw,",")),
                              bigram.encoding = TRUE,
                              # bigram.min.freq = 20,
                              min.dtm.freq = input$freq,
                              skip.grams.window = 10)
    
    # tcm = dtm.tcm$tcm
    dtm_tcm_obj = list(dtm = dtm)#, tcm = tcm)
  })
  
  wordcounts = reactive({
    return(dtm.word.count(dtm_tcm()$dtm))
  }) 
  
  output$wordcloud <- renderPlot({
    tsum = wordcounts()
    tsum = tsum[order(tsum, decreasing = T)]
    dtm.word.cloud(count = tsum,max.words = input$max,title = 'Term Frequency Wordcloud')
    
  })
  
  output$data <- renderPrint({
    selected=input$POS
    selected
  })
  
})
