#server.r
#setwd("c:/Users/Travis/Desktop/Coursera Data Science/Data Science Capstone (9)")

library(tm)
library(RWeka)
library(qdap)
library(stringi)
library(shiny)
library(slam)

#combine blogs.2, news.2 and twitter.2 into single df (https://psychwire.wordpress.com/2011/06/03/merge-all-files-in-a-directory-using-r-into-a-single-dataframe/)
#take df and make docs.2 corpus (https://www.quora.com/How-do-you-create-a-corpus-from-a-data-frame-in-R)


cname.2 <- file.path("./texts_2/")
docs.2 <- Corpus(DirSource(cname.2))
docs.2 <- tm_map(docs.2, removePunctuation)
docs.2 <- tm_map(docs.2, removeNumbers)
docs.2 <- tm_map(docs.2, tolower)
docs.2 <- tm_map(docs.2, removeWords, "./CurseWords.txt")
docs.2 <- tm_map(docs.2, stripWhitespace)
docs.2 <- tm_map(docs.2, PlainTextDocument)

docs.test <- docs.2

#code if someone enters nothing for prediction
tdm.uni <- TermDocumentMatrix(docs.test, control = list(word_length = c(3,20)))   
uni.matrix <- as.matrix(tdm.uni)
sort.uni <- as.data.frame(sort(rowSums(uni.matrix), decreasing = TRUE))
a0 <- c(head(rownames(sort.uni)))

#code if someone enters unigram for prediction
tdm.bi <- removeSparseTerms(TermDocumentMatrix(Corpus(VectorSource(docs.test)), control = list(tokenize = bigram.token)), .20)
tdm.bi$dimnames$Terms$w1 <- sapply(strsplit(as.character(tdm.bi$dimnames$Terms), ' '), "[", 1)
tdm.bi$dimnames$Terms$w2 <- sapply(strsplit(as.character(tdm.bi$dimnames$Terms), ' '), "[", 2)

##code if someone enters bigram for prediction

tdm.tri <- removeSparseTerms(TermDocumentMatrix(Corpus(VectorSource(docs.test)), control = list(tokenize = TrigramTokenizer)), .20)
tdm.tri$dimnames$Terms$w1 <- sapply(strsplit(as.character(tdm.tri$dimnames$Terms), ' '), "[", 1)
tdm.tri$dimnames$Terms$w2 <- sapply(strsplit(as.character(tdm.tri$dimnames$Terms), ' '), "[", 2)
tdm.tri$dimnames$Terms$w3 <- sapply(strsplit(as.character(tdm.tri$dimnames$Terms), ' '), "[", 3)

##code if someone enters trigram for prediction

tdm.quad <- removeSparseTerms(TermDocumentMatrix(Corpus(VectorSource(docs.test)), control = list(tokenize = quadgram.token)), .20)
tdm.quad$dimnames$Terms$w1 <- sapply(strsplit(as.character(tdm.quad$dimnames$Terms), ' '), "[", 1)
tdm.quad$dimnames$Terms$w2 <- sapply(strsplit(as.character(tdm.quad$dimnames$Terms), ' '), "[", 2)
tdm.quad$dimnames$Terms$w3 <- sapply(strsplit(as.character(tdm.quad$dimnames$Terms), ' '), "[", 3)
tdm.quad$dimnames$Terms$w4 <- sapply(strsplit(as.character(tdm.quad$dimnames$Terms), ' '), "[", 4)


tdm = as.matrix(TermDocumentMatrix(docs.test, control = list(wordLengths = c(1, 20))))
tdm <- as.matrix(slam::row_sums(tdm, na.rm = T))


shinyServer(function(input, output, session) {
    
    output$text <- renderText({ paste("You have submitted the word(s):", input$text) })
    
    output$text1 <- renderText({
        
        elems <- unlist(strsplit(input$text, " ") )
        
        
        if (as.numeric(word_count(input$text) == 1) && any(elems[1] == tdm.bi$dimnames$Terms$w1)) {
            
            a1 <- subset(tdm.bi$dimnames$Terms, tdm.bi$dimnames$Terms$w1 == elems[1])
            a1.1 <- stri_extract_last_words(a1)
            
            tdm.predict <- as.matrix(sort(tdm[a1.1, ], decreasing = TRUE))
            
            output$text1 <- renderText({ c("This application predicts the next word will be:", rownames(tdm.predict)[[1]])})
            
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
        
        freq <- as.matrix(findFreqTerms(tdm.uni, lowfreq = 15000, highfreq = Inf))
        output$text1 <- renderText({ c("This application predicts the next word will be:", freq[1])}) 
        
        }
        
    })
    
})
