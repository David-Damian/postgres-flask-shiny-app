shinyUI(
    dashboardPage(
    
    #Título dashboard
    dashboardHeader(title = "Vinos Dashboard"),
    
    #sidebar content
    dashboardSidebar(
      sidebarMenu(
        menuItem("Información General", tabName = "general", icon = icon("info")),
        menuItem("Datos", tabName = "tabla", icon = icon("table")),
        menuItem("EDA",tabName = "eda",icon = icon("magnifying-glass")),
        menuItem("Resultado Modelo",tabName = "resultado", icon = icon("chart-line"))
      )
    ),
    
    #Body content
    dashboardBody(
      tabItems(
        tabPanel("About", 
                 titlePanel("About"), 
                 div(includeMarkdown("aboutDB.md"), 
                     align="justify")
        ), #tabPanel(), About
        # 
        tabItem(tabName = "tabla",
                fluidPage(
                  # Application title
                  titlePanel("Registros de cada vino y sus características"),
                  # Mis objetos graficos
                  fluidRow(column(width = 10,
                                  h3("Registros de cada vino y sus características")
                  ),
                  column(width = 2,
                         downloadButton(outputId = 'wine.csv',
                                        label = "Descargar .csv")
                  )
                  )
                ),
                  fluidRow(column(width = 12,
                        dataTableOutput("tabla_datos")
        )
        ),
        ), #fin del tab Datos
        
        #EDA tab content
        tabItem(tabName = "eda",
                fluidRow(
                  #Grafica 1
                  box(plotOutput("caract",height = 250)),
                  
                  #Grafica 2
                  box(plotOutput("scatter",height = 250)),
                  
                  #Cajas input
                  box(
                    title = "Características",
                    selectInput("char", label = "Por favor seleccione la característica que desea explorar...",
                                choices = list(
                                  "pH" = 'ph',
                                  "Densidad" = 'density',
                                  "Cantidad de alcohol" = 'alcohol',
                                  "Acidez fija" = 'fixed_acidity',
                                  "Acidez volatil" = 'volatile_acidity',
                                  "Cítricos" = 'citric_acid',
                                  "Azucar residual" = 'residual_sugar',
                                  "Cloruros" = 'chlorides',
                                  "Azufre libre" = 'free_sulfur_dioxide',
                                  "Azufre total" = 'total_sulfur_dioxide',
                                  "Sulfatos" = 'sulphates'
                                ),
                                selected = 'ph')
                  ),
                  
                  box(
                    title = "Tipo de vino",
                      checkboxGroupInput("tipo", "selecciona el tipo de vino?",
                                   list(
                                     "Rojo"="red",
                                     "Blanco"="white"
                                   ),selected = "red")
                      )
                  )
                ),
        
        tabItem(tabName = "resultado",
                # Titulo del panel
                titlePanel("Reentrenamiento del modelo"),
                fluidRow(column(width = 10,
                                  h3("Introduce las siguientes características de tu vino"),
                                  h4("Una vez que rellenas todas las casillas, picale al botón ´Añadir registros´")
                  ),
                  #Cajas input
                  box(
                    title = "Característica 1",
                    numericInput("PH", label = "PH",value=2)
      
                  ),
                  
                  box(
                    title = "Característica 2",
                    numericInput("densidad", label = "Densidad",value=0.99)
                    
                  ),
                  
                  box(
                    title = "Característica 3",
                    numericInput("Cantidad de alcohol", label = "Cantidad de alcohol",value=0.99)
                    
                  ),
                  
                  
                  box(
                    title = "Caracteristica 5",
                    checkboxGroupInput("tipo", "Tipo de vino",
                                       list(
                                         "Rojo"="red",
                                         "Blanco"="white"
                                       ),selected = "red")
                  ),
                  #Por el momento esta caja es un input. Cuando ya haya resultados cambiar por un output
                  box(
                    title = "Calidad pronósticada",
                    numericInput("calidad", label = "Calidad",value=6)
                  ),
                  column(width = 2,
                         actionButton("submit", "Añadir registros") # boton para submitear nuevos datos
                  ),
                )
        )
        )
      )
    )
)