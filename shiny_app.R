#DATA PREPARATION

# move to the directory in which winequality db is stored
setwd("here put the path in which wine DB sis stored")
library(readr)
wine_data <- read_csv("./winequality-red-raw.csv")
#target variable from numeric to categorical(factor)
wine_data$quality<-as.factor(wine_data$quality)

#verifiying if there are missing values in de DB
is.na(wine_data) %>% sum()


ui <- fluidPage(
  titlePanel("EDA sobre calidad de vinos"),
  sidebarPanel('Características químicas de los vinos\n',
               selectInput("wine_char", label = "Por favor seleccione la característica que desea eplorar...",
                                  choices = list("pH" = 'pH',
                                                 "Densidad" = 'density',
                                                 "Cantidad de alcohol" = 'alcohol'),
                                  selected = 'pH')),
             #  selectInput("type", label = "Please choose type of share...",
              #             choices = list("Closing Price" = 'close_price ',
              #                            "Share Volume" = ' volume'),
              #             selected = 'close_price')),
  mainPanel('Main panel of the app',
            # Output: multiple boxplots ----
            plotOutput('charcsBoxplot')),
  position = 'left')


server <- function(input, output){
  output$charcsBoxplot <- renderPlot(
    {
      req(input$wine_char)
      data <- wine_data %>% select(quality, input$wine_char)
      ggplot(data = data)+geom_boxplot(aes_string(x = "quality", y = input$wine_char))
    }
  )
}

shinyApp(ui = ui, server = server)
