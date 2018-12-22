############################################################################
#     Assginmnet 1:Shiny App around the UDPipe NLP workflow          #
############################################################################

library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(udpipe)

shinyServer(function(input, output,session) {
  set.seed=2092014   
  options(shiny.maxRequestSize=30*1024^2)
  
  dataset <- reactive({
    
    if (is.null(input$file)) {# locate 'file1' from ui.R
      return(NULL) } 
    else{
      Data <- readLines(input$file$datapath)
      Data  =  text.clean(Data)
      return(Data)
    }
  })
  
  model_file = reactive({
    file1<-input$udpipefile
    if (is.null(file1)) {
        return(NULL) 
      } else{
        model_file = udpipe_load_model(file1$datapath)
        return(model_file)
      }
  })
  
  annotation = reactive({
    x <- udpipe_annotate(model_file(),x = dataset())
    x <- as.data.frame(x)
    return(x)
  })
  
  selectedPOS.obj = reactive({
    return (input$POSselected)
  })
  
  cooccurrence.obj <- reactive({
    x<-annotation()
    cooccurrence <- cooccurrence(x$lemma, relevant = x$upos %in% selectedPOS.obj(), skipgram = 1)
    return (cooccurrence)
  })
  
  
  output$selectedPOS  = renderPrint({
    selectedPOS.obj()
  })
  
  output$datatableOutput = renderDataTable({
    if(is.null(input$file) || is.null(input$udpipefile) )
    {
      return(NULL)
    }
    else{
      out = annotation()[,-4]
      return(out)
    }
  })
  
  output$posFreq = renderPlot({
    if(is.null(input$file) || is.null(input$udpipefile) )
    {
      return (NULL)
    }else{
      x<-annotation()
      stats <- txt_freq(x$upos)
      stats$key <- factor(stats$key, levels = rev(stats$key))
      barchart(key ~ freq, data = stats, col = "blue", 
               xlab = "Freq")
    }
      
  })
  
  
  
  output$mostOcc  = renderPlot({
    if(is.null(input$file) || is.null(input$udpipefile) )
    {
      return (NULL)
    }else{
      x<-annotation()
      selected<-selectedPOS.obj()
      stats <- subset(x, x$upos %in% selected) 
      stats <- txt_freq(stats$token)
      stats$key <- factor(stats$key, levels = rev(stats$key))
      barchart(key ~ freq, data = head(stats, 20), col = "green", 
               main = "Most occurring based on POS", xlab = "Freq")
    }
    
  })
  
  
  output$wordCloudFre  = renderPlot({
    if(is.null(input$file) || is.null(input$udpipefile) )
    {
      return (NULL)
    }else{
      x<-annotation()
      selected<-selectedPOS.obj()
      subset_cl = x %>% subset(., upos %in% selected) 
      subset_cl
      sub_fre = txt_freq(subset_cl$lemma)
      if(is.null(sub_fre))
        {
          return(NULL)
        }
        else{
          wordcloud(sub_fre$key, sub_fre$freq,
                  scale = c(4, 1),
                  min.freq = 10,
                  max.words = 50,
                  colors = brewer.pal(8, "Dark2"))
        }
      }
  })
  
  wordcounts = reactive({
    return(dtm.word.count(dtm_tcm()$dtm))
  }) 
  
  output$wordcloud <- renderPlot({
    if(is.null(input$file) || is.null(input$udpipefile) )
    {
      return (NULL)
    }else{
      tsum = wordcounts()
      tsum = tsum[order(tsum, decreasing = T)]
      dtm.word.cloud(count = tsum,max.words = input$max,title = 'Term Frequency Wordcloud')
    }
  })
  
  output$cooccureance <- renderPlot({
    if(is.null(input$file) || is.null(input$udpipefile) )
    {
      return (NULL)
    }else{
      wordnetwork <- head(cooccurrence.obj(), 15)
      wordnetwork <- graph_from_data_frame(wordnetwork)
      ggraph(wordnetwork, layout = "fr") +
        geom_edge_link(aes(width = cooc, edge_alpha = cooc)) +
        geom_node_text(aes(label = name), col = "red", size = 10) +
        theme_graph(base_family = "Arial Narrow" , title_face = "bold" , text_colour = "black" ,base_size = 11,title_margin = 10) +
        labs(title = "Co-occurance of a word")
    }
  })
  
  
  output$downloadData1 <- downloadHandler(
    filename = function() { "Nokia_Lumia_reviews.txt" },
    content = function(file1) {
      writeLines(readLines("data/Nokia_Lumia_reviews.txt"), file1)
    }
  )
  
  
  output$downloadData2 <- downloadHandler(
    filename = function() { "english-ud-2.0-170801.udpipe" },
    content = function(file2) {
      writeLines(readLines("data/english-ud-2.0-170801.udpipe"), file2)
    }
  )
})