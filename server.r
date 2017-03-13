#server.r
#setwd("c:/Users/Travis/Desktop/Coursera Data Science/Data Science Capstone (9)")
 
library(tm)
library(RWeka)
library(qdap)
library(stringi)
library(shiny)
library(slam)

#cname.2 <- file.path("./texts_2/")
#docs.2 <- Corpus(VectorSource(docs))
#docs.2 <- tm_map(docs.2, removePunctuation)
#docs.2 <- tm_map(docs.2, removeNumbers)
#docs.2 <- tm_map(docs.2, tolower)
#docs.2 <- tm_map(docs.2, removeWords, "./CurseWords.txt")
#docs.2 <- tm_map(docs.2, stripWhitespace)
#docs.2 <- tm_map(docs.2, PlainTextDocument)
#docs.test <- docs.2

docs.test <- readRDS("docs.test.rds")

unigram.token <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
bigram.token <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min=3, max=3))
quadgram.token <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))

#code if someone enters nothing for prediction
#tdm.uni <- TermDocumentMatrix(docs.test, control = list(word_length = c(3,20)))   
#uni.matrix <- as.matrix(tdm.uni)
#sort.uni <- as.data.frame(sort(rowSums(uni.matrix), decreasing = TRUE))
#a0 <- c(head(rownames(sort.uni)))

#code if someone enters unigram for prediction
#tdm.bi <- removeSparseTerms(TermDocumentMatrix(Corpus(VectorSource(docs.test)), control = list(tokenize = bigram.token)), .20)
#tdm.bi$dimnames$Terms$w1 <- sapply(strsplit(as.character(tdm.bi$dimnames$Terms), ' '), "[", 1)
#tdm.bi$dimnames$Terms$w2 <- sapply(strsplit(as.character(tdm.bi$dimnames$Terms), ' '), "[", 2)

##code if someone enters bigram for prediction

#tdm.tri <- removeSparseTerms(TermDocumentMatrix(Corpus(VectorSource(docs.test)), control = list(tokenize = TrigramTokenizer)), .20)
#tdm.tri$dimnames$Terms$w1 <- sapply(strsplit(as.character(tdm.tri$dimnames$Terms), ' '), "[", 1)
#tdm.tri$dimnames$Terms$w2 <- sapply(strsplit(as.character(tdm.tri$dimnames$Terms), ' '), "[", 2)
#tdm.tri$dimnames$Terms$w3 <- sapply(strsplit(as.character(tdm.tri$dimnames$Terms), ' '), "[", 3)

##code if someone enters trigram for prediction

#tdm.quad <- removeSparseTerms(TermDocumentMatrix(Corpus(VectorSource(docs.test)), control = list(tokenize = quadgram.token)), .20)
#tdm.quad$dimnames$Terms$w1 <- sapply(strsplit(as.character(tdm.quad$dimnames$Terms), ' '), "[", 1)
#tdm.quad$dimnames$Terms$w2 <- sapply(strsplit(as.character(tdm.quad$dimnames$Terms), ' '), "[", 2)
#tdm.quad$dimnames$Terms$w3 <- sapply(strsplit(as.character(tdm.quad$dimnames$Terms), ' '), "[", 3)
#tdm.quad$dimnames$Terms$w4 <- sapply(strsplit(as.character(tdm.quad$dimnames$Terms), ' '), "[", 4)

#tdm = as.matrix(TermDocumentMatrix(docs.test, control = list(wordLengths = c(1, 20))))
#tdm <- as.matrix(slam::row_sums(tdm, na.rm = T))

tdm.uni <- readRDS("tdm.uni.rds")
tdm.bi <- readRDS("tdm.bi.rds")
tdm.tri <- readRDS("tdm.tri.rds")
tdm.quad <- readRDS("tdm.quad.rds")
tdm <- readRDS("tdm.rds")


shinyServer(function(input, output, session) {
    
    output$text <- renderText({ paste("You have submitted the word(s):", input$text) })
    
    output$text1 <- renderText({
        
        elems <- unlist(strsplit(input$text, " ") )
        
        
        if (as.numeric(word_count(input$text) == 1) && any(elems[1] == tdm.bi$dimnames$Terms$w1)) {
            
            a1 <- subset(tdm.bi$dimnames$Terms, tdm.bi$dimnames$Terms$w1 == elems[1])
            a1.1 <- stri_extract_last_words(a1)
            
            tdm.predict <- as.matrix(sort(tdm[a1.1, ], decreasing = TRUE))
            
            output$text1 <- renderText({ c("This application predicts the next word will be: ", rownames(tdm.predict)[[1]])})
            
        }  else if (as.numeric(word_count(input$text) == 2) && any(elems[1] == tdm.tri$dimnames$Terms$w1, 
                                                                   elems[2] == tdm.tri$dimnames$Terms$w2)) {
            
            a2 <- subset(tdm.tri$dimnames$Terms, tdm.tri$dimnames$Terms$w1 == elems[1] & 
                             tdm.tri$dimnames$Terms$w2 == elems[2])
            a2.1 <- stri_extract_last_words(a2)
            
            tdm.predict <- as.matrix(sort(tdm[a2.1, ], decreasing = TRUE))
            
            output$text1 <- renderText({ c("This application predicts the next word will be: ", rownames(tdm.predict)[[1]])})
            
        } else if (as.numeric(word_count(input$text) == 3) && any(elems[1] == tdm.quad$dimnames$Terms$w1, 
                                                                  elems[2] == tdm.quad$dimnames$Terms$w2, 
                                                                  elems[3] == tdm.quad$dimnames$Terms$w3)) {
            
            
            a3 <- subset(tdm.quad$dimnames$Terms, tdm.quad$dimnames$Terms$w1 == elems[1] & 
                             tdm.quad$dimnames$Terms$w2 == elems[2] & 
                             tdm.quad$dimnames$Terms$w3 == elems[3])
            a3.1 <- stri_extract_last_words(a3)
            
            tdm.predict <- as.matrix(sort(tdm[a3.1, ], decreasing = TRUE))
            
            output$text1 <- renderText({ c("This application predicts the next word will be: ", rownames(tdm.predict[[1]])) })			
            
        }  else {
        
            #freq <- as.matrix(sort(findFreqTerms(tdm.uni, lowfreq = 15000, highfreq = Inf)))
            freq <- readRDS("freq.rds")
            output$text1 <- renderText({ c("This application predicts the next word will be: ", freq[1,1]) }) 
        
        }
        
    })
    
})
