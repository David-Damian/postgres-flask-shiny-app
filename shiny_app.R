#DATA PREPARATION

# move to the directory in which winequality db is stored
setwd("/home/davedamian_/Documentos/MCD_EC/postgres-flask-shiny-app/datos")
library(readr)
wine_data <- read_csv("./winequality-red-raw.csv")
#target variable from numeric to categorical(factor)
wine_data$quality<-as.factor(wine_data$quality)

#verifiying if there are missing values in de DB
is.na(wine_data) %>% sum()

#-----FRONTEND

#setting theme SUPERHERO
library(shinythemes)
ui <- fluidPage(theme = shinytheme("superhero"),
                navbarPage("¿Qué tan fino es tu vino?",
                           
                           tabPanel("Home",
                                    titlePanel("ITAMITAS pan y vino"),
                           ),  #tabPanel(), CRUD
                           
                           tabPanel("Visualización",            
  titlePanel("EDA sobre calidad de vinos"),
  sidebarPanel('Características químicas de los vinos\n',
               selectInput("wine_char", label = "Por favor seleccione la característica que desea explorar...",
                                  choices = list("pH" = 'pH',
                                                 "Densidad" = 'density',
                                                 "Cantidad de alcohol" = 'alcohol'
                                                 ),
                                  selected = 'pH')),
             #  selectInput("type", label = "Please choose type of share...",
              #             choices = list("Closing Price" = 'close_price ',
              #                            "Share Volume" = ' volume'),
              #             selected = 'close_price')),
  mainPanel('Main panel of this panel',
            
            # Output: multiple boxplots ----
            plotOutput('charcsBoxplot')),
  position = 'left'
  ),     #tabPanel(), Home
  
  
            tabPanel("CRUD",
                     titlePanel("Create, Read, Update, Delete"),
                    ),  #tabPanel(), CRUD
  
  
  tabPanel("About DB", 
           titlePanel(""), 
           div(includeMarkdown("about_database.md"), 
               align="justify")
  ) #tabPanel(), About
  
                )#navbarPage()
)#fluidPage()


#-----BACKEND

server <- function(input, output){
  output$charcsBoxplot <- renderPlot(
    {
      req(input$wine_char)
      data <- wine_data %>% select(quality, input$wine_char)
      ggplot(data = data)+geom_boxplot(aes_string(x = "quality", y = input$wine_char), 
                                       color="red", fill="orange", alpha=0.2)
    }
  )
}

shinyApp(ui = ui, server = server)
