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
        menuItem("CRUD",tabName = "crud", icon = icon("recycle"),
          menuSubItem("Model Results",tabName = "resultado", icon = icon("chart-line")),
          menuSubItem("Create",tabName = "añadir", icon = icon("upload")),
          menuSubItem("Delete",tabName = "borrar", icon = icon("trash-alt"))
        )
      )
    ),
    
    #Body content
    dashboardBody(
      tabItems(
        tabItem(tabName="general",
                fluidPage(
                 titlePanel("Descripción DB"), 
                 div(shiny::includeMarkdown("aboutDB.md"), 
                     align="justify")
                )
              ), #tabPanel(), About

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
                        DT::dataTableOutput("tabla_datos")))
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
        
        tabItem(tabName = "añadir",
                # Titulo del panel
                titlePanel("Create"),
                fluidRow(

                   box(
                    title = "Tipo de vino",
                      checkboxGroupInput("tipo", "selecciona el tipo de vino?",
                                   list(
                                     "Rojo"="red",
                                     "Blanco"="white"
                                   ),selected = "red")
                      ),

                fluidRow(
                    #Cajas input
                  #acidez-fija
                  box(
                    title = "Característica 1",
                    numericInput(inputId ="acidezfija", label = "Acidez fija",value=1)
      
                  ),
                  #acidez-volatil
                  box(
                    title = "Característica 2",
                    numericInput(inputId ="acidezvolatil", label = "Acidez volatil",value=2)
      
                  ),
                  #acid-citric
                  box(
                    title = "Característica 3",
                    numericInput(inputId ="acidcitric", label = "Citricos",value=3)
      
                  ),
                  #azucar-residual
                  box(
                    title = "Característica 4",
                    numericInput(inputId = "azucarresidual", label = "Azucar",value=4)
                    
                  ),

                  #cloruros
                  box(
                    title = "Característica 5",
                    numericInput(inputId = "cloruros", label = "CLoruros",value=5)
                    
                  ),

                 #so4 libre 
                  box(
                    title = "Característica 6",
                    numericInput(inputId = "so4libre", label = "SO4 libre",value=6)
                    
                  ),
                  #so4-total
                   box(
                    title = "Característica 7",
                    numericInput(inputId = "so4total", label = "SO4 total",value=7)
                    
                  ),
                  
                  #densidad
                   box(
                    title = "Característica 8",
                    numericInput(inputId = "densidad", label = "Densidad",value=8)
                    
                  ),

                  #PH
                   box(
                    title = "Característica 9",
                    numericInput(inputId = "PH", label = "pH",value=9)
                    
                  ),

                  #sulfatos
                   box(
                    title = "Característica 10",
                    numericInput(inputId = "sulfatos", label = "Sulfatos",value=10)
                    
                  ),


                  #sulfatos
                   box(
                    title = "Característica 11",
                    numericInput(inputId = "alcohol", label = "Alcohol",value=11)
                    
                  ),

                  #Por el momento esta caja es un input. Cuando ya haya resultados cambiar por un output
                  box(
                    title = "Calidad pronósticada",
                    numericInput("calidad", label="Calidad",value=6)
                  ),
                  column(width = 2,
                         actionButton("submit", "Añadir registro") # boton para submitear nuevos datos
                  )
                ) #end fluidrow de predecir

                )
                ),

        tabItem(tabName = "resultado",
                # Titulo del panel
                titlePanel("Predecir"),
                fluidRow(
                  #Cajas input
                  #acidez-fija
                  box(
                    title = "Característica 1",
                    numericInput(inputId ="acidezfija", label = "Acidez fija",value=7.3)
      
                  ),
                  #acidez-volatil
                  box(
                    title = "Característica 2",
                    numericInput(inputId ="acidezvolatil", label = "Acidez volatil",value=0.65)
      
                  ),
                  #acid-citric
                  box(
                    title = "Característica 3",
                    numericInput(inputId ="acidcitric", label = "Citricos",value=0)
      
                  ),
                  #azucar-residual
                  box(
                    title = "Característica 4",
                    numericInput(inputId = "azucarresidual", label = "Azucar",value=1.2)
                    
                  ),

                  #cloruros
                  box(
                    title = "Característica 5",
                    numericInput(inputId = "cloruros", label = "CLoruros",value=0.065)
                    
                  ),

                 #so4 libre 
                  box(
                    title = "Característica 6",
                    numericInput(inputId = "so4libre", label = "SO4 libre",value=15)
                    
                  ),
                  #so4-total
                   box(
                    title = "Característica 7",
                    numericInput(inputId = "so4total", label = "SO4 total",value=21)
                    
                  ),
                  
                  #densidad
                   box(
                    title = "Característica 8",
                    numericInput(inputId = "densidad", label = "Densidad",value=0.9946)
                    
                  ),

                  #PH
                   box(
                    title = "Característica 9",
                    numericInput(inputId = "PH", label = "pH",value=3.39)
                    
                  ),

                  #sulfatos
                   box(
                    title = "Característica 10",
                    numericInput(inputId = "sulfatos", label = "Sulfatos",value=0.47)
                    
                  ),


                  #sulfatos
                   box(
                    title = "Característica 11",
                    numericInput(inputId = "alcohol", label = "Alcohol",value=10)
                    
                  ),

                  #Por el momento esta caja es un input. Cuando ya haya resultados cambiar por un output
                  box(
                    title = "Calidad pronósticada",
                    textOutput(outputId = "prediccion_text")
                  ),
                  column(width = 2,
                         actionButton("confirmar", "Confirmar") # boton para submitear nuevos datos
                  ),

                  column(width = 2,
                         actionButton("predecir", "Predecir") # boton para submitear nuevos datos
                  )
                ) #end fluidrow de predecir
        ), # end predecir
        

        tabItem(tabName = "borrar",
                # Titulo del panel
                titlePanel("Delete"),
                fluidRow(
                      #Borrar registros a partir de su ID
                  box(
                    title = "Introduzca el ID  del registro a eliminar",
                    numericInput("IDreg_delete", "ID",value=6)
                  ),
                  column(width = 2,
                         actionButton("delete", "Borrar registro", 
                                      icon= icon("trash-alt") ) # boton para borrar datos
                  )
                        ) #end fluid row
        )#end tab item borrar
      ) # end tab items
    ) #end dashboard body 
  ) #end dashboardpage
) #end shinyapp