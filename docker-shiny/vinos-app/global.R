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

#Variables como factor
wine_data$quality <- as.factor(wine_data$quality)
wine_data$type <- as.factor(wine_data$type)


#Variables como double
wine_data$density <- as.double(wine_data$density)
wine_data$fixed_acidity <- as.double(wine_data$fixed_acidity)
wine_data$volatile_acidity <- as.double(wine_data$volatile_acidity)
wine_data$citric_acid <- as.double(wine_data$citric_acid)
wine_data$residual_sugar <- as.double(wine_data$residual_sugar)
wine_data$chlorides <- as.double(wine_data$chlorides)
wine_data$free_sulfur_dioxide <- as.double(wine_data$free_sulfur_dioxide)
wine_data$ph <- as.double(wine_data$ph)
wine_data$sulphates <- as.double(wine_data$sulphates)
wine_data$alcohol <- as.double(wine_data$alcohol)
wine_data$total_sulfur_dioxide <- as.double(wine_data$total_sulfur_dioxide)
