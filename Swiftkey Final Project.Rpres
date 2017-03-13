Swiftkey Final Project
========================================================
author: Travis Porter
date: 13 March 2017
autosize: true
transition: rotate


Project Objectives and Data
========================================================

This project's data stems from Swiftkey, a London based company who builds artificial intellgence technology that predicts a user's next word on Android and iOS devices 

For more information about Swiftkey products and services: <https://swiftkey.com/en/company/>

This project's objectives include:
- Downloading, cleaning, and analyzing a large corpus of blogs, news, and Twitter text documents
- Building and sampling a predictive text model
- Taking a user input, predicting the next word and returning output value to user

Cleaning, Analyzing, and Sampling the Swiftkey Data
========================================================

- Swiftkey Data Set
    Availble for public download at <https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip>

   Data     |  Number of Elements |  Size (Mb)
----------- | ------------------- |  ---------
  blogs     |       899,288       |     248.5
  news      |        77,259       |      19.2
  twitter   |     2,360,148       |     301.4

- This project sampled and cleaned 5,000 observations from each data (blogs, news, and twitter)

    -- Data cleaning functions included converting words to lower case, removing numbers, removing curse words, removing punctuation, and removing sparse terms

- Further data analysis included buiding n-gram observations for predictive modeling 

        n-gram            |  Number of Unique n-grams
------------------------- | ------------------- 
  uni-gram    (1-word)    |         36,829
  bi-gram    (2-words)    |          6,183
  tri-gram   (3-words)    |          1,614
  quad-gram  (4-words)    |            148


How the Predictive Model Works
========================================================

This project's predictive model uses a back off approach partly used by Slava Katz's language model (1987)
<https://pdfs.semanticscholar.org/969a/9ec5f24dabcfb9c70c7ee04625075a6c0a98.pdf>

- Uses n-gram observations to calculate probability of a word from user input
- Calcuate probably of next word starting with k + 1 data where k equals the lenght of n-gram input
- If model does not find any n-gram observations, it predicts highest observed uni-gram

Example
user input : "a little" 

- model searches all tri-grams (k + 1) where first word is "a" and second word is "little" 
- identifies all possible words based off observed tri-grams
- model predicts word with highest number of observances or highest used single word if no observances found

observed tri-grams: 

   1st word |      2nd word       |    3rd word   |  # of 3rd word observances 
----------- | ------------------- |  ------------ | ---------------------------   
     a      |       little        |     better    |         280
     a      |       little        |     bit       |         151
     a      |       little        |     old       |         206
   **a**    |     **little**      |   **while**   |       **370**
     
Prediction application and recommendations: 
========================================================
This prediction application can be found on shinyapps.io at:
<https://www.shinyapps.io/admin/#/application/162878>


The project's prediction model discovered some limitations with design and opportunities for growth:

- Speed : Given its design, this project's objects requires at least 10 MB memory space, an element which increases runtime, thus hindering speed performance.  As a solution, this project used a global.R file to source large objects needed to run its predictive model.

- Scope: This project's scope limits user input to three words and predicts based on most likely next word of 1,2,3,4 word n-grams.  If a user input more than three words, the model default to most common word in corpus (the).  Furthermore, the model does well predicting if the n-gram has been obseved, but given the speed concern, accuracy does suffer with a limited sample (15,000) and only returning a single prediction (could expand to top three possibilities)

- Data: This project uses Swiftkey English data, but offers data in other languages including German, Russian, and Finnish.  Future research could explore to what extent the back-off methodology is an effective predictive model for other languages.


