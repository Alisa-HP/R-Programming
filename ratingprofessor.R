library(RSelenium)
library(wdman)
library(netstat)
library(dplyr)
library(stringr)
library(tidyverse)
library(purrr)

remote_driver<- rsDriver(browser = "chrome",
                         chromever = "116.0.5845.96",
                         verbose = F,
                         port = free_port())


##--Step 1 connect to client
remDr <- remote_driver$client


remDr$open()

##-Step2 select site

--#navigate to site
remDr$navigate("https://www.ratemyprofessors.com/search/professors/1452?q=*")

--#click on the close button
remDr$findElement(using = "xpath", "//div[starts-with(@class, 'FullPageModal_')]//button")$clickElement()

--#click close ads
remDr$findElement(using = "xpath", "//a[@id='bx-close-inside-1177612']")$clickElement()

##--Step3 go to one professor profile
remDr$navigate("https://www.ratemyprofessors.com/professor/9310")

##--Step4 refresh page before starting

remDr$refresh()



--#create data frame
  all_reviews<-data.frame(Professor_ID= NA,
                          Professor_name = NA,
                          University = NA,
                          Department = NA,
                          Quality = NA,
                          Difficulty = NA,
                          Class_Name = NA,
                          Comment = NA,
                          Review_date = NA)




##--Step5 find number of ratings
num_of_rating <- remDr$findElement(using = 'xpath', "//a[@href='#ratingsList']")$getElementText()%>%
                                   unlist()%>%
                                   str_extract("[:digit:]+")%>%
                                   as.numeric()
--#Determine how many times to click the "Load more ratings" button
number_of_interactions<-ceiling((num_of_rating-20)/10)

if (number_of_interactions > 1) {
  for (i in 1:number_of_interactions){
  #click to load more rating
  load_more<- remDr$findElement(using = "xpath", "//button[text()='Load More Ratings']")
  y_position<- load_more$getElementLocation()$y - 100 #determine y position of element - 100
  remDr$executeScript(sprintf("window.scrollTo(0,%f)", y_position)) #scroll to the element
  load_more$clickElement() #click the element
  Sys.sleep(1.5) #pause code for one and half second
}
  }

##Step6 Extract Professor ID, Name, Department, & University  

# get teacher ID
professor_id<- remDr$getCurrentUrl()%>%
  unlist()%>%
  str_extract("[:digit:]+$") #extract from Url link


# find teacher name
professor_name <-remDr$findElement(using = "xpath", "//div[starts-with(@class, 'NameTitle__Name')]")$getElementText()%>%
                 unlist()

# find department
department <-remDr$findElement(using = "xpath", "//div[starts-with(@class, 'NameTitle__Title')]//span//b")$getElementText()%>%
  unlist()

# find university
university <-remDr$findElement(using = "xpath", "//a[@href='/school/1452']")$getElementText()%>%
  unlist()

# check rating body

rating_body<- remDr$findElements(using = "xpath", "//div[starts-with(@class, 'Rating__RatingBody')]")

##Collect review function


collect_review <- function(rating) { 
  
  quality <- rating$findChildElement(using = "xpath", "(.//div[starts-with(@class, 'CardNumRating')])[3]")$getElementText() %>% 
    unlist() %>% 
    as.numeric()
  
  difficulty <- rating$findChildElement(using = "xpath", "(.//div[starts-with(@class, 'CardNumRating')])[6]")$getElementText() %>%
    unlist() %>%
    as.numeric()
  
  class_name <- rating$findChildElement(using = "xpath", "(.//div[starts-with(@class,'RatingHeader__StyledClass')])[2]")$getElementText() %>% 
    unlist()
  
  comment <- rating$findChildElement(using = "xpath", ".//div[starts-with(@class, 'Comments__StyledComments')]")$getElementText() %>% 
    unlist()
  
  thumbs_up <- rating$findChildElement(using = "xpath", "(.//div[starts-with(@class, 'Thumbs__HelpTotal')])[1]")$getElementText() %>% 
    unlist() %>% 
    as.numeric()
  
  thumbs_down <- rating$findChildElement(using = "xpath", "(.//div[starts-with(@class, 'Thumbs__HelpTotal')])[2]")$getElementText() %>% 
    unlist() %>% 
    as.numeric()
  
  review_date <- rating$findChildElement(using = "xpath", "(.//div[starts-with(@class, 'TimeStamp')])[2]")$getElementText() %>% 
    unlist()
  
  return(list(Professor_ID = professor_id,
              Professor_Name = professor_name, 
              University = university, 
              Department = department,
              Quality = quality, 
              Difficulty = difficulty, 
              Class_Name = class_name, 
              Comment = comment, 
              Review_Date = review_date)) 
}
##Apply function to all reviews and append to all_reviews dataframe

# run the function on all review
reviews<-rating_body %>% map_dfr(~collect_review(.))

#  append the reviews to the main dataframe 
all_reviews <- bind_rows(all_reviews, reviews)

# **Running the entire program**

## initialize empty dataframe
all_reviews <- data.frame(Professor_ID = NA,
                          Professor_Name = NA,
                          University = NA,
                          Department = NA,
                          Quality = NA,
                          Difficulty = NA,
                          Class_Name = NA, 
                          Comment = NA,
                          Review_Date = NA)

--#navigate to site
  remDr$navigate("https://www.ratemyprofessors.com/search/professors/1452?q=*")

## loop to check show more professor
for (t in 1:10) {
  show_more <- remDr$findElement(using = "xpath", "//button[text()='Show More']")
  y_position <- show_more$getElementLocation()$y - 100
  remDr$executeScript(sprintf("window.scrollTo(0, %f)", y_position))  
  show_more$clickElement()
  Sys.sleep(1.5) 
}

## Locate teacher card
# locates all teacher cards displayed
teacher_cards <- remDr$findElements(using = "xpath", "//a[starts-with(@class, 'TeacherCard__StyledTeacherCard')]")

# extracts urls from teacher cards. We will need these URLs to loop over the data.
teacher_urls <- map(teacher_cards, ~.$getElementAttribute("href") %>% unlist())

#----
for (t_url in teacher_urls) {
  
  # navigate to professor's page
  remDr$navigate(t_url)
  
  # a check for skipping over professors with no ratings
  rating_check <- remDr$findElement(using = "xpath", "//div[starts-with(@class,'RatingValue__NumRatings')]")$getElementText() %>% 
    unlist()
  if (rating_check == "No ratings yet. Add a rating.") { next }
  
  #get teacher ID 
  professor_id <- remDr$getCurrentUrl() %>% 
    unlist() %>% 
    str_extract("[:digit:]+$")
  
  # find teacher name 
  professor_name <- remDr$findElement(using = "xpath", "//div[starts-with(@class, 'NameTitle__Name')]")$getElementText() %>% 
    unlist()
  
  # department 
  department <- remDr$findElement(using = "xpath", "//div[starts-with(@class, 'NameTitle__Title')]//span//b")$getElementText() %>% 
    unlist()
  
  # university 
  university <- remDr$findElement(using = "xpath", "//div[starts-with(@class, 'NameTitle__Title')]//a")$getElementText() %>%
    unlist()
  
  # find number of ratings 
  num_of_ratings <- remDr$findElement(using = 'xpath', "//a[@href='#ratingsList']")$getElementText() %>% 
    unlist() %>% 
    str_extract("[:digit:]+") %>% 
    as.numeric()
  
  # determine how many times to click the "Load More Ratings" button
  num_of_iterations <- ceiling((num_of_ratings - 20) / 10)
  
  if (num_of_iterations >= 2) { 
    for (i in 1:num_of_iterations) {
      # click to load more ratings
      load_more <- remDr$findElement(using = "xpath", "//button[text()='Load More Ratings']")
      
      y_position <- load_more$getElementLocation()$y - 100 # determine y position of element - 100
      remDr$executeScript(sprintf("window.scrollTo(0, %f)", y_position)) # scroll to the element
      load_more$clickElement() # click the element
      Sys.sleep(1) # pause code for one second
    }
  }
  
  # locate the rating body 
  rating_body <- remDr$findElements(using = 'xpath', "//div[starts-with( @class, 'Rating__RatingBody')]")
  
  # run the function on all reviews 
  reviews <- rating_body %>% map_dfr(~collect_review(.))
  
  # append the reviews to the main dataframe 
  all_reviews <- bind_rows(all_reviews, reviews)
  
  # five second pause before it moves to the next professor 
  Sys.sleep(5)
}


all_reviews %>% as_tibble()

##Remove first row of data
all_reviews <- slice(all_reviews, -1)

## Writing the dataset to a file

write_csv(all_reviews, "Rate My Professors Reviews.csv")

## Terminate the selenium server


system("taskkill /im java.exe /f")