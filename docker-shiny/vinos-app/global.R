library(renv)
library(shiny)
library(shinydashboard)
library(glue)
library(tidyverse)
# libraries to make conection between PG and ShinyApp
library(httr)
library(jsonlite)
library(DT)

#wine_data <- read_csv("winequality-red-raw.csv")
url <- 'web:4999/'
response <- GET(url) #"https://geeksforgeeks.org"
wine_data <- fromJSON(content(response, as='text'))
#wine_data$quality<-as.factor(wine_data$quality)  
