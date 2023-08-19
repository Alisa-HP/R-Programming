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
  remDr$navigate("https://www.zumper.com/apartments-for-rent/north-vancouver-bc")



all_reviews<-data.frame(Price= NA,
                        Room = NA,
                        Address = NA,
                        Amenity = NA)

num_of_rating<-527

number_of_interactions<-ceiling((num_of_rating-50)/50)


if (number_of_interactions > 1) {
  for (i in 1:number_of_interactions){
    #click to load more rating
    load_more<- remDr$findElement(using = "xpath", "//a[(@class= 'chakra-button css-99a4sv')]")
    y_position<- load_more$getElementLocation()$y-120 #determine y position of element - 100
    remDr$executeScript(sprintf("window.scrollTo(0,%f)", y_position)) #scroll to the element
    load_more$clickElement() #click the element
    Sys.sleep(2) #pause code for one and half second
  }
}

rating_body<- remDr$findElements(using = "xpath", "//div[(@class= 'css-0 e1k4it830')]")


collect_review <- function(rating) { 
  
  price <- rating$findChildElement(using = "xpath", "(.//div[(@class= 'chakra-text css-17eao9z e1k4it830')]")$getElementText() %>% 
    unlist() 

  room <- rating$findChildElement(using = "xpath", "(.//p[(@class= 'chakra-text css-15ku9ij e1k4it830')])")$getElementText() %>% 
    unlist() 

  address <- rating$findChildElement(using = "xpath", "(.//p[(@class= 'chakra-text css-tfzsbo e1k4it830')])")$getElementText() %>% 
    unlist() 
  
  amenity <- rating$findChildElement(using = "xpath", "(.//div[(@class= 'css-1vcqf34 e1k4it830')])")$getElementText() %>% 
    unlist() 

  return(list(Price= price,
              Room = room,
              Address = address,
              Amenity = amenity)) 
}
  
# run the function on all review
reviews<-rating_body %>% map_dfr(~collect_review(.))

#  append the reviews to the main dataframe 
all_reviews <- bind_rows(all_reviews, reviews)  

all_reviews %>% as_tibble()  

all_reviews <- slice(all_reviews, -1)


write_csv(all_reviews, "Zumper West End.csv")
  
##____________________________________
  
price <-remDr$findElement(using = "xpath", "//div[(@class= 'css-7kwrtp e1k4it830')]")$getElementText()%>%
  unlist()

room <-remDr$findElement(using = "xpath", "//p[(@class= 'chakra-text css-15ku9ij e1k4it830')]")$getElementText()%>%
  unlist()

address <-remDr$findElement(using = "xpath", "//p[(@class= 'chakra-text css-tfzsbo e1k4it830')]")$getElementText()%>%
  unlist()

amenity <-remDr$findElement(using = "xpath", "//div[(@class= 'css-1vcqf34 e1k4it830')]")$getElementText()%>%
  unlist()

name <-remDr$findElement(using = "xpath", "//a[@target = '_blank']/[(@class = 'chakra-link css-n8rj7a e1k4it830']")$getElementText()%>%
  unlist()

//*[@id = "third"]/p[@class = "second"]