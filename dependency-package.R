########################################################
# Assginment 1:Shiny App around the UDPipe NLP workflow 
#### Group details :							
#### Kannan Nagarajan (PG ID: 11810122)
#### Magesh Kuppusamy (PG ID: 11810135)
#### Anand Raman (PG ID: 11810116)
#########################################################
try(require(shiny) || install.packages("shiny"))
if (!require(udpipe)){install.packages("udpipe")}
if (!require(textrank)){install.packages("textrank")}
if (!require(lattice)){install.packages("lattice")}
if (!require(igraph)){install.packages("igraph")}
if (!require(ggraph)){install.packages("ggraph")}
if (!require(wordcloud)){install.packages("wordcloud")}
try(require(fmsb)||install.packages("fmsb"))

library(udpipe)
library(textrank)
library(wordcloud)
library(stringr)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(udpipe)
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
